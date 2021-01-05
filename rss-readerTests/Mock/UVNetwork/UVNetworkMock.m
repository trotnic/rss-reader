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
    completion(self.data, self.error);
}

@end
