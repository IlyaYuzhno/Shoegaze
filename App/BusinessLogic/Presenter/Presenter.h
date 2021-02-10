//
//  Presenter.h
//  Shoegaze
//
//  Created by Ilya Doroshkevitch on 08.02.2021.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BubbleView.h"

NS_ASSUME_NONNULL_BEGIN

@interface Presenter : NSObject

+(UILabel *) setTrackLabel:(UILabel *)label controller:(UIViewController *)controller;
+(UIButton *) setPlayButton:(UIButton *)button trackLabel:(UILabel *)label controller:(UIViewController *)controller;
+(UIButton *) setFavoritesButtonView:(UIButton *)button controller:(UIViewController *)controller;
+(UIButton *) setBugrMenuButtonView:(UIButton *)button controller:(UIViewController *)controller;
+(UILabel *) setSaveTrackLabel:(UILabel *)label trackLabel:(UILabel *)tracklabel controller:(UIViewController *)controller;
+(UIView *) setStartBubbleView: (UIView *)view trackLabel:(UILabel *)tracklabel controller:(UIViewController *)controller;
+(void)closeBubbleButtonPressed:(UIButton *)sender;
+(UIImageView *) setArtistImageView: (UIImageView *)view controller:(UIViewController *)controller;

@end

NS_ASSUME_NONNULL_END
