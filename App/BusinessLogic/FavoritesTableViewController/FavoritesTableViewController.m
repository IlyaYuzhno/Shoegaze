//
//  FavoritesTableViewController.m
//  Shoegaze
//
//  Created by Ilya Doroshkevitch on 04.02.2021.
//

#import "FavoritesTableViewController.h"

@interface FavoritesTableViewController ()

@property (strong, nonatomic) NSMutableArray *favoritesArray;
@property (nonatomic, strong) NSArray *filteredArray;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) UIView *artistInfoView;
@property (strong, nonatomic) NSMutableDictionary *bandInfoCache;
@property (strong, nonatomic) NetworkErrorView *networkErrorView;

@end

@implementation FavoritesTableViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    self.navigationController.navigationBar.titleTextAttributes
    = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationController.navigationBar.largeTitleTextAttributes
    = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"F A V O R I T E S";
    self.tableView.backgroundColor = [UIColor blackColor];
    
    //MARK: Create local data source from global
    //more secure I think :)
    _favoritesArray = [NSMutableArray new];
    _filteredArray = [NSArray new];
    _bandInfoCache = [NSMutableDictionary new];
    
    //MARK: Get saved tracks info async
    dispatch_queue_t queue = dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0);
    dispatch_async(queue, ^{
        self->_favoritesArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Favorites"] mutableCopy];
        self->_filteredArray = self->_favoritesArray;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
    
    //MARK: Add SearchBar
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    _searchBar.delegate = self;
    self.tableView.tableHeaderView = _searchBar;
    _searchBar.barTintColor = [UIColor clearColor];
    _searchBar.placeholder = @"Search shoegaze...";
    
    
    //MARK: Add info view
    _artistInfoView = [[UIView alloc] init];
    
    //MARK: Add network error view
    _networkErrorView = [[NetworkErrorView alloc] initWithFrame:CGRectMake(10, -80, [UIScreen mainScreen].bounds.size.width - 20, 70)];
    [self.tableView addSubview:_networkErrorView];
    
    
    //MARK: Set table view params
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"favoritesCell"];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //MARK: Subscribe to notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeArtistInfoView) name: @"closeArtistInfoButtonPressed" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkErrorOn) name:@"internetError" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkErrorOff) name:@"internetReachable" object:nil];
    
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _filteredArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"favoritesCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:24];
    cell.textLabel.text = _filteredArray[indexPath.row];
    
    return cell;
}


//MARK: SearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSString *evaluatedString, NSDictionary *bindings) {
            return [evaluatedString containsString:searchText];
        }];
        self.filteredArray = [self.favoritesArray filteredArrayUsingPredicate:predicate];
    }
    else {
        self.filteredArray = self.favoritesArray;
    }
    [self.tableView reloadData];
    
}


//MARK: Edit rows and update Global UserDefaults Storage
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //Delete the row from the local data source
        [_favoritesArray removeObjectAtIndex:indexPath.row];
        _filteredArray =_favoritesArray;
        
        //Save updated to UserDefaults
        [[NSUserDefaults standardUserDefaults] setObject:self->_favoritesArray forKey:@"Favorites"];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

//MARK: Tap cell to read artist info
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // Get artist name and track name from trackLabel text to search info
    NSString *artistName = [cell.textLabel.text componentsSeparatedByString:@" -"][0];
    
    //Get artist info async
    dispatch_queue_t queue = dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0);
    dispatch_async(queue, ^{
        [self getInfoFromLastFM:artistName];
    });
}

//MARK: Get artist info from LastFM API via APIManager
- (void) getInfoFromLastFM:(NSString *)artistName {
    
    //Read band info from cache
    _bandInfoCache = [[[NSUserDefaults standardUserDefaults] objectForKey:@"bandInfoCache"] mutableCopy];
    
    //Check if band info exists in cache
    if ([_bandInfoCache objectForKey:artistName]) {
        
        //INFO EXISTS
        
        //Get info text
        NSMutableString *text = [_bandInfoCache valueForKey:artistName];
        
        //Show good text in main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self->_artistInfoView = [Presenter setArtistInfoView:self->_artistInfoView text:text viewHeight:300];
            
            //add blur effect
            [Presenter blurEffect:self->_artistInfoView controller:self];
            
            //show info view and animate it
            [self.view addSubview:self->_artistInfoView];
            [Animations animateBandInfoView:self->_artistInfoView];
        });
        
    } else {
        
        // INFO NOT EXISTS so get it from LastFM
        
        [[APIManager sharedInstance] artistWithRequest:artistName withCompletion:^(NSMutableString *info) {
            if (!info || [info isEqualToString:@""]) {
                // INFO not exist or empty
                
                [self infoNotExists];
                
            } else {
                // INFO exists but may contain only ahref
                
                //Get ahref from INFO to compare with INFO itself
                NSMutableString *href = [NSMutableString stringWithString:[info componentsSeparatedByString:@" <"][1]];
                NSString *ahref = [@" <" stringByAppendingString:href];
                
                //Compare INFO and ahref
                if ([info isEqualToString:ahref]) {
                    
                    [self infoNotExists];
                    
                } else {
                    // INFO exists and OK
                    
                    //Get only useful text from good INFO
                    NSMutableString *text = [NSMutableString stringWithString:[info componentsSeparatedByString:@" <"][0]]; // remove a href from info
                    
                    //Show good text
                    self->_artistInfoView = [Presenter setArtistInfoView:self->_artistInfoView text:text viewHeight:300];
                    
                    //add blur effect
                    [Presenter blurEffect:self->_artistInfoView controller:self];
                    
                    //show info view and animate it
                    [self.view addSubview:self->_artistInfoView];
                    [Animations animateBandInfoView:self->_artistInfoView];
                    
                    //Check system memory and add new band info to cache
                    uint64_t freeMemory = [CheckSystemMemory getFreeDiskspace];
                    
                    if (freeMemory > 120) {
                        [self->_bandInfoCache setObject:text forKey:artistName];
                        dispatch_queue_t queue = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0);
                        dispatch_async(queue, ^{
                            [[NSUserDefaults standardUserDefaults] setObject:self->_bandInfoCache forKey:@"bandInfoCache"];
                        });
                    }
                }
            }
        }];
    }
}

//MARK: What to do if Band INFO is bad
-(void) infoNotExists {
    NSMutableString *noInfoLoaded =[NSMutableString stringWithString:@"SEEMS LIKE NO INFO ABOUT THIS BAND YET..."];
    self->_artistInfoView = [Presenter setArtistInfoView:self->_artistInfoView text:noInfoLoaded viewHeight:700];
    //add blur effect
    [Presenter blurEffect:self->_artistInfoView controller:self];
    //show info view
    [self.view addSubview:self->_artistInfoView];
    [Animations animateBandInfoView:self->_artistInfoView];
}


//MARK: Close Artist Info View and remove blur
-(void)closeArtistInfoView {
    
    [Presenter removeBlurEffect];
    [_artistInfoView removeFromSuperview];
    
}

//MARK: Show Network Error View
-(void) networkErrorOn {
    
    [Animations animateNetworkErrorViewSlideOn:_networkErrorView];
}


//MARK: Hide Network Error View
-(void) networkErrorOff {
    
    [Animations animateNetworkErrorViewSlideOff:_networkErrorView];
}


//MARK: Remove observers
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
