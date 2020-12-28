//
//  RSSLink.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 8.12.20.
//

#import <Foundation/Foundation.h>
#import "RSSLinkViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RSSLink : NSObject <RSSLinkViewModel, NSSecureCoding, NSCopying>

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *link;
@property (nonatomic, assign, getter=isSelected) BOOL selected;

+ (_Nullable instancetype)objectWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryFromObject;
- (instancetype)initWithTitle:(NSString *)title link:(NSString *)link selected:(BOOL)selected;
- (instancetype)initWithTitle:(NSString *)title link:(NSString *)link;

@end

NS_ASSUME_NONNULL_END
