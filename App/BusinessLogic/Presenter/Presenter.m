//
//  Presenter.m
//  Shoegaze
//
//  Created by Ilya Doroshkevitch on 08.02.2021.
//

#import "Presenter.h"


#define iPhoneSEPlayButtonFrame CGRectMake ((controller.view.bounds.size.width / 2) - 100, [UIScreen mainScreen].bounds.size.height - 250, 200, 200);
#define iPhone11PlayButtonFrame CGRectMake ((controller.view.bounds.size.width / 2) - 100, CGRectGetMaxY(label.frame) + 240, 200, 200);
#define iPhone11SaveLabelCenter CGPointMake(CGRectGetMaxX(tracklabel.frame) - 180, CGRectGetMinY(tracklabel.frame) - 80);
#define iPhoneSESaveLabelCenter CGPointMake(CGRectGetMinX(tracklabel.frame) + 200, CGRectGetMinY(tracklabel.frame) - 50);

static UIVisualEffect *blurEffect;
static UIVisualEffectView *visualEffectView;
NSString *model;
NSString *simulatorDevice;


@implementation Presenter

//Check device model in class init from MainViewController
+ (void)initialize {
  if (self == [Presenter self]) {
      model = [CheckDeviceModel deviceName];
      simulatorDevice = NSProcessInfo.processInfo.environment[@"SIMULATOR_DEVICE_NAME"];
  }
}

//MARK: Set Track Label
+(UILabel *) setTrackLabel:(UILabel *)label y:(int)y controller:(UIViewController *)controller {
        
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, y, [UIScreen mainScreen].bounds.size.width - 20, 140)];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.adjustsFontSizeToFitWidth = NO;
    label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:[UIFont systemFontOfSize:36]];
    label.userInteractionEnabled = YES;
    return label;

}

//MARK: Set Play/Pause Button
+(UIButton *) setPlayButton:(UIButton *)button trackLabel:(UILabel *)label controller:(UIViewController *)controller {
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];

    //MARK: Real devices model check
    /*
    /// iPhone model check
     if ([model isEqualToString:@"iPhone SE (2nd generation)"] || [model isEqualToString:@"iPhone 8"] || [model isEqualToString:@"iPhone 7"] || [model isEqualToString:@"iPhone 6"] || [model isEqualToString:@"iPhone 6S"] ) {
         
         button.frame = iPhoneSEPlayButtonFrame;
         
     } else {
         
         button.frame = iPhone11PlayButtonFrame;
     }
    */
    
    
    //MARK: Simulator devices check - to delete
    // iPhone model check
    if ([simulatorDevice isEqualToString:@"iPhone SE (2nd generation)"] || [simulatorDevice isEqualToString:@"iPhone 8"] || [simulatorDevice isEqualToString:@"iPhone 7"] || [simulatorDevice isEqualToString:@"iPhone 6"] || [simulatorDevice isEqualToString:@"iPhone 6S"] ) {
        
        button.frame = iPhoneSEPlayButtonFrame;
        
    } else {
        
        button.frame = iPhone11PlayButtonFrame;
    }
    
    button.clipsToBounds = YES;
    button.tag = 0;
    [button setTitle:@"PAUSE" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:21.0];
    //_button.translatesAutoresizingMaskIntoConstraints = NO;
    CGFloat radius = MIN(button.frame.size.width, button.frame.size.height) / 2.0;
    button.layer.cornerRadius = radius;
    [button.layer setMasksToBounds:YES];
    [button.layer setBorderWidth:4.0f];
    [button.layer setBorderColor:[[UIColor colorWithRed:178/255.0 green:170/255.0 blue:156/255.0 alpha:0.4] CGColor]];

    return button;
}

