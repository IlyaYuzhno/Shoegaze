//
//  MenuView.m
//  Shoegaze
//
//  Created by Ilya Doroshkevitch on 05.02.2021.
//

#import "MenuView.h"

@implementation MenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITableView *tblView = [[UITableView alloc]initWithFrame:self.bounds];
        tblView.delegate = self;
        tblView.dataSource = self;
        [tblView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"menuCell"];
        tblView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tblView.backgroundColor = [UIColor clearColor];
        tblView.layer.cornerRadius = 6;
        tblView.clipsToBounds = YES;
        [self addSubview:tblView];
        
        _menuItems = @[@"ABOUT"];
        
    }
    return self;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _menuItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:@"menuCell"];
    }
    
    cell.textLabel.text = _menuItems[indexPath.row];
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    //cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    cell.contentView.layer.cornerRadius = 6;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"pressed");
    
    //Send notification when About pressed
    [[NSNotificationCenter defaultCenter] postNotificationName:@"aboutPressed" object:nil userInfo:nil];
//
//    MainViewContoller *mainVC = [[MainViewContoller alloc] init];
//    [mainVC showAboutView];
    
}




@end
