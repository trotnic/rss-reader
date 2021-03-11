//
//  UVRSSLink.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 8.12.20.
//

#import <Foundation/Foundation.h>
#import "UVRSSLinkViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVRSSLink : NSObject <UVRSSLinkViewModel, NSSecureCoding, NSCopying>

@property (nonatomic, copy, readonly) NSString *title;
/**
 a key to link feed & rss-link
 */
@property (nonatomic, strong, readonly) NSURL *url;
@property (nonatomic, assign, getter=isSelected) BOOL selected;

+ (instancetype _Nullable)objectWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryFromObject;
- (instancetype)initWithTitle:(NSString *)title url:(NSURL *)url selected:(BOOL)selected;
- (instancetype)initWithTitle:(NSString *)title url:(NSURL *)url;

- (void)configureURLRelativeToURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
