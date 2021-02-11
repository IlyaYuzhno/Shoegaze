//
//  CheckDeviceModel.h
//  Shoegaze
//
//  Created by Ilya Doroshkevitch on 11.02.2021.
//

#import <Foundation/Foundation.h>
#import <sys/utsname.h>


NS_ASSUME_NONNULL_BEGIN

@interface CheckDeviceModel : NSObject

+ (NSString *) deviceName;

@end

NS_ASSUME_NONNULL_END
