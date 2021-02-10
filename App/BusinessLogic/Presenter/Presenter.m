//
//  Presenter.m
//  Shoegaze
//
//  Created by Ilya Doroshkevitch on 08.02.2021.
//

#import "Presenter.h"

@implementation Presenter

//MARK: Set Track Label
+(UILabel *) setTrackLabel:(UILabel *)label controller:(UIViewController *)controller {
    
    //label = [[UILabel alloc] initWithFrame:CGRectMake(10, (controller.view.bounds.size.height / 2) - 100, controller.view.bounds.size.width - 20, 140.0)];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, ([UIScreen mainScreen].bounds.size.height / 2) - 200, [UIScreen mainScreen].bounds.size.width - 20, 140)];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.adjustsFontSizeToFitWidth = NO;
    label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:[UIFont systemFontOfSize:36]];
    //[label setFont:[UIFont fontWithName:@"Proxima Nova Light" size:30]];
    
    label.userInteractionEnabled = YES;
    return label;

}

//MARK: Set Play/Pause Button
+(UIButton *) setPlayButton:(UIButton *)button trackLabel:(UILabel *)label controller:(UIViewController *)controller {
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
     [button setFrame:CGRectMake((controller.view.bounds.size.width / 2) - 100, CGRectGetMaxY(label.frame) + 200, 200, 200)];
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
    label.center = CGPointMake(CGRectGetMaxX(tracklabel.frame) - 180, CGRectGetMinY(tracklabel.frame) - 110);
    label.text = @"SAVED";
    label.textColor = [UIColor systemPinkColor];
    label.backgroundColor = [UIColor clearColor];
    label.alpha = 0;
    [label setFont:[UIFont boldSystemFontOfSize:24]];
    return label;
}


//MARK: Set one-time start info Bubble View
+(UIView *) setStartBubbleView: (UIView *)view trackLabel:(UILabel *)tracklabel controller:(UIViewController *)controller {
    
    //Set view
    view= [[BubbleView alloc] initWithFrame:CGRectMake(140, CGRectGetMinY(tracklabel.frame) - 220, 300, 250)];
    view.backgroundColor = [UIColor clearColor];
    
    //Set Close button
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(220, 45, 50, 50)];
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



//MARK: Set Artist Image View loaded from LastFM API - !!!currently doesn't work!!!
+(UIImageView *) setArtistImageView: (UIImageView *)view controller:(UIViewController *)controller {
    
    view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (controller.view.bounds.size.width - 10), 250)];
    view.center = CGPointMake(controller.view.frame.size.width / 2, (controller.view.frame.size.height / 2) - 200);
    view.layer.cornerRadius = 5;
    view.backgroundColor = [UIColor redColor];
    
    return view;
    
}


@end
