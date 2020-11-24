//
//  RouterType.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RouterType <NSObject>

- (void)start;
- (void)openURL:(NSURL *)url;
- (void)showError:(NSError *)error;
- (void)showNetworkActivityIndicator:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