//MARK: Set Favorites Button View
+(UIButton *) setFavoritesButtonView:(UIButton *)button controller:(UIViewController *)controller {
    
    button = [[UIButton alloc] initWithFrame:CGRectMake(controller.view.bounds.size.width - 30, CGRectGetMinY(controller.view.frame) + 70, 80, 80)];
    UIImage *img = [UIImage systemImageNamed:@"star"];
    [button setImage:img forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    button.tintColor =[UIColor colorWithRed:178/255.0 green:170/255.0 blue:156/255.0 alpha:0.2];
    return button;
}

//MARK: Set Bugr Menu Button View
+(UIButton *) setBugrMenuButtonView:(UIButton *)button controller:(UIViewController *)controller {
    
    button= [[UIButton alloc] initWithFrame:CGRectMake(controller.view.bounds.size.width - 30, CGRectGetMinY(controller.view.frame) + 70, 80, 80)];
    UIImage *imgBugr = [UIImage systemImageNamed:@"lineweight"];
    [button setImage:imgBugr forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    button.tintColor = [UIColor colorWithRed:178/255.0 green:170/255.0 blue:156/255.0 alpha:0.2];
    button.tag = 0;
    return button;
}

//MARK: Set Save Track pop-up label
+(UILabel *) setSaveTrackLabel:(UILabel *)label trackLabel:(UILabel *)tracklabel controller:(UIViewController *)controller {
 
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    
    //MARK: Real devices model check
    /*
    // iPhone SE
     if ([model isEqualToString:@"iPhone SE (2nd generation)"] || [model isEqualToString:@"iPhone 8"] || [model isEqualToString:@"iPhone 7"] || [model isEqualToString:@"iPhone 6"] || [model isEqualToString:@"iPhone 6S"] ) {
         
         label.center = iPhoneSESaveLabelCenter;
         
     } else {
         
         label.center = iPhone11SaveLabelCenter;
     }
    */
    
    
    //MARK: Simulator devices check - to delete
    
    // iPhone SE
    if ([simulatorDevice isEqualToString:@"iPhone SE (2nd generation)"] || [simulatorDevice isEqualToString:@"iPhone 8"] || [simulatorDevice isEqualToString:@"iPhone 7"] || [simulatorDevice isEqualToString:@"iPhone 6"] || [simulatorDevice isEqualToString:@"iPhone 6S"] ) {
        
        label.center = iPhoneSESaveLabelCenter;
        
    } else {
        
        label.center = iPhone11SaveLabelCenter;
    }
    
    label.text = @"SAVED";
    label.textColor = [UIColor systemPinkColor];
    label.backgroundColor = [UIColor clearColor];
    label.alpha = 0;
    [label setFont:[UIFont boldSystemFontOfSize:24]];
    return label;
}


//MARK: Set one-time start info Bubble View
+(UIView *) setStartBubbleView: (UIView *)view trackLabel:(UILabel *)tracklabel controller:(UIViewController *)controller {
 
    //MARK: Real devices model check
    /*
    // iPhone model check
     if ([model isEqualToString:@"iPhone SE (2nd generation)"] || [model isEqualToString:@"iPhone 8"] || [model isEqualToString:@"iPhone 7"] || [model isEqualToString:@"iPhone 6"] || [model isEqualToString:@"iPhone 6S"] ) {
         
         view= [[BubbleView alloc] initWithFrame:CGRectMake(110, CGRectGetMinY(tracklabel.frame) + 115, 300, 250)];
     } else {
         
         view= [[BubbleView alloc] initWithFrame:CGRectMake(140, CGRectGetMinY(tracklabel.frame) + 115, 300, 250)];
     }
    */
    
    
    //MARK: Simulator devices check - to delete
    
    // iPhone model check
    if ([simulatorDevice isEqualToString:@"iPhone SE (2nd generation)"] || [simulatorDevice isEqualToString:@"iPhone 8"] || [simulatorDevice isEqualToString:@"iPhone 7"] || [simulatorDevice isEqualToString:@"iPhone 6"] || [simulatorDevice isEqualToString:@"iPhone 6S"] ) {
        
        view= [[BubbleView alloc] initWithFrame:CGRectMake(110, CGRectGetMinY(tracklabel.frame) + 140, 300, 250)];
    } else {
        
        view= [[BubbleView alloc] initWithFrame:CGRectMake(140, CGRectGetMinY(tracklabel.frame) + 115, 300, 250)];
    }
    
    view.backgroundColor = [UIColor clearColor];
    
    //Set Close button
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(200, 156, 50, 50)];
    [closeButton setTitle:@"OK" forState:UIControlStateNormal];
    closeButton.backgroundColor = [UIColor greenColor];
    
    [closeButton addTarget:self action:@selector(closeBubbleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:closeButton];
    
    return view;
}


//MARK: One-time start info Bubble View Close button pressed method
+(void)closeBubbleButtonPressed:(UIButton *)sender {
        
    //Send notification when Close Bubble pressed
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeBubblePressed" object:nil userInfo:nil];
    
}

//MARK: Set Artist Info View loaded from LastFM API
+(UIView *) setArtistInfoView:(UIView *)view text:(NSMutableString *)text viewHeight:(int) height{

    //MARK: Real devices model check
    /*
    // iPhone model check
     if ([model isEqualToString:@"iPhone SE (2nd generation)"] || [model isEqualToString:@"iPhone 8"] || [model isEqualToString:@"iPhone 7"] || [model isEqualToString:@"iPhone 6"] || [model isEqualToString:@"iPhone 6S"] ) {
         
     view = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.origin.x + 10, [UIScreen mainScreen].bounds.origin.y + 30, [UIScreen mainScreen].bounds.size.width - 20, [UIScreen mainScreen].bounds.size.height - 180)];
     } else {
         
     view = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.origin.x + 10, [UIScreen mainScreen].bounds.origin.y + 70, [UIScreen mainScreen].bounds.size.width - 20, [UIScreen mainScreen].bounds.size.height - height)];
     }
    */
    
    
    //MARK: Simulator devices check - to delete
    // iPhone model check
    if ([simulatorDevice isEqualToString:@"iPhone SE (2nd generation)"] || [simulatorDevice isEqualToString:@"iPhone 8"] || [simulatorDevice isEqualToString:@"iPhone 7"] || [simulatorDevice isEqualToString:@"iPhone 6"] || [simulatorDevice isEqualToString:@"iPhone 6S"] ) {
        
        view = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.origin.x + 10, [UIScreen mainScreen].bounds.origin.y + 30, [UIScreen mainScreen].bounds.size.width - 20, [UIScreen mainScreen].bounds.size.height - 180)];
        
    } else {
               
        view = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.origin.x + 10, [UIScreen mainScreen].bounds.origin.y + 70, [UIScreen mainScreen].bounds.size.width - 20, [UIScreen mainScreen].bounds.size.height - height)];
        
    }
 
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 8;
    view.clipsToBounds = YES;
    
    //Set title label
    UILabel *viewTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width, 40)];
    viewTitle.backgroundColor = [UIColor clearColor];
    viewTitle.text = @"BAND INFO:";
    [viewTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:22.0f]];
    viewTitle.layer.cornerRadius = 8;
    viewTitle.clipsToBounds = YES;
    [view addSubview:viewTitle];
    
    
    //Set TextView
    UITextView *infoTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(viewTitle.frame), view.bounds.size.width, view.bounds.size.height - 90)];
    infoTextView.text = text;
    infoTextView.backgroundColor = [UIColor clearColor];
    infoTextView.editable = NO;
    [infoTextView setFont:[UIFont fontWithName:@"HelveticaNeue" size:22.0f]];
    [view addSubview:infoTextView];
    

    //Set Close button
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(0, view.bounds.size.height - 50, view.bounds.size.width, 50)];
    [closeButton setTitle:@"CLOSE" forState:UIControlStateNormal];
    closeButton.backgroundColor = [UIColor greenColor];
    closeButton.layer.cornerRadius = 8;
    
    [closeButton addTarget:self action:@selector(closeArtistInfoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:closeButton];

    return view;
}

//MARK: Artist Info View Close button pressed method
+(void)closeArtistInfoButtonPressed:(UIButton *)sender {
        
    //Send notification when Close Info pressed
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeArtistInfoButtonPressed" object:nil userInfo:nil];
    
}

//MARK: Set Blur effect
+(void) blurEffect:(UIView *)view controller:(UITableViewController *)controller {
    
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent];
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];

    [[visualEffectView contentView] addSubview:view];
    visualEffectView.frame = controller.view.bounds;

    [controller.view addSubview:visualEffectView];
    
    
}

//MARK: Remove Blur effect
+(void) removeBlurEffect {
    
    [visualEffectView removeFromSuperview];
    
}


@end
