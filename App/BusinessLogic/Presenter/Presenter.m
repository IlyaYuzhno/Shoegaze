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
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, (controller.view.bounds.size.height / 2) - 100, controller.view.bounds.size.width - 20, 140.0)];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.adjustsFontSizeToFitWidth = NO;
    label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:[UIFont boldSystemFontOfSize:24]];
    label.userInteractionEnabled = YES;
    return label;

}

//MARK: Set Play/Pause Button
+(UIButton *) setPlayButton:(UIButton *)button trackLabel:(UILabel *)label controller:(UIViewController *)controller {
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
     [button setFrame:CGRectMake((controller.view.bounds.size.width / 2) - 100, CGRectGetMaxY(label.frame) + 100, 200, 200)];
    button.clipsToBounds = YES;
    button.tag = 0;
    [button setTitle:@"PAUSE" forState:UIControlStateNormal];
    //_button.translatesAutoresizingMaskIntoConstraints = NO;
    CGFloat radius = MIN(button.frame.size.width, button.frame.size.height) / 2.0;
    button.layer.cornerRadius = radius;
    [button.layer setMasksToBounds:YES];
    [button.layer setBorderWidth:4.0f];
    [button.layer setBorderColor:[[UIColor colorWithRed:178/255.0 green:170/255.0 blue:156/255.0 alpha:0.4] CGColor]];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];

    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[UIColor colorWithRed:0.841 green:0.566 blue:0.566 alpha:1.0].CGColor, (id)[UIColor colorWithRed:0.75 green:0.341 blue:0.345 alpha:1.0].CGColor, (id)[UIColor colorWithRed:0.592 green:0.0 blue:0.0 alpha:1.0].CGColor, (id)[UIColor colorWithRed:0.592 green:0.0 blue:0.0 alpha:1.0].CGColor, nil]];
    
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.lineWidth = 3;
    [shape setPath:[[UIBezierPath bezierPathWithRect:button.bounds] CGPath]];
    shape.strokeColor = [UIColor blackColor].CGColor;
    shape.fillColor = [UIColor clearColor].CGColor;
    gradientLayer.mask = shape;

    //[gradientLayer setFrame:_button.frame];
    [button.layer addSublayer:gradientLayer];
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




@end
