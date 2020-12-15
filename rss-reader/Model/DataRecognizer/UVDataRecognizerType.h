//
//  UVDataRecognizerType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 8.12.20.
//

#import <Foundation/Foundation.h>
#import "RSSSource.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UVDataRecognizerType <NSObject>

- (void)findOnURL:(NSURL *)url withCompletion:(void(^)(RSSSource *))completion;

@end

NS_ASSUME_NONNULL_END
