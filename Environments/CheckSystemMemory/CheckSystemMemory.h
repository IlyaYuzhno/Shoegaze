//
//  CheckSystemMemory.h
//  Shoegaze
//
//  Created by Ilya Doroshkevitch on 17.02.2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CheckSystemMemory : NSObject

+(uint64_t)getFreeDiskspace;

@end

NS_ASSUME_NONNULL_END
