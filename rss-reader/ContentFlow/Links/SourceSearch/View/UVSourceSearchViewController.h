//
//  UVSourceSearchViewController.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 18.12.20.
//

#import <UIKit/UIKit.h>
#import "UVSourceSearchPresenterType.h"
#import "UVSourceSearchViewType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVSourceSearchViewController : UIViewController <UVSourceSearchViewType>

- (instancetype)initWithPresenter:(id<UVSourceSearchPresenterType>)presenter;

@end

NS_ASSUME_NONNULL_END
