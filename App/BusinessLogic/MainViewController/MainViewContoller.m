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
//@property (strong, nonatomic) UIImageView *artistImageView; // for image from LastFM
@property (nonatomic, strong) UILabel *saveLabel;
@property (strong, nonatomic) UIView *startInfoBubbleView;
@property (strong, nonatomic) CheckConnection *reach;

@end

@implementation MainViewContoller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Check internet connection
    [self checkConnection];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    _savedArray = [NSMutableArray new];
    
    // Get favorites tracks data from UserDefaults
    [self getFavoritesData];

    // Set visualizer background view
    self.backgroundView = [[UIView alloc] initWithFrame:self.view.frame];
    [_backgroundView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_backgroundView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:_backgroundView];
    
    
    // Set track label via Presenter
    _trackLabel = [Presenter setTrackLabel:_trackLabel controller:self];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped)];
    tapGestureRecognizer.numberOfTapsRequired = 2;
    [_trackLabel addGestureRecognizer:tapGestureRecognizer];
    [self.view addSubview:_trackLabel];
    
    
    // Add Play/Pause Button via Presenter
    _button = [Presenter setPlayButton:_button trackLabel:_trackLabel controller:self];
    [_button addTarget:self action:@selector(playButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    
    
    //Add visualizer
    self.visualizer = [[VisualizerView alloc] initWithFrame:self.view.frame];
    [_visualizer setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_backgroundView addSubview:_visualizer];
    
    
    //Add Favorites Button via Presenter
    _favButtonView = [Presenter setFavoritesButtonView:_favButtonView controller:self];
    [_favButtonView addTarget:self action:@selector(favButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    _goToFavorites = [[UIBarButtonItem alloc] initWithCustomView:_favButtonView];
    self.navigationItem.rightBarButtonItem = _goToFavorites;
    
    
    //Add bugr menu button via Presenter
    _bugrMenuButtonView = [Presenter setBugrMenuButtonView:_bugrMenuButtonView controller:self];
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
    
    
    //Add Save Track pop-up label via Presenter
    _saveLabel = [Presenter setSaveTrackLabel:_saveLabel trackLabel:_trackLabel controller:self];
    [self.view addSubview:_saveLabel];
    
    
    //Add one time info Bubble view via Presenter
    _startInfoBubbleView = [Presenter setStartBubbleView:_startInfoBubbleView trackLabel:_trackLabel controller:self];
    _startInfoBubbleView.hidden = YES;
    [self.view addSubview:_startInfoBubbleView];
    
    
    //Add artist downloaded from LastFM image view via Presenter- !!!currently not working!!!
    /*
    _artistImageView = [Presenter setArtistImageView:_artistImageView controller:self];
    [self.view addSubview:_artistImageView];
    */
    
    
    // Play shoegaze
    [self play];
    
    //Subscribe to Menu View notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAboutViewAndBlur) name:@"aboutPressed" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeBlur) name:@"aboutOKPressed" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideBubble) name:@"closeBubblePressed" object:nil];
    
}


//MARK: ViewDidAppear
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [Animations animatePlayButton:_button];
    
    [self showBubbleInfoViewIfNeeded];
}


//MARK: Radio Play method
- (void) play {
    
    NSURL *url = [NSURL URLWithString:@"https://maggie.torontocast.com:8090/live.mp3"];
    _avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    _playerItem = [AVPlayerItem playerItemWithAsset:_avAsset];
    AVPlayerItemMetadataOutput *metadataOutput = [[AVPlayerItemMetadataOutput alloc] init];
    [metadataOutput setDelegate:self queue:dispatch_get_main_queue()];
    [_playerItem addOutput:metadataOutput];
   
    _audioPlayer = [AVPlayer playerWithPlayerItem:_playerItem];

    [_audioPlayer play]; 
}


//MARK: Get track name method
- (void) metadataOutput:(AVPlayerItemMetadataOutput *)output didOutputTimedMetadataGroups:(NSArray<AVTimedMetadataGroup *> *)groups fromPlayerItemTrack:(AVPlayerItemTrack *)track{
    
    id name = groups.firstObject.items.firstObject.stringValue;
    
    //Show artist and track names
    _trackLabel.text = name;
    
    // Get artist name and track name from trackLabel text to search image
    NSString *artistName = [_trackLabel.text componentsSeparatedByString:@" -"][0];
    NSString *trackName = [_trackLabel.text componentsSeparatedByString:@"- "][1];
    
    //Download artist image from LastFM - currently doesn't work
    //[self getImageFromLastFM:artistName imageView:_artistImageView];
           
}


//MARK: Pause music method
- (void) playButtonPressed {
    
    //Animate button when tapped
    [Animations animatePlayButtonTapped:_button];
    
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


// MARK: Track Label tapped method - Save track name to Defaults and animate labels
-(void) labelTapped {
    
    [_savedArray addObject:_trackLabel.text];
    
    [[NSUserDefaults standardUserDefaults] setObject:_savedArray forKey:@"Favorites"];
    
    //MARK: Animate Track label when double tapped
    [Animations animateTrackLabel:_trackLabel];
    
    // MARK: Save Track to Favorites animation method
    [Animations animateSaveTrack:_saveLabel favButton:_favButtonView trackLabel:_trackLabel controller:self];
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
    [Animations animateAboutView:_aboutView];

}


//MARK: Remove Blur Effect and hide opened Menu
- (void) removeBlur {
    
    // Remove Blur effect
    [_visualEffectView removeFromSuperview];
    
    // Hide Menu
    [self menuButtonPressed];
}


//MARK: Get Favorites Data from UserDefaults method
-(void) getFavoritesData {
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"Favorites"];
    if (!array) {
        [[NSUserDefaults standardUserDefaults] setObject:_savedArray forKey:@"Favorites"];
    } else {
        [_savedArray addObjectsFromArray:array];
    }
}


//MARK: Show or not show start info Bubble View animated
- (void)showBubbleInfoViewIfNeeded
{
    BOOL isFirstStart = [[NSUserDefaults standardUserDefaults] boolForKey:@"first_start"];
    if (!isFirstStart) {
        [Animations animateBubbleView:_startInfoBubbleView];
    }
}

//MARK: Hide Bubble if already showed
- (void)hideBubble {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first_start"];
    _startInfoBubbleView.hidden = YES;
}

//MARK: Check internet connection availability
- (void) checkConnection {
    
    _reach = [CheckConnection reachabilityWithHostname:@"www.google.com"];

    _reach.reachableOnWWAN = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];

    [_reach startNotifier];
}

//MARK: reachabilityChanged method
- (void) reachabilityChanged:(NSNotification *)notification {
    if (!_reach.isReachable) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Connection error" message:@"OOPS!!!SEEMS LIKE NO INTERNET NOW!!!" preferredStyle: UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Uhhh:(" style:(UIAlertActionStyleDefault) handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}



//MARK: Remove observers
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_reach stopNotifier];
}



//MARK: Get artist image from LastFM API via APIManager - !!!currently doesn't work!!!
/*
- (void) getImageFromLastFM:(NSString *)artistName imageView:(UIImageView *) artistImageView  {

    [[APIManager sharedInstance] artistWithRequest:artistName withCompletion:^(NSDictionary *imgUrl) {
        if (imgUrl) {
            NSString *url = [imgUrl objectForKey:@"#text"];
            NSLog(@"%@", url);
            if ([url isEqualToString:@"https://lastfm.freetls.fastly.net/i/u/174s/2a96cbd8b46e442fc41c2b86b821562f.png"] && [url isEqualToString:@""]) {
                artistImageView.hidden = YES;
            } else {
                //add image to image view
                artistImageView.image = nil;
                artistImageView.hidden = NO;
                NSURL *img = [NSURL URLWithString:url];
                dispatch_queue_global_t globalQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0);
                dispatch_async(globalQueue, ^{
                    NSData *imgData = [NSData dataWithContentsOfURL:img];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        artistImageView.image = [UIImage imageWithData:imgData];
                        
                    });
                });
            }
            
        } else {
            // hide imageview if no image downloaded
            artistImageView.hidden = YES;
        }
    }];

}
*/

@end
