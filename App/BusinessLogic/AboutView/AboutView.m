//
//  AboutView.m
//  Shoegaze
//
//  Created by Ilya Doroshkevitch on 05.02.2021.
//

#import "AboutView.h"

#define INSTRUCTION @"1.Tap twice on a band/track title on a main screen to save band/track names in Favorites list.\r2. Tap ✮ to open your saved band/tracks Favorites list.\r3. Tap once on any saved item in list to see band info."



@implementation AboutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
        self.layer.cornerRadius = 5;
        self.alpha = 0.0;
        
        //Add title label
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 40)];
        _titleLabel.numberOfLines = 0;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.layer.cornerRadius = 5;
        _titleLabel.clipsToBounds = YES;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        _titleLabel.text = @"HOW TO USE THIS APP:";
        [self addSubview:_titleLabel];
        
        //Add instructions textView
        _instructionTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, _titleLabel.frame.size.height, self.bounds.size.width, self.bounds.size.height - 130)];
        _instructionTextView.backgroundColor = [UIColor clearColor];
        _instructionTextView.text = INSTRUCTION;
        _instructionTextView.editable = NO;
        [_instructionTextView setFont:[UIFont fontWithName:@"HelveticaNeue" size:22.0f]];
        [self addSubview:_instructionTextView];
        
     
        //Add About label
        _aboutLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 90, self.bounds.size.width, 40)];
        _aboutLabel.numberOfLines = 0;
        _aboutLabel.backgroundColor = [UIColor clearColor];
        //[_aboutLabel sizeToFit];
        _aboutLabel.adjustsFontSizeToFitWidth = YES;
        _aboutLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _aboutLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _aboutLabel.textAlignment = NSTextAlignmentLeft;
        [_aboutLabel setFont:[UIFont systemFontOfSize:13]];
        _aboutLabel.text = @" ©DKFM restreaming made by kardor@mail.ru for all shoegazers 😊";
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
