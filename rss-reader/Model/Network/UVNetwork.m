//
//  UVNetwork.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 1.01.21.
//

#import "UVNetwork.h"
#import "UVErrorDomain.h"

static NSString *const SECURE_SCHEME = @"https";
static NSString *const STUB_RELATIVE_PATH = @"";

@implementation UVNetwork

// MARK: -

- (void)fetchDataFromURL:(NSURL *)url
              completion:(void (^)(NSData *, NSError *))completion {
    [NSThread detachNewThreadWithBlock:^{
        @autoreleasepool {
            NSError *error = nil;
            NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
            completion(data, error);
        }
    }];
}

- (NSURL *)validateAddress:(NSString *)address error:(out NSError **)error {
    if (!address || !address.length) {
        [self provideErrorForReference:error];
        return nil;
    }
    NSURL *newURL = [NSURL URLWithString:STUB_RELATIVE_PATH
                           relativeToURL:[NSURL URLWithString:address]].absoluteURL;
    
    if (!newURL.host) {
        [self provideErrorForReference:error];
        return nil;
    }
    
    return [self enhanceSchemeOfURL:newURL error:error];
}


- (NSURL *)validateURL:(NSURL *)url error:(out NSError **)error {
    if(!url || !url.absoluteString.length) {
        [self provideErrorForReference:error];
        return nil;
    }
    NSURL *newURL = [NSURL URLWithString:STUB_RELATIVE_PATH
                           relativeToURL:url].absoluteURL;
    return [self enhanceSchemeOfURL:newURL error:error];
    
}

// MARK: - Private

- (NSError *)urlError {
    return [NSError errorWithDomain:UVNetworkErrorDomain code:100000 userInfo:nil];
}

- (BOOL)provideErrorForReference:(out NSError **)error {
    if (error) {
        *error = [self urlError];
    }
    return YES;
}

- (NSURL *)enhanceSchemeOfURL:(NSURL *)url error:(out NSError **)error {
    if (!url) {
        [self provideErrorForReference:error];
        return nil;
    }
    if (!url.scheme) {
        NSURLComponents *comps = [NSURLComponents componentsWithURL:url
                                            resolvingAgainstBaseURL:YES];
        comps.scheme = SECURE_SCHEME;
        url = comps.URL;
    }
    return url;
}

@end
