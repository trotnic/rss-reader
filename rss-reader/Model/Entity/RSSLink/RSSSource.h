//
//  RSSLink.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 8.12.20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RSSSource : NSObject

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithTitle:(NSString *)title link:(NSString *)link;

@end

NS_ASSUME_NONNULL_END
