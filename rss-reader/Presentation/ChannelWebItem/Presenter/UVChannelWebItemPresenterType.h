//
//  UVChannelWebItemPresenterType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 15.02.21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UVChannelWebItemPresenterType <NSObject, WKNavigationDelegate>

- (void)loadPage;

- (void)backButtonClick;
- (void)forwardButtonClick;
- (void)reloadButtonClick;
- (void)closeButtonClick;
- (void)browserButtonClick;

- (void)doneButtonClick;

@end

NS_ASSUME_NONNULL_END
