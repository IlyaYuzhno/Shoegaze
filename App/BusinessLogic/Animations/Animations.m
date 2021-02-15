//
//  Animations.m
//  Shoegaze
//
//  Created by Ilya Doroshkevitch on 09.02.2021.
//

#import "Animations.h"

#define iPhone11SaveLabelCenter CGPointMake(CGRectGetMaxX(tracklabel.frame) - 180, CGRectGetMinY(tracklabel.frame) - 80);
#define iPhoneSESaveLabelCenter CGPointMake(CGRectGetMinX(tracklabel.frame) + 200, CGRectGetMinY(tracklabel.frame) - 50);


@implementation Animations

// MARK: Save track to Favorites animation method
+(void) animateSaveTrack:(UILabel *)label favButton:(UIButton *)button trackLabel:(UILabel *)tracklabel controller:(UIViewController *)controller {
    
    CGRect endFrame = CGRectMake(label.center.x + 20, label.center.y - 50, label.frame.size.width, label.frame.size.height);
    
    [UIView animateWithDuration:0.2 animations:^{
       
        label.alpha = 1;
        label.frame = endFrame;
        label.alpha = 0;
        
        button.tintColor = [UIColor systemOrangeColor];
    } completion:^(BOOL finished){
        
        [UIView animateWithDuration:0.1 animations:^{
            button.tintColor = [UIColor colorWithRed:178/255.0 green:170/255.0 blue:156/255.0 alpha:0.2];
            
        } completion:^(BOOL finished){
            
        
            //MARK: Real devices model check
            /*
            /// iPhone model check
             //Check real device model
             NSString *model = [CheckDeviceModel deviceName];
             if ([model isEqualToString:@"iPhone SE (2nd generation)"] || [model isEqualToString:@"iPhone 8"] || [model isEqualToString:@"iPhone 7"] || [model isEqualToString:@"iPhone 6"] || [model isEqualToString:@"iPhone 6S"] ) {
                 
                 label.center = iPhoneSESaveLabelCenter;
                 
             } else {
                 
                  label.center = iPhone11SaveLabelCenter;
             }
            */
            
            //Simulator device check - to delete
            NSString *simulatorDevice = NSProcessInfo.processInfo.environment[@"SIMULATOR_DEVICE_NAME"];
            
            // iPhone SE
            if ([simulatorDevice isEqualToString:@"iPhone SE (2nd generation)"] || [simulatorDevice isEqualToString:@"iPhone 8"] || [simulatorDevice isEqualToString:@"iPhone 7"] || [simulatorDevice isEqualToString:@"iPhone 6"] || [simulatorDevice isEqualToString:@"iPhone 6S"] ) {
                
                label.center = iPhoneSESaveLabelCenter;
            }
            
            // iPhone 11
            if ([simulatorDevice isEqualToString:@"iPhone 11"] || [simulatorDevice isEqualToString:@"iPhone 12"] || [simulatorDevice isEqualToString:@"iPhone X"]) {
                
                label.center = iPhone11SaveLabelCenter;
            }
        }];
    }];
}


//MARK: Animate Track label when double tapped
+(void) animateTrackLabel:(UILabel *)label {
    
    CAKeyframeAnimation *animation = [[CAKeyframeAnimation alloc] init];
    animation.keyPath = @"transform.translation.x";
    CAMediaTimingFunction *xxx = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.timingFunction = xxx;
    animation.duration = 0.5;
    animation.values = @[@-12.0, @12.0, @-12.0, @12.0, @-6.0, @6.0, @-3.0, @3.0, @0.0];
    [label.layer addAnimation:animation forKey:@"shake"];
    
    
}


