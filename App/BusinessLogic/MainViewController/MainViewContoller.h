//
//  MainViewContoller.h
//  Shoegaze
//
//  Created by Ilya Doroshkevitch on 01.02.2021.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "VisualizerView.h"
#import <QuartzCore/QuartzCore.h>
#import "FavoritesTableViewController.h"
#import "MenuView.h"
#import "AboutView.h"
#import "Presenter.h"
#import "Animations.h"
#import "BubbleView.h"
#import "CheckConnection.h"
#import "CheckSystemMemory.h"
#import "NetworkErrorView.h"
#import "BufferingAudioView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainViewContoller : UIViewController <AVPlayerItemMetadataOutputPushDelegate>


@end

NS_ASSUME_NONNULL_END
