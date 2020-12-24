//
//  UVPropertyListConvertible.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 22.12.20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UVPropertyListConvertible <NSObject>

+ (instancetype _Nullable)objectWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryFromObject;

@end

NS_ASSUME_NONNULL_END
