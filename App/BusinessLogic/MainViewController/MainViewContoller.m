//
//  MainViewContoller.m
//  Shoegaze
//
//  Created by Ilya Doroshkevitch on 01.02.2021.
// TO DO: add server availability, add memory check

#import "MainViewContoller.h"

@interface MainViewContoller ()

@property (nonatomic, strong) AVURLAsset *avAsset;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayer *audioPlayer;
@property (nonatomic, strong) UILabel *trackLabel;
@property (strong, nonatomic) VisualizerView *visualizer;
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) UIButton *favButtonView;
@property (strong, nonatomic) UIBarButtonItem *goToFavorites;
@property (strong, nonatomic) UIButton *bugrMenuButtonView;
@property (strong, nonatomic) UIBarButtonItem *goToMenu;
@property (strong, nonatomic) MenuView *menuView;
@property (strong, nonatomic) AboutView *aboutView;
@property (strong, nonatomic) UIVisualEffect *blurEffect;
@property (strong, nonatomic) UIVisualEffectView *visualEffectView;
@property (nonatomic, strong) UILabel *saveLabel;
@property (strong, nonatomic) UIView *startInfoBubbleView;
@property (strong, nonatomic) CheckConnection *reach;
@property (strong, nonatomic) CheckConnection *hostReach;
@property (strong, nonatomic) FavoritesTableViewController *favoritesViewController;
@property (strong, nonatomic) NSMutableArray *trackNamesArray;
@property (strong, nonatomic) NetworkErrorView *networkErrorView;
@property (strong, nonatomic) BufferingAudioView *bufferingAudioView;
//iOS12 buttons
@property (strong, nonatomic) UIButton *iOS12BugrButton;
@property (strong, nonatomic) UIButton *iOS12FavoriteButton;

@end

