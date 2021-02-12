//
//  UVBaseViewController.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 12.01.21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UVBaseViewController : UIViewController

- (void)showPlaceholderMessage:(NSString *)text;
- (void)hidePlaceholderMessage;

@end

NS_ASSUME_NONNULL_END
