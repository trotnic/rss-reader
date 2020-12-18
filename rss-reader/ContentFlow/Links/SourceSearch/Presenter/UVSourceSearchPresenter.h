//
//  UVSourceSearchPresenter.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 18.12.20.
//

#import "BasePresenter.h"
#import "UVSourceSearchPresenterType.h"
#import "UVSourceManagerType.h"
#import "UVDataRecognizerType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVSourceSearchPresenter : BasePresenter <UVSourceSearchPresenterType>

- (instancetype)initWithSource:(id<UVSourceManagerType>)soucre dataRecognizer:(id<UVDataRecognizerType>)recognizer;

@end

NS_ASSUME_NONNULL_END