@implementation MainViewContoller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Presenter initialize];

    //MARK: Check internet connection and play shoegaze if connection is ok
    [self checkConnection];

    
    //MARK: Check if favorites tracks data and cache in UserDefaults exists
    [self checkStorage];
    [self checkBandInfoCache];
    
    
    //MARK: Set self.view and navigation bar view
    if (@available(iOS 13.0, *)) {
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    } else {
        self.view.backgroundColor = [UIColor clearColor];
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                      forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        self.navigationController.navigationBar.translucent = YES;
    }
    
    
    _trackNamesArray = [NSMutableArray new];
    
    //MARK: Set visualizer background view
    self.backgroundView = [[UIView alloc] initWithFrame:self.view.frame];
    [_backgroundView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_backgroundView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:_backgroundView];
    
    
    //MARK: Add Menu View initially off screen
    _menuView = [[MenuView alloc] initWithFrame:CGRectMake(-300, 100, self.view.bounds.size.width / 3, 90)];
    _menuView.backgroundColor = [UIColor clearColor];
    _menuView.layer.cornerRadius = 6;
    _menuView.alpha = 0.0;
    [self.view addSubview:_menuView];
    
    //MARK: Add Network Error View initially above screen
    _networkErrorView = [[NetworkErrorView alloc] initWithFrame:CGRectMake(10, -80, self.view.bounds.size.width - 20, 70)];
    [self.view addSubview:_networkErrorView];
    
    //MARK: Add Buffering Audio View initially above screen
    _bufferingAudioView = [[BufferingAudioView alloc] initWithFrame:CGRectMake(10, -80, self.view.bounds.size.width - 20, 40)];
    [self.view addSubview:_bufferingAudioView];
    
    

    //MARK: Set track label via Presenter
    _trackLabel = [Presenter setTrackLabel:_trackLabel y:CGRectGetMaxY(_menuView.frame) controller:self];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped)];
    tapGestureRecognizer.numberOfTapsRequired = 2;
    [_trackLabel addGestureRecognizer:tapGestureRecognizer];
    [self.view addSubview:_trackLabel];
    
    
    //MARK: Add Play/Pause Button via Presenter
    _playButton = [Presenter setPlayButton:_playButton trackLabel:_trackLabel controller:self];
    [_playButton addTarget:self action:@selector(playButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playButton];
    
    
    //MARK: Add visualizer
    self.visualizer = [[VisualizerView alloc] initWithFrame:self.view.frame];
    [_visualizer setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_backgroundView addSubview:_visualizer];
    
    
    //MARK: Add Favorites Button via Presenter
    if (@available(iOS 13.0, *)) {
    _favButtonView = [Presenter setFavoritesButtonView:_favButtonView controller:self];
    [_favButtonView addTarget:self action:@selector(favButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    _goToFavorites = [[UIBarButtonItem alloc] initWithCustomView:_favButtonView];
    
    self.navigationItem.rightBarButtonItem = _goToFavorites;
    } else {
        
        _iOS12FavoriteButton = [Presenter setiOS12FavoritesButtonView:_iOS12FavoriteButton controller:self];
       [_iOS12FavoriteButton addTarget:self action:@selector(favButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_iOS12FavoriteButton];
    }
    

    //MARK: Add bugr menu button via Presenter
    if (@available(iOS 13.0, *)) {
    _bugrMenuButtonView = [Presenter setBugrMenuButtonView:_bugrMenuButtonView controller:self];
    [_bugrMenuButtonView addTarget:self action:@selector(menuButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    _goToMenu = [[UIBarButtonItem alloc] initWithCustomView:_bugrMenuButtonView];
    self.navigationItem.leftBarButtonItem = _goToMenu;
        
    } else {
        
        _iOS12BugrButton = [Presenter setiOS12BugrMenuButtonView:_iOS12BugrButton controller:self];
       [_iOS12BugrButton addTarget:self action:@selector(iOS12menuButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_iOS12BugrButton];
    }
    
    
    //MARK: Add About View initially transparent
    _aboutView = [[AboutView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 40, 350)];
    _aboutView.center = CGPointMake(self.view.frame.size.width  / 2, self.view.frame.size.height / 2);
    _aboutView.alpha = 0;
    [self.view addSubview:_aboutView];
    
    
    //MARK: Add Save Track pop-up label via Presenter
    _saveLabel = [Presenter setSaveTrackLabel:_saveLabel trackLabel:_trackLabel controller:self];
    [self.view addSubview:_saveLabel];
    
    
    //MARK: Add one time info Bubble view via Presenter
    _startInfoBubbleView = [Presenter setStartBubbleView:_startInfoBubbleView trackLabel:_trackLabel controller:self];
    _startInfoBubbleView.hidden = YES;
    [self.view addSubview:_startInfoBubbleView];

    
    //MARK: Subscribe to Menu View notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAboutViewAndBlur) name:@"aboutPressed" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeBlur) name:@"aboutOKPressed" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideBubble) name:@"closeBubblePressed" object:nil];
    
}

//MARK: ViewWillAppear
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Animate play button
    [Animations animatePlayButton:_playButton];
    
}

//MARK: ViewDidAppear
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    //Animate play button
    [Animations animatePlayButton:_playButton];
    
    //Show first time view
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
    

    //Check if player item stalled
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemStalled:) name:AVPlayerItemPlaybackStalledNotification object:_playerItem];

    
    //Check if player item status changed
    [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:NULL];
    [_playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:NULL];
    [_playerItem addObserver:self forKeyPath:@"playbackBufferFull" options:NSKeyValueObservingOptionNew context:NULL];
  
}


//MARK: Observe PlayerItem Buffer Status Change
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  
    if ([keyPath isEqualToString:@"status"]) {
       
      //Post notification about stall is off
      [[NSNotificationCenter defaultCenter] postNotificationName:@"internetReachable" object:nil userInfo:nil];
      
      //Hide network error view
      [Animations animateNetworkErrorViewSlideOff:_networkErrorView];
      
  }
    
    if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        
        //Post notification about stall is off
        [[NSNotificationCenter defaultCenter] postNotificationName:@"internetReachable" object:nil userInfo:nil];
        
        //Hide buffering audio view
        [Animations animateBufferingAudioViewSlideOff:_bufferingAudioView];
        
    }
    
    if ([keyPath isEqualToString:@"playbackBufferFull"]) {
        
        //Show buffering audio view
        [Animations animateBufferingAudioViewSlideOn:_bufferingAudioView];
        
        //Post notification about stall is on
        [[NSNotificationCenter defaultCenter] postNotificationName:@"internetError" object:nil userInfo:nil];
        
        //Play again
        [self play];
    }
    
}


//MARK: Observe if player item stalled
- (void) playerItemStalled:(NSNotification *)notification
{
    //Post notification about stall is on
    [[NSNotificationCenter defaultCenter] postNotificationName:@"internetError" object:nil userInfo:nil];
    
    //Show network error view
    [Animations animateNetworkErrorViewSlideOn:_networkErrorView];

}


