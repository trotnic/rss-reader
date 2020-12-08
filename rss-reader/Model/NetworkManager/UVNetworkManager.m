//
//  UVNetworkManager.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 7.12.20.
//

#import "UVNetworkManager.h"

@interface UVNetworkManager ()

@property (nonatomic, retain) NSURLSession *session;

@end

@implementation UVNetworkManager

- (instancetype)initWithSession:(NSURLSession *)session
{
    self = [super init];
    if (self) {
        _session = [session retain];
    }
    return self;
}

- (void)dealloc
{
    [_session release];
    [super dealloc];
}

- (void)fetchURL:(NSURL *)url
  withCompletion:(void (^)(NSData *, NSError *))completion {
    [NSThread detachNewThreadWithBlock:^{
        NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url
                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if(error) {
                completion(nil, error);
                return;
            }
            completion(data, nil);
        }];
        
        [dataTask resume];
    }];
}

@end
