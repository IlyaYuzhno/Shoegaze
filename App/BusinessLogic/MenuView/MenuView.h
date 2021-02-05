//
//  MenuView.h
//  Shoegaze
//
//  Created by Ilya Doroshkevitch on 05.02.2021.
//

#import <UIKit/UIKit.h>
#import "MainViewContoller.h"

NS_ASSUME_NONNULL_BEGIN

@interface MenuView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *menuItems;

@end

NS_ASSUME_NONNULL_END
