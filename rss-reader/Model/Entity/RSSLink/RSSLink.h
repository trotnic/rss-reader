//
//  RSSLink.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 8.12.20.
//

#import <Foundation/Foundation.h>
#import "UVRSSLinkViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RSSLink : NSObject <UVRSSLinkViewModel, NSSecureCoding, NSCopying>

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, retain, readonly) NSURL *url;
@property (nonatomic, assign, getter=isSelected) BOOL selected;

+ (instancetype _Nullable)objectWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryFromObject;
- (instancetype)initWithTitle:(NSString *)title url:(NSURL *)url selected:(BOOL)selected;
- (instancetype)initWithTitle:(NSString *)title url:(NSURL *)url;

- (void)configureURLRelativeToURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
