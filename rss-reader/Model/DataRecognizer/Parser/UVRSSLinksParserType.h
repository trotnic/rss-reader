//
//  UVRSSParserType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 7.12.20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UVRSSLinksParserType <NSObject>

- (void)parseContentsOfData:(NSData *)data withCompletion:(void(^)(NSArray<NSString *> *, NSError *))completion;
- (void)parseContentsOfURL:(NSURL *)url withCompletion:(void(^)(NSArray<NSString *> *, NSError *))completion;

@end

NS_ASSUME_NONNULL_END
