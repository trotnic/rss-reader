//
//  UVLinksViewController.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 8.12.20.
//

#import <UIKit/UIKit.h>
#import "UVSourceDetailPresenterType.h"
#import "UVSourceDetailViewType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVSourceDetailViewController : UIViewController <UVSourceDetailViewType>

- (instancetype)initWithPresenter:(id<UVSourceDetailPresenterType>)presenter;

@end

NS_ASSUME_NONNULL_END
