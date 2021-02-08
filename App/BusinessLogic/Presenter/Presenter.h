//
//  Presenter.h
//  Shoegaze
//
//  Created by Ilya Doroshkevitch on 08.02.2021.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface Presenter : NSObject

+(UILabel *) setTrackLabel:(UILabel *)label controller:(UIViewController *)controller;
+(UIButton *) setPlayButton:(UIButton *)button trackLabel:(UILabel *)label controller:(UIViewController *)controller;
+(UIButton *) setFavoritesButtonView:(UIButton *)button controller:(UIViewController *)controller;
+(UIButton *) setBugrMenuButtonView:(UIButton *)button controller:(UIViewController *)controller;



@end

NS_ASSUME_NONNULL_END
