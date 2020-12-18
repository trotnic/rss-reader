//
//  UVTextFieldViewController.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 17.12.20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UVTextFieldViewController : UIViewController

- (instancetype)initWithCompletion:(void(^)(NSString *))completion;

@end

NS_ASSUME_NONNULL_END
