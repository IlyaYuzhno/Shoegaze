//
//  NetworkErrorView.m
//  Shoegaze
//
//  Created by Ilya Doroshkevitch on 24.02.2021.
//

#import "NetworkErrorView.h"

@implementation NetworkErrorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
       self.backgroundColor = [UIColor colorWithRed:(230/255.0) green:(45/255.0) blue:(85/255.0) alpha:0.6];
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;
        self.alpha = 0;
        
        //Add background gradient
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.bounds;
        gradient.colors = @[(id)[UIColor systemPinkColor].CGColor, (id)[UIColor redColor].CGColor];
        [self.layer insertSublayer:gradient atIndex:0];
        
        
        //Add text label
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _textLabel.numberOfLines = 0;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.layer.cornerRadius = 5;
        _textLabel.clipsToBounds = YES;
        _textLabel.adjustsFontSizeToFitWidth = YES;
        _textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [_textLabel setFont:[UIFont fontWithName:@"San Francisco" size:20]];
        _textLabel.text = @"Internet connection error!!! Reconnecting now...";
        [self addSubview:_textLabel];
        
    }
    return self;
}
@end
