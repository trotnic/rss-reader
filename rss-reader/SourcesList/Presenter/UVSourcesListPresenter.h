//
//  UVSourcesListPresenter.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 20.12.20.
//

#import "BasePresenter.h"
#import "UVSourcesListPresenterType.h"
#import "UVSourceManagerType.h"
#import "UVDataRecognizerType.h"
#import "UVSourcesListViewType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVSourcesListPresenter : BasePresenter <UVSourcesListPresenterType>

@property (nonatomic, assign) id<UVSourcesListViewType> view;

- (instancetype)initWithSource:(id<UVSourceManagerType>)source recognizer:(id<UVDataRecognizerType>)recognizer;

@end

NS_ASSUME_NONNULL_END
