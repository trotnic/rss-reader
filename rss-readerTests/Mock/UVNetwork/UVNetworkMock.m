//
//  UVNetworkMock.m
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 2.01.21.
//

#import "UVNetworkMock.h"

@implementation UVNetworkMock

- (void)fetchDataFromURL:(NSURL *)url
              completion:(void (^)(NSData *, NSError *))completion {
    self.isCalled = YES;
    if (completion) completion(self.data, self.requestError);
}

- (NSURL * _Nullable)validateAddress:(nonnull NSString *)address
                               error:(out NSError * _Nullable * _Nullable)error {
    self.isCalled = YES;
    if (error) {
        *error = self.validationError;
    }
    return self.url;
}


- (NSURL * _Nullable)validateURL:(nonnull NSURL *)url
                           error:(out NSError * _Nullable * _Nullable)error {
    self.isCalled = YES;
    if (error) {
        *error = self.validationError;
    }
    return self.url;
}


@end
