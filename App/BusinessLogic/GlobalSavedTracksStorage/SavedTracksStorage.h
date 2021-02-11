//
//  SavedTracksStorage.h
//  Shoegaze
//
//  Created by Ilya Doroshkevitch on 11.02.2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SavedTracksStorage : NSObject

+ (instancetype)sharedInstance;
@property (nonatomic, retain) NSMutableArray *savedTracks;
+(void) checkFavoritesData;


@end

NS_ASSUME_NONNULL_END
