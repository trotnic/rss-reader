//
//  RouterType.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>
#import "RouterType.h"
#import "RSSError.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MainRouter <NSObject, RouterType>

- (void)openURL:(NSURL *)url;
- (void)showErrorOfType:(RSSError)type;
- (void)showNetworkActivityIndicator:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
