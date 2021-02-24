//
//  FavoritesTableViewController.h
//  Shoegaze
//
//  Created by Ilya Doroshkevitch on 04.02.2021.
//

#import <UIKit/UIKit.h>
#import "APIManager.h"
#import "Presenter.h"
#import "Animations.h"
#import "CheckSystemMemory.h"
#import "NetworkErrorView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FavoritesTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@end

NS_ASSUME_NONNULL_END
