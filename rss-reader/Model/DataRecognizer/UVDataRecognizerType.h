//
//  UVDataRecognizerType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 8.12.20.
//

#import <Foundation/Foundation.h>
#import "RSSSource.h"
#import "RSSError.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UVDataRecognizerType <NSObject>

- (void)fetchURL:(NSURL *)url completion:(void(^)(RSSSource *, RSSError))completion;

@end

NS_ASSUME_NONNULL_END
