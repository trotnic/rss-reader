//
//  ErrorManagerType.h
//  rss-reader
//
//  Created by Uladzislau on 11/25/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RSSErrorType) {
    RSSErrorTypeBadNetwork,
    RSSErrorTypeParsingError
};

typedef void(^ErrorCompletion)(NSError *);

@protocol ErrorManagerType <NSObject>

- (void)provideErrorOfType:(RSSErrorType)type withCompletion:(ErrorCompletion)completion;

@end

NS_ASSUME_NONNULL_END
