//
//  UVNetwork.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 1.01.21.
//

#import "UVNetwork.h"

@implementation UVNetwork

- (void)fetchDataFromURL:(NSURL *)url
              completion:(void (^)(NSData *, NSError *))completion {
    [NSThread detachNewThreadWithBlock:^{
        @autoreleasepool {
            [[NSURLSession.sharedSession dataTaskWithURL:url
                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if(error) {
                    completion(nil, error);
                    return;
                }
                completion(data, nil);
            }] resume];
        }
    }];
}

@end
