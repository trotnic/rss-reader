//
//  UIApplicationMock.h
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 2.01.21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplicationMock : NSObject

@property (nonatomic, assign) BOOL isCalled;
@property (nonatomic, assign) BOOL completionBool;
@property (nonatomic, retain) NSURL *selectedURL;

- (void)openURL:(NSURL *)url
        options:(NSDictionary<UIApplicationOpenExternalURLOptionsKey, id> *)options
completionHandler:(void (^)(BOOL success))completion;

@end

NS_ASSUME_NONNULL_END
