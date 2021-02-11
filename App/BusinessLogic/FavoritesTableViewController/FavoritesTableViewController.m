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

@end

@implementation FavoritesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"❤️❤️❤️";
    
    //MARK: Create local data source from global
    //more secure I think :)
    _favoritesArray = [NSMutableArray new];
    _favoritesArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Favorites"] mutableCopy];
    _filteredArray = _favoritesArray;
    
    //MARK: Add SearchBar
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    _searchBar.delegate = self;
    self.tableView.tableHeaderView = _searchBar;
    _searchBar.placeholder = @"Search shoegaze...";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"favoritesCell"];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


//MARK: Edit rows and update Global Storage
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //Delete the row from the local data source
        [_favoritesArray removeObjectAtIndex:indexPath.row];
        
        //Delete row from the global storage
        [[SavedTracksStorage sharedInstance].savedTracks removeObjectAtIndex:indexPath.row];
        
        //Save updated global storage to UserDefaults
        [[NSUserDefaults standardUserDefaults] setObject:[SavedTracksStorage sharedInstance].savedTracks forKey:@"Favorites"];
        
        _filteredArray = _favoritesArray;
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
