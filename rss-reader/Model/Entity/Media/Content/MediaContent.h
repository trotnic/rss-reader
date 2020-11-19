//
//  MediaContent.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const kRSSMediaContent;
FOUNDATION_EXPORT NSString *const kRSSMediaContentURL;
FOUNDATION_EXPORT NSString *const kRSSMediaContentFileSize;
FOUNDATION_EXPORT NSString *const kRSSMediaContentType;

@interface MediaContent : NSObject

@property (nonatomic, copy, readonly) NSString *url;
@property (nonatomic, assign, readonly) NSInteger fileSize;
@property (nonatomic, copy, readonly) NSString *type;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
