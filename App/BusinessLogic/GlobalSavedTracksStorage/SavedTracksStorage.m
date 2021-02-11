//
//  SavedTracksStorage.m
//  Shoegaze
//
//  Created by Ilya Doroshkevitch on 11.02.2021.
//

#import "SavedTracksStorage.h"

@implementation SavedTracksStorage

+(instancetype)sharedInstance {
    
    static SavedTracksStorage *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SavedTracksStorage alloc] init];
        
        //Initiate global storage from UserDefaults data
        instance.savedTracks = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Favorites"] mutableCopy];
    });
    return instance;
}

//MARK: Check if data exists
+(void) checkFavoritesData {
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"Favorites"];
    if (!array) {
        [[NSUserDefaults standardUserDefaults] setObject:[SavedTracksStorage sharedInstance].savedTracks forKey:@"Favorites"];
    }
}

@end
