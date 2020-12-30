//
//  UVSourcesListPresenter.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 20.12.20.
//

#import "UVBasePresenter.h"
#import "UVSourcesListPresenterType.h"
#import "UVSourceManagerType.h"
#import "UVDataRecognizerType.h"
#import "UVSourcesListViewType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVSourcesListPresenter : UVBasePresenter <UVSourcesListPresenterType>

@property (nonatomic, assign) id<UVSourcesListViewType> view;

@end

NS_ASSUME_NONNULL_END
