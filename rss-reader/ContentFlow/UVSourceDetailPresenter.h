//
//  UVLinksPresenter.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 8.12.20.
//

#import <Foundation/Foundation.h>
#import "UVSourceDetailPresenterType.h"
#import "UVSourceManagerType.h"
#import "BasePresenter.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVSourceDetailPresenter : BasePresenter <UVSourceDetailPresenterType>

- (instancetype)initWithModel:(RSSSource *)model sourceManager:(id<UVSourceManagerType>)sourceManager;

@end

NS_ASSUME_NONNULL_END
