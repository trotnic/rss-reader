//
//  UIApplicationMock.m
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 2.01.21.
//

#import "UIApplicationMock.h"

@implementation UIApplicationMock

- (void)openURL:(NSURL *)url
        options:(NSDictionary<UIApplicationOpenExternalURLOptionsKey,id> *)options
completionHandler:(void (^)(BOOL))completion {
    self.isCalled = YES;
    self.selectedURL = url;
    if (completion) completion(self.completionBool);
}

@end
