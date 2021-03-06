//
//  APIManager.m
//  Shoegaze
//
//  Created by Ilya Doroshkevitch on 08.02.2021.
//

#import "APIManager.h"
#define LASTFM_API_KEY @"8a4e0e0ec25aeb23c1f4f6b54c6ec35f"
#define LASTFM_SHARED_SECRET @""
#define LASTFM_API_URL @"http://ws.audioscrobbler.com/2.0/?method=artist.getinfo&artist"


@implementation APIManager


+ (instancetype)sharedInstance {
    static APIManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[APIManager alloc] init];
    });
    return instance;
}



//MARK: Get artist from laded raw data
- (void)artistWithRequest:(NSString *)request withCompletion:(void (^)(NSMutableString *info))completion {
    
    // Initial URL string
    NSString *urlString = [NSString stringWithFormat:@"%@=%@&api_key=%@&format=json", LASTFM_API_URL, request, LASTFM_API_KEY];
    
    // URL string with spaces encoded
    NSString *path = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [self load:path withCompletion:^(id  _Nullable result) {
        NSDictionary *response = result;
        if (response) {
            NSDictionary *json = [[response valueForKey:@"artist"] valueForKey:@"bio"];
            NSMutableString *info = [json objectForKey:@"summary"];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(info);
            });
        }
    }];
}



//MARK: Load raw data from LastFM API
- (void)load:(NSString *)urlString withCompletion:(void (^)(id _Nullable result))completion {
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        completion([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]);
    }] resume] ;
}



@end
