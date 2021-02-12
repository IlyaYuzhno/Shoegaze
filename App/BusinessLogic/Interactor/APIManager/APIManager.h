//
//  APIManager.h
//  Shoegaze
//
//  Created by Ilya Doroshkevitch on 08.02.2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject

+ (instancetype)sharedInstance;
- (void)artistWithRequest:(NSString *)request withCompletion:(void (^)(NSMutableString *info))completion;



@end

NS_ASSUME_NONNULL_END
