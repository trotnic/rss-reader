//
//  NetworkService.m
//  rss-reader
//
//  Created by Uladzislau on 11/24/20.
//

#import "NetworkService.h"

@interface NetworkService ()

@property (nonatomic, retain) NSURLSession *session;

@end

@implementation NetworkService

// MARK: -

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

// MARK: - NetworkServiceType

- (void)fetchWithURL:(NSURL *)url
          completion:(void (^)(NSData *, NSError *))completion {
    [NSThread detachNewThreadWithBlock:^{
        @autoreleasepool {
            NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url
                                                         completionHandler:^(NSData *data,
                                                                             NSURLResponse *response,
                                                                             NSError *error) {
                if(error) {
                    completion(nil, error);
                    return;
                }
                completion(data, nil);
            }];
            
            [dataTask resume];
        }
    }];
}

- (void)fetchWithRequest:(NSURLRequest *)request
              completion:(void (^)(NSData *, NSError *))completion {
    [NSThread detachNewThreadWithBlock:^{
        @autoreleasepool {
            NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data,
                                                                             NSURLResponse *response,
                                                                             NSError *error) {
                if(error) {
                    completion(nil, error);
                    return;
                }
                completion(data, nil);
            }];
            
            [dataTask resume];
        }
    }];
}

@end
