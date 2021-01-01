//
//  ErrorManagerType.h
//  rss-reader
//
//  Created by Uladzislau on 11/25/20.
//

#import <Foundation/Foundation.h>
#import "RSSError.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ErrorCompletion)(NSError *);

@protocol ErrorManagerType <NSObject>

- (void)provideErrorOfType:(RSSError)type completion:(ErrorCompletion)completion;

@end

NS_ASSUME_NONNULL_END
