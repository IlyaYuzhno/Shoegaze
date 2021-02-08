//
//  AboutView.m
//  Shoegaze
//
//  Created by Ilya Doroshkevitch on 05.02.2021.
//

#import "AboutView.h"

@implementation AboutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
        self.layer.cornerRadius = 5;
        self.alpha = 0.0;
        
        //Add About label
        _aboutLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 150)];
        _aboutLabel.numberOfLines = 0;
        //[_aboutLabel sizeToFit];
        _aboutLabel.adjustsFontSizeToFitWidth = YES;
        _aboutLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _aboutLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _aboutLabel.textAlignment = NSTextAlignmentCenter;
        [_aboutLabel setFont:[UIFont systemFontOfSize:20]];
        _aboutLabel.text = @"DKFM restreaming made by IlyaD for all shoegazers";
        [self addSubview:_aboutLabel];
        
        //Add OK button
        _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
         [_okButton setFrame:CGRectMake(0, 0, 50, 50)];
        _okButton.center = CGPointMake(self.frame.size.width / 2, CGRectGetMaxY(self.frame) - 25);
        _okButton.clipsToBounds = YES;
        [_okButton setTitle:@"OK" forState:UIControlStateNormal];
        [_okButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_okButton addTarget:self action:@selector(okButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_okButton];
        
    }
    return self;
}



//MARK: OK button pressed method
-(void) okButtonPressed {
    
    self.alpha = 0;
    
    //Send notification when OK pressed
    [[NSNotificationCenter defaultCenter] postNotificationName:@"aboutOKPressed" object:nil userInfo:nil];
    
}




@end
