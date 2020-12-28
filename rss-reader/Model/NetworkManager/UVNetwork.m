//
//  UVNetwork.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 27.12.20.
//

#import "UVNetwork.h"

@interface UVNetwork ()

@end

@implementation UVNetwork

+ (instancetype)shared {
    static dispatch_once_t pred = 0;
    static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [self new];
    });
    return _sharedObject;
}

- (void)fetchDataOnURL:(NSURL *)url completion:(void (^)(NSData *, NSError *))completion {
    [NSThread detachNewThreadWithBlock:^{
        @autoreleasepool {
            [[NSURLSession.sharedSession dataTaskWithURL:url
                                                  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (error) {
                    completion(nil, error);
                    return;
                }
                completion(data, nil);
            }] resume];
        }
    }];
}

@end
