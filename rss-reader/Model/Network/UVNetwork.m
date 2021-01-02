//
//  UVNetwork.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 1.01.21.
//

#import "UVNetwork.h"

@implementation UVNetwork

- (void)dealloc
{
    [_session release];
    [super dealloc];
}

// MARK: -

- (void)fetchDataFromURL:(NSURL *)url
              completion:(void (^)(NSData *, NSError *))completion {
    [NSThread detachNewThreadWithBlock:^{
        @autoreleasepool {
            [[self.session dataTaskWithURL:url
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

// MARK: - Lazy

- (NSURLSession *)session {
    if(!_session) {
        _session = [NSURLSession.sharedSession retain];
    }
    return _session;
}

@end
