//
//  UVSourcesListViewMock.h
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 6.01.21.
//

#import <UIKit/UIKit.h>
#import "UVSourcesListViewType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVSourcesListViewMock : UIViewController <UVSourcesListViewType>

@property (nonatomic, assign) BOOL isCalled;
@property (nonatomic, assign) BOOL isUpdate;
@property (nonatomic, retain) NSError *error;

@end

NS_ASSUME_NONNULL_END
