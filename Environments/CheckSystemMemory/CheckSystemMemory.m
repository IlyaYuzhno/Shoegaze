//
//  CheckSystemMemory.m
//  Shoegaze
//
//  Created by Ilya Doroshkevitch on 17.02.2021.
//

#import "CheckSystemMemory.h"

@implementation CheckSystemMemory


//MARK: Check free system memory
+(uint64_t)getFreeDiskspace { // return free space in MB
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];

    if (dictionary) {
        //NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        //uint64_t totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
        uint64_t totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
        //NSLog(@"Memory Capacity: %llu MiB , Free: %llu MiB", ((totalSpace/1024ll)/1024ll), ((totalFreeSpace/1024ll)/1024ll));
        return ((totalFreeSpace/1024ll)/1024ll);
    } else {
        //NSLog(@"Error getting memory info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }

    return 0;
}




@end
