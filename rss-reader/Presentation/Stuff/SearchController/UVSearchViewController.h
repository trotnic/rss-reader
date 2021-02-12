//
//  UVSourceSearchViewController.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 18.12.20.
//

#import <UIKit/UIKit.h>
#import "UVSearchViewControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVSearchViewController : UIViewController

@property (nonatomic, assign) id<UVSearchViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