//MARK: Get track name method
- (void) metadataOutput:(AVPlayerItemMetadataOutput *)output didOutputTimedMetadataGroups:(NSArray<AVTimedMetadataGroup *> *)groups fromPlayerItemTrack:(AVPlayerItemTrack *)track{
    
    id name = groups.firstObject.items.firstObject.stringValue;
    
    //Show artist and track names
    _trackLabel.text = name;
    
}


//MARK: Pause music method
- (void) playButtonPressed {

    //Animate button when tapped
    [Animations animatePlayButtonTapped:_playButton];
    
    if (_playButton.tag == 0) {
    [_audioPlayer pause];
    _playButton.tag = 1;
    [_playButton setTitle:@"PLAY" forState:UIControlStateNormal];
    } else {
        [_audioPlayer play];
        _playButton.tag = 0;
        [_playButton setTitle:@"PAUSE" forState:UIControlStateNormal];
    }
}


// MARK: Track Label tapped method - Save track name to Defaults and animate labels
-(void) labelTapped {
    
    //Vibrate phone when saved
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    //Get Favorites data into local storage
    _trackNamesArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Favorites"] mutableCopy];

    //Check if system memory is enough
    uint64_t freeMemory = [CheckSystemMemory getFreeDiskspace];
    
    if (freeMemory > 120) {
    
    // Add track name to global storage
    [_trackNamesArray addObject:_trackLabel.text];
 
    [[NSUserDefaults standardUserDefaults] setObject:self->_trackNamesArray forKey:@"Favorites"];

    //Animate Track label when double tapped
    [Animations animateTrackLabel:_trackLabel];
    
    //Save Track to Favorites animation method
    [Animations animateSaveTrack:_saveLabel favButton:_favButtonView trackLabel:_trackLabel controller:self];
        
    } else {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"NOT ENOUGH MEMORY" message:@"Track will not be saved. Please clean your phone memory and try again." preferredStyle: UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}


// MARK: Go To Favorites View Button tapped method
-(void) favButtonPressed {
    
    _favoritesViewController = [[FavoritesTableViewController alloc] init];
    [self.navigationController showViewController:_favoritesViewController sender:self];
    
}


//MARK: Bugr Menu Animate show and hide
- (void) menuButtonPressed {
    if (@available(iOS 13.0, *)) {
    
    if (_bugrMenuButtonView.tag == 0) {
        _bugrMenuButtonView.tag = 1;
        _bugrMenuButtonView.tintColor = [UIColor colorWithRed:178/255.0 green:170/255.0 blue:156/255.0 alpha:0.8];
        
        //Animate slide menu on screen
        [Animations animateAboutViewSlideOn:_menuView];
        
    } else {
        _bugrMenuButtonView.tag = 0;
        _bugrMenuButtonView.tintColor = [UIColor colorWithRed:178/255.0 green:170/255.0 blue:156/255.0 alpha:0.2];
        
        //Animate slide menu off screen
        [Animations animateAboutViewSlideOff:_menuView];
    }
    } else {
        
        if (_iOS12BugrButton.tag == 0) {
            _iOS12BugrButton.tag = 1;
            
            //Animate slide menu on screen
            [Animations animateAboutViewSlideOn:_menuView];
            
        } else {
            _iOS12BugrButton.tag = 0;
            
            //Animate slide menu off screen
            [Animations animateAboutViewSlideOff:_menuView];
        }
        
        
    }
}

//MARK: iOS12BugrMenu Button Pressed method
- (void) iOS12menuButtonPressed {

    if (_iOS12BugrButton.tag == 0) {
        _iOS12BugrButton.tag = 1;

        //Animate slide menu on screen
        [Animations animateAboutViewSlideOn:_menuView];

    } else {
        _iOS12BugrButton.tag = 0;

        //Animate slide menu off screen
        [Animations animateAboutViewSlideOff:_menuView];
    }
}


//MARK: Show About View and Blur background
- (void) showAboutViewAndBlur {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first_start"];
    
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


//MARK: Show or not show start info Bubble View animated
- (void)showBubbleInfoViewIfNeeded
{
    BOOL isFirstStart = [[NSUserDefaults standardUserDefaults] boolForKey:@"first_start"];
    if (!isFirstStart) {
        
        if (@available(iOS 13.0, *)) {
        [Animations animateBubbleView:_startInfoBubbleView button:_playButton];
        } else {
            [self showAboutViewAndBlur];
        }
    }
}

//MARK: Hide Bubble if already showed
- (void)hideBubble {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first_start"];
    _startInfoBubbleView.hidden = YES;
    _playButton.hidden = NO;
    [_startInfoBubbleView removeFromSuperview];
}


//MARK: Check internet connection availability
- (void) checkConnection {
    
    //Check for internet connection
        [[NSNotificationCenter defaultCenter]
              addObserver:self
                 selector:@selector(reachabilityChanged:)
                     name:kReachabilityChangedNotification
                   object:nil];

        _reach = [CheckConnection
                             reachabilityForInternetConnection];
        [_reach startNotifier];

        // Check if a pathway to a radio host exists
        _hostReach = [CheckConnection reachabilityWithHostName:
                         @"maggie.torontocast.com"];
        [_hostReach startNotifier];
    
}

//MARK: reachabilityChanged method
- (void) reachabilityChanged:(NSNotification *)notification {
 
    // Called after network status changes
    NetworkStatus internetStatus = [_reach currentReachabilityStatus];
    switch (internetStatus)

    {
        case NotReachable:
        {
            // Show error view
            [Animations animateNetworkErrorViewSlideOn:_networkErrorView];
            
            //Post notification about error
            [[NSNotificationCenter defaultCenter] postNotificationName:@"internetError" object:nil userInfo:nil];
            
            break;

        }
        case ReachableViaWiFi:
        {
            //Hide error view
            [Animations animateNetworkErrorViewSlideOff:_networkErrorView];
            
            //Post notification about reachable
            [[NSNotificationCenter defaultCenter] postNotificationName:@"internetReachable" object:nil userInfo:nil];
            
            //Play shoegaze if wi-fi is available
            [self play];
            break;

        }
        case ReachableViaWWAN:
        {
            //Hide error view
            [Animations animateNetworkErrorViewSlideOff:_networkErrorView];
            
            //Post notification about reachable
            [[NSNotificationCenter defaultCenter] postNotificationName:@"internetReachable" object:nil userInfo:nil];
            
            //Play shoegaze if cell network is available
            [self play];
            break;

        }
    }

    NetworkStatus hostStatus = [_hostReach currentReachabilityStatus];
    switch (hostStatus)

    {
        case NotReachable:
        {
            // Show error view
            // [Animations animateNetworkErrorViewSlideOn:_networkErrorView];
            //Post notification about error
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"internetError" object:nil userInfo:nil];
            break;

        }
        case ReachableViaWiFi:
        {
            
            //Hide error view
            //[Animations animateNetworkErrorViewSlideOff:_networkErrorView];
            //Post notification about reachable
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"internetReachable" object:nil userInfo:nil];
            
            //Play shoegaze if cell network is available
            //[self play];
            
            break;

        }
        case ReachableViaWWAN:
        {
            
            //Hide error view
           // [Animations animateNetworkErrorViewSlideOff:_networkErrorView];
            //Post notification about reachable
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"internetReachable" object:nil userInfo:nil];
            
            //Play shoegaze if cell network is available
            //[self play];
            
            
            break;
            
        }
            
    }
}


//MARK: Check if anything in UserDefaults Favorites storage
-(void) checkStorage {
    
    NSMutableArray *initialArray = [NSMutableArray new];
    NSMutableArray *array = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Favorites"] mutableCopy];
    if (!array) {
        [[NSUserDefaults standardUserDefaults] setObject:initialArray forKey:@"Favorites"];
    }
}


//MARK: Check if anything in UserDefaults Band Info cache
-(void) checkBandInfoCache {
    
    NSMutableDictionary *initialDictionary = [NSMutableDictionary new];
    NSMutableDictionary *dict = [[[NSUserDefaults standardUserDefaults] objectForKey:@"bandInfoCache"] mutableCopy];
    if (!dict) {
        [[NSUserDefaults standardUserDefaults] setObject:initialDictionary forKey:@"bandInfoCache"];
    }
}

//MARK: Remove observers
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [_playerItem removeObserver:self forKeyPath:@"status"];
    [_playerItem removeObserver:self forKeyPath:@"playbackBufferFull"];
    [_reach stopNotifier];
    [_hostReach stopNotifier];
}



@end

