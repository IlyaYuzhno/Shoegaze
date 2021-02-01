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

@end

@implementation MainViewContoller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    _savedArray = [NSMutableArray new];
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"Favorites"];
    [_savedArray addObjectsFromArray:array];
    
    
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
    
    
    // Add Button
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
    
    
    [self play];
    
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


// MARK: Track Label tapped method
-(void) labelTapped {
    
    
    
    [_savedArray addObject:_trackLabel.text];
    
    [[NSUserDefaults standardUserDefaults] setObject:_savedArray forKey:@"Favorites"];
    
    //NSMutableArray *xxx = [[NSUserDefaults standardUserDefaults] objectForKey:@"Favorites"];
   
    
}




@end
