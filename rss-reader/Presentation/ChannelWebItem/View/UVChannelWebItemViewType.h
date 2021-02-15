//
//  UVChannelWebItemViewType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 15.02.21.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UVChannelWebItemViewType <NSObject>

@property (nonatomic, strong) WKWebView *webView;

@end

NS_ASSUME_NONNULL_END
