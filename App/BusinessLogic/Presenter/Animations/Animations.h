//
//  Animations.h
//  Shoegaze
//
//  Created by Ilya Doroshkevitch on 09.02.2021.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AboutView.h"
#import "CheckDeviceModel.h"
#import "MenuView.h"



NS_ASSUME_NONNULL_BEGIN

@interface Animations : NSObject

+(void) animateSaveTrack:(UILabel *)label favButton:(UIButton *)button trackLabel:(UILabel *)tracklabel controller:(UIViewController *)controller;
+(void) animateTrackLabel:(UILabel *)label;
+(void) animateBubbleView:(UIView *)bubble button:(UIButton *)button;
+(void) animatePlayButton:(UIButton *)button;
+(void) animatePlayButtonTapped:(UIButton *)button;
+(void) animateAboutView:(AboutView *)aboutView;
+(void) animateBandInfoView:(UIView *)infoView;
+(void) animateAboutViewSlideOn:(UIView *)menuView;
+(void) animateAboutViewSlideOff:(UIView *)menuView;
+(void) animateNetworkErrorViewSlideOn:(UIView *)networkErrorView;
+(void) animateNetworkErrorViewSlideOff:(UIView *)networkErrorView;
+(void) animateBufferingAudioViewSlideOn:(UIView *)bufferingAudioView;
+(void) animateBufferingAudioViewSlideOff:(UIView *)bufferingAudioView;

@end

NS_ASSUME_NONNULL_END