//MARK: Animate Bubble View when showed
+(void) animateBubbleView:(UIView *)bubble button:(UIButton *)button {

    
    
    //MARK: Real devices model check
    /*
    /// iPhone model check
     //Check real device model
     NSString *model = [CheckDeviceModel deviceName];
     if ([model isEqualToString:@"iPhone SE (2nd generation)"] || [model isEqualToString:@"iPhone 8"] || [model isEqualToString:@"iPhone 7"] || [model isEqualToString:@"iPhone 6"] || [model isEqualToString:@"iPhone 6S"] ) {
         
     button.hidden = YES;
     bubble.hidden = NO;
     bubble.alpha = 0.3;
     [UIView animateWithDuration:0.2 animations:^{
         [UIView modifyAnimationsWithRepeatCount:2 autoreverses: YES animations:^{
             bubble.alpha = 1;
         }];
     } completion:NULL];
     
         
     } else {
         
     bubble.hidden = NO;
     bubble.alpha = 0.3;
     [UIView animateWithDuration:0.2 animations:^{
         [UIView modifyAnimationsWithRepeatCount:2 autoreverses: YES animations:^{
             bubble.alpha = 1;
         }];
     } completion:NULL];
     }
    */
    
    //Simulator device check - to delete
    NSString *simulatorDevice = NSProcessInfo.processInfo.environment[@"SIMULATOR_DEVICE_NAME"];
    
    // iPhone SE
    if ([simulatorDevice isEqualToString:@"iPhone SE (2nd generation)"] || [simulatorDevice isEqualToString:@"iPhone 8"] || [simulatorDevice isEqualToString:@"iPhone 7"] || [simulatorDevice isEqualToString:@"iPhone 6"] || [simulatorDevice isEqualToString:@"iPhone 6S"] ) {
        
        //Hide Play/Pause Button when small-screen device
        button.hidden = YES;
        bubble.hidden = NO;
        bubble.alpha = 0.3;
        [UIView animateWithDuration:0.2 animations:^{
            [UIView modifyAnimationsWithRepeatCount:2 autoreverses: YES animations:^{
                bubble.alpha = 1;
            }];
        } completion:NULL];
    }
    
    // iPhone 11
    if ([simulatorDevice isEqualToString:@"iPhone 11"] || [simulatorDevice isEqualToString:@"iPhone 12"] || [simulatorDevice isEqualToString:@"iPhone X"]) {
        
        bubble.hidden = NO;
        bubble.alpha = 0.3;
        [UIView animateWithDuration:0.2 animations:^{
            [UIView modifyAnimationsWithRepeatCount:2 autoreverses: YES animations:^{
                bubble.alpha = 1;
            }];
        } completion:NULL];
        
    }
    
}


//MARK: Animate Play/Pause Button breathe
+(void) animatePlayButton:(UIButton *)button {

CABasicAnimation *theAnimation;
theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
theAnimation.duration=2.5;
theAnimation.repeatCount=HUGE_VALF;
theAnimation.autoreverses=YES;
theAnimation.fromValue=[NSNumber numberWithFloat:1.1];
theAnimation.toValue=[NSNumber numberWithFloat:1];
theAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
[button.layer addAnimation:theAnimation forKey:@"animateOpacity"];

}
    
//MARK: Animate Play/Pause Button tapped
+(void) animatePlayButtonTapped:(UIButton *)button {
    
    CAKeyframeAnimation *animation = [[CAKeyframeAnimation alloc] init];
    animation.keyPath = @"transform.translation.x";
    CAMediaTimingFunction *xxx = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.timingFunction = xxx;
    animation.duration = 0.5;
    animation.values = @[@-5.0, @5.0, @-5.0, @5.0, @-3.0, @3.0, @-2.0, @2.0, @0.0];
    [button.layer addAnimation:animation forKey:@"shake"];
    
}

//MARK: Animate About Menu View
+(void) animateAboutView:(AboutView *)aboutView {
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        aboutView.alpha = 1;
        
    } completion:NULL];
}

//MARK: Animate Save Band Info View

+(void) animateBandInfoView:(UIView *)infoView {
    
    infoView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
    
    [UIView animateWithDuration:0.1 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
        
        infoView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
            
    } completion:NULL];

}




    
@end
