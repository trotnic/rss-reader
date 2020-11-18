//
//  MediaContent.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MediaContent : NSObject

@property (nonatomic, copy, readonly) NSString *url;
@property (nonatomic, copy, readonly) NSString *type;
@property (nonatomic, assign, readonly) NSUInteger fileSize;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
