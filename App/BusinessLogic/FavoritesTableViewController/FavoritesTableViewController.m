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

@end

@implementation FavoritesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"❤️❤️❤️";
    
    //MARK: Create local data source from global
    //more secure I think :)
    _favoritesArray = [NSMutableArray new];
    
    //Get saved tracks info in global queue
    dispatch_queue_t queue = dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0);
    dispatch_sync(queue, ^{
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
    _searchBar.placeholder = @"Search shoegaze...";
    
    
    //MARK: Create info view
    _artistInfoView = [[UIView alloc] init];
    
    //Set table view params
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"favoritesCell"];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //Subscribe to notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeArtistInfoView) name: @"closeArtistInfoButtonPressed" object:nil];
    
    
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _filteredArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"favoritesCell" forIndexPath:indexPath];
    
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


//MARK: Edit rows and update Global Storage
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //Delete the row from the local data source
        [_favoritesArray removeObjectAtIndex:indexPath.row];
        _filteredArray =_favoritesArray;
        
        //Delete row from the global storage
        [[SavedTracksStorage sharedInstance].savedTracks removeObjectAtIndex:indexPath.row];
        
        //Save updated global storage to UserDefaults
        dispatch_queue_t queue = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0);
        dispatch_async(queue, ^{
            [[NSUserDefaults standardUserDefaults] setObject:[SavedTracksStorage sharedInstance].savedTracks forKey:@"Favorites"];
        });

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

//MARK: Tap cell to read artist info
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // Get artist name and track name from trackLabel text to search info
    NSString *artistName = [cell.textLabel.text componentsSeparatedByString:@" -"][0];
    //NSString *trackName = [_trackLabel.text componentsSeparatedByString:@"- "][1];
    
    //Get artist info async
    dispatch_queue_t queue = dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0);
    dispatch_async(queue, ^{
    [self getInfoFromLastFM:artistName];
        });
}

//MARK: Get artist info from LastFM API via APIManager
- (void) getInfoFromLastFM:(NSString *)artistName {
    
    [[APIManager sharedInstance] artistWithRequest:artistName withCompletion:^(NSMutableString *info) {
        if (!info || [info isEqualToString:@""]) {
            // INFO not exist or empty
            
            [self infoNotExists];

        } else {
            // INFO exists but may be contains only ahref
            
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
                self->_artistInfoView = [Presenter setArtistInfoView:self->_artistInfoView text:text];
                //add blur effect
                [Presenter blurEffect:self->_artistInfoView controller:self];
                //show info view
                [self.view addSubview:self->_artistInfoView];
                
            }
        }
    }];
}

//MARK: What to do if Band INFO is bad
-(void) infoNotExists {
    NSMutableString *noInfoLoaded =[NSMutableString stringWithString:@"SEEMS LIKE NO INFO ABOUT THIS BAND YET..."];
    self->_artistInfoView = [Presenter setArtistInfoView:self->_artistInfoView text:noInfoLoaded];
    //add blur effect
    [Presenter blurEffect:self->_artistInfoView controller:self];
    //show info view
    [self.view addSubview:self->_artistInfoView];
    
}


//MARK: Close Artist Info View and remove blur
-(void)closeArtistInfoView {
    
    [Presenter removeBlurEffect];
    [_artistInfoView removeFromSuperview];
    
}


//MARK: Remove observers
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
