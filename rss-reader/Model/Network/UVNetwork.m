//
//  UVNetwork.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 1.01.21.
//

#import "UVNetwork.h"
#import "UVErrorDomain.h"

static NSString *const kSecureScheme = @"https";
static NSString *const kStubRelativePath = @"";

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

- (NSURL *)validateAddress:(NSString *)address error:(out NSError **)error {
    if (!address || !address.length) {
        [self provideErrorForReference:error];
        return nil;
    }
    NSURL *newURL = [NSURL URLWithString:kStubRelativePath
                           relativeToURL:[NSURL URLWithString:address]].absoluteURL;
    return [self enhanceSchemeOfURL:newURL error:error];
}


- (NSURL *)validateURL:(NSURL *)url error:(out NSError **)error {
    if(!url) {
        *error = [self urlError];
        return nil;
    }
    NSURL *newURL = [NSURL URLWithString:kStubRelativePath
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
        comps.scheme = kSecureScheme;
        url = comps.URL;
    }
    return url;
}

// MARK: - Lazy

- (NSURLSession *)session {
    if(!_session) {
        _session = [NSURLSession.sharedSession retain];
    }
    return _session;
}

@end
