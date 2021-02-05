//
//  MainViewContoller.m
//  Shoegaze
//
//  Created by Ilya Doroshkevitch on 01.02.2021.
//

#import "MainViewContoller.h"

@interface MainViewContoller ()

@property (nonatomic, strong) AVURLAsset *avAsset;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayer *audioPlayer;
@property (nonatomic, strong) UILabel *trackLabel;
@property (strong, nonatomic) VisualizerView *visualizer;
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) NSMutableArray *savedArray;
@property (strong, nonatomic) UIButton *favButtonView;
@property (strong, nonatomic) UIBarButtonItem *goToFavorites;
@property (strong, nonatomic) UIButton *bugrMenuButtonView;
@property (strong, nonatomic) UIBarButtonItem *goToMenu;
@property (strong, nonatomic) MenuView *menuView;
@property (strong, nonatomic) AboutView *aboutView;
@property (strong, nonatomic) UIVisualEffect *blurEffect;
@property (strong, nonatomic) UIVisualEffectView *visualEffectView;

@end

@implementation MainViewContoller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    _savedArray = [NSMutableArray new];
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"Favorites"];
    [_savedArray addObjectsFromArray:array];
    
    
    // Set visualizer background view
    self.backgroundView = [[UIView alloc] initWithFrame:self.view.frame];
    [_backgroundView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_backgroundView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:_backgroundView];
    
    
    // Set track label
    _trackLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (self.view.bounds.size.height / 2) - 140, self.view.bounds.size.width - 20, 140.0)];
    _trackLabel.textColor = [UIColor whiteColor];
    _trackLabel.numberOfLines = 0;
    _trackLabel.adjustsFontSizeToFitWidth = NO;
    _trackLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _trackLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _trackLabel.textAlignment = NSTextAlignmentCenter;
    [_trackLabel setFont:[UIFont boldSystemFontOfSize:24]];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [_trackLabel addGestureRecognizer:tapGestureRecognizer];
    _trackLabel.userInteractionEnabled = YES;
    [self.view addSubview:_trackLabel];
    
    
    // Add Play/Pause Button
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
     [_button setFrame:CGRectMake((self.view.bounds.size.width / 2) - 100, CGRectGetMaxY(_trackLabel.frame) + 100, 200, 200)];
    _button.clipsToBounds = YES;
    _button.tag = 0;
    [_button setTitle:@"PAUSE" forState:UIControlStateNormal];
    //_button.translatesAutoresizingMaskIntoConstraints = NO;
    CGFloat radius = MIN(_button.frame.size.width, _button.frame.size.height) / 2.0;
    _button.layer.cornerRadius = radius;
    [_button.layer setMasksToBounds:YES];
    [_button.layer setBorderWidth:4.0f];
    [_button.layer setBorderColor:[[UIColor colorWithRed:178/255.0 green:170/255.0 blue:156/255.0 alpha:0.4] CGColor]];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];

    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[UIColor colorWithRed:0.841 green:0.566 blue:0.566 alpha:1.0].CGColor, (id)[UIColor colorWithRed:0.75 green:0.341 blue:0.345 alpha:1.0].CGColor, (id)[UIColor colorWithRed:0.592 green:0.0 blue:0.0 alpha:1.0].CGColor, (id)[UIColor colorWithRed:0.592 green:0.0 blue:0.0 alpha:1.0].CGColor, nil]];
    
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.lineWidth = 3;
    [shape setPath:[[UIBezierPath bezierPathWithRect:_button.bounds] CGPath]];
    shape.strokeColor = [UIColor blackColor].CGColor;
    shape.fillColor = [UIColor clearColor].CGColor;
    gradientLayer.mask = shape;

    //[gradientLayer setFrame:_button.frame];
    [_button.layer addSublayer:gradientLayer];
    
    [_button addTarget:self action:@selector(playButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_button];
    
    
    //Add visualizer
    self.visualizer = [[VisualizerView alloc] initWithFrame:self.view.frame];
    [_visualizer setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_backgroundView addSubview:_visualizer];
    
    
    //Add Favorites Button
    _favButtonView = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 30, CGRectGetMinY(self.view.frame) + 70, 80, 80)];
    UIImage *img = [UIImage systemImageNamed:@"star"];
    [_favButtonView setImage:img forState:UIControlStateNormal];
    _favButtonView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    _favButtonView.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    _favButtonView.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _favButtonView.tintColor =[UIColor colorWithRed:178/255.0 green:170/255.0 blue:156/255.0 alpha:0.2];
    [_favButtonView addTarget:self action:@selector(favButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    _goToFavorites = [[UIBarButtonItem alloc] initWithCustomView:_favButtonView];
    self.navigationItem.rightBarButtonItem = _goToFavorites;
    
    
    //Add bugr menu button
    _bugrMenuButtonView= [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 30, CGRectGetMinY(self.view.frame) + 70, 80, 80)];
    UIImage *imgBugr = [UIImage systemImageNamed:@"lineweight"];
    [_bugrMenuButtonView setImage:imgBugr forState:UIControlStateNormal];
    _bugrMenuButtonView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    _bugrMenuButtonView.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    _bugrMenuButtonView.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _bugrMenuButtonView.tintColor = [UIColor colorWithRed:178/255.0 green:170/255.0 blue:156/255.0 alpha:0.2];
    _bugrMenuButtonView.tag = 0;
    [_bugrMenuButtonView addTarget:self action:@selector(menuButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    _goToMenu = [[UIBarButtonItem alloc] initWithCustomView:_bugrMenuButtonView];
    self.navigationItem.leftBarButtonItem = _goToMenu;
    
    
    //Add Menu View initially off screen
   _menuView = [[MenuView alloc] initWithFrame:CGRectMake(-300, 100, self.view.bounds.size.width / 3, 200)];
    _menuView.backgroundColor = [UIColor clearColor];
    _menuView.layer.cornerRadius = 6;
    _menuView.alpha = 0.0;
    [self.view addSubview:_menuView];

    
    //Add About View initially transparent
    _aboutView = [[AboutView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    _aboutView.center = CGPointMake(self.view.frame.size.width  / 2, self.view.frame.size.height / 3);
    _aboutView.alpha = 0;
    [self.view addSubview:_aboutView];
    
    // Play shoegaze
    [self play];
    
    //Subscribe to Menu View notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAboutViewAndBlur) name:@"aboutPressed" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeBlur) name:@"aboutOKPressed" object:nil];
    
    
}


//MARK: Radio Play method
- (void) play {
    NSURL *url = [NSURL URLWithString:@"https://maggie.torontocast.com:8090/live.mp3"];
    _avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    _playerItem = [AVPlayerItem playerItemWithAsset:_avAsset];
    _audioPlayer = [AVPlayer playerWithPlayerItem:_playerItem];
    
    [_playerItem addObserver:self forKeyPath:@"timedMetadata" options:NSKeyValueObservingOptionNew context:nil];
    
    [_audioPlayer play];
}


//MARK: Get track name method
- (void) observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object
                        change:(NSDictionary*)change context:(void*)context {

   if ([keyPath isEqualToString:@"timedMetadata"])
   {
      AVPlayerItem* playerItem = object;

      for (AVMetadataItem* metadata in playerItem.timedMetadata)
      {
         
         _trackLabel.text = metadata.stringValue;
          
      }
   }
}


//MARK: Pause music method
- (void) playButtonPressed {
    
    if (_button.tag == 0) {
    [_audioPlayer pause];
    _button.tag = 1;
    [_button setTitle:@"PLAY" forState:UIControlStateNormal];
    } else {
        [_audioPlayer play];
        _button.tag = 0;
        [_button setTitle:@"PAUSE" forState:UIControlStateNormal];
    }
}


// MARK: Track Label tapped method - Save track name to Defaults
-(void) labelTapped {
    
    [_savedArray addObject:_trackLabel.text];
    
    [[NSUserDefaults standardUserDefaults] setObject:_savedArray forKey:@"Favorites"];

}


// MARK: Go To Favorites View Button tapped method
-(void) favButtonPressed {
   
    FavoritesTableViewController *favoritesViewController = [[FavoritesTableViewController alloc] init];
    [self.navigationController showViewController:favoritesViewController sender:self];
    
}


//MARK: Bugr Menu Animate show and hide
- (void) menuButtonPressed {
    
    if (_bugrMenuButtonView.tag == 0) {
        _bugrMenuButtonView.tag = 1;
        _bugrMenuButtonView.tintColor = [UIColor colorWithRed:178/255.0 green:170/255.0 blue:156/255.0 alpha:0.2];
        
        //Animate slide menu off screen
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
            self->_menuView.alpha = 0;
            CGRect frame = self->_menuView.frame;
            frame.origin.y = 100;
            frame.origin.x = -300;
            self->_menuView.frame = frame;
        } completion: NULL];
        
    } else {
        _bugrMenuButtonView.tag = 0;
        _bugrMenuButtonView.tintColor = [UIColor colorWithRed:178/255.0 green:170/255.0 blue:156/255.0 alpha:0.8];
        
        //Animate slide menu on screen
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self->_menuView.alpha = 1;
            CGRect frame = self->_menuView.frame;
            frame.origin.y = 100;
            frame.origin.x = -10;
            self->_menuView.frame = frame;
        } completion: NULL];
        
    }
    
}

//MARK: Show About View and Blur background
- (void) showAboutViewAndBlur {

    // Create Blur effect
    _blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:_blurEffect];
    [[_visualEffectView contentView] addSubview:_aboutView];
    _visualEffectView.frame = self.view.bounds;

    [self.view addSubview:_visualEffectView];

    //Animate About View alpha
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self->_aboutView.alpha = 1;
        
    } completion:NULL];

}


//MARK: Remove Blur Effect and hide opened Menu
- (void) removeBlur {
    
    // Remove Blur effect
    [_visualEffectView removeFromSuperview];
    
    // Hide Menu
    [self menuButtonPressed];
}



@end
