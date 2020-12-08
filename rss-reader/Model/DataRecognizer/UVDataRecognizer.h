//
//  UVDataRecognizer.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 7.12.20.
//

#import <Foundation/Foundation.h>
#import "RSSSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVDataRecognizer : NSObject

- (void)findOnURL:(NSURL *)url withCompletion:(void(^)(NSArray<RSSSource *> *))completion;

@end

NS_ASSUME_NONNULL_END
