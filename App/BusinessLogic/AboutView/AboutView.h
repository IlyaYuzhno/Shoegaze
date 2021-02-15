//
//  AboutView.h
//  Shoegaze
//
//  Created by Ilya Doroshkevitch on 05.02.2021.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface AboutView : UIView


@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UITextView *instructionTextView;
@property (strong, nonatomic) UILabel *aboutLabel;
@property (strong, nonatomic) UIButton *okButton;


@end

NS_ASSUME_NONNULL_END
