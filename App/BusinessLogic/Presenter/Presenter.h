//
//  Presenter.h
//  Shoegaze
//
//  Created by Ilya Doroshkevitch on 08.02.2021.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BubbleView.h"
#import <sys/utsname.h>
#import "CheckDeviceModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface Presenter : NSObject

+(UILabel *) setTrackLabel:(UILabel *)label y:(int)y controller:(UIViewController *)controller;
+(UIButton *) setPlayButton:(UIButton *)button trackLabel:(UILabel *)label controller:(UIViewController *)controller;
+(UIButton *) setFavoritesButtonView:(UIButton *)button controller:(UIViewController *)controller;
+(UIButton *) setBugrMenuButtonView:(UIButton *)button controller:(UIViewController *)controller;
+(UILabel *) setSaveTrackLabel:(UILabel *)label trackLabel:(UILabel *)tracklabel controller:(UIViewController *)controller;
+(UIView *) setStartBubbleView: (UIView *)view trackLabel:(UILabel *)tracklabel controller:(UIViewController *)controller;
+(void)closeBubbleButtonPressed:(UIButton *)sender;
+(UIView *) setArtistInfoView:(UIView *)view text:(NSMutableString *)text viewHeight:(int) height;
+(void) blurEffect:(UIView *)view controller:(UITableViewController *)controller;
+(void) removeBlurEffect;

@end

NS_ASSUME_NONNULL_END
