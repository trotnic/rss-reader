//
//  UVSourcesListViewController.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 20.12.20.
//

#import <UIKit/UIKit.h>
#import "UVSourcesListViewType.h"
#import "UVSourcesListPresenterType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVSourcesListViewController : UIViewController <UVSourcesListViewType>

- (instancetype)initWithPresenter:(id<UVSourcesListPresenterType>)presenter;

@end

NS_ASSUME_NONNULL_END
