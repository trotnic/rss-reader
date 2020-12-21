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

- (NSError * _Nullable)provideErrorOfType:(RSSError)type;

@end

NS_ASSUME_NONNULL_END
