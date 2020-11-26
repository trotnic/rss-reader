//
//  UIViewController+ErrorPresenter.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 11/26/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ErrorPresenter)

- (void)showError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
