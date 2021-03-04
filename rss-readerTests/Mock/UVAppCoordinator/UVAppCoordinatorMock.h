//
//  UVAppCoordinatorMock.h
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 25.02.21.
//

#import <Foundation/Foundation.h>
#import "UVAppCoordinatorType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVAppCoordinatorMock : NSObject <UVAppCoordinatorType>

@property (nonatomic, assign) BOOL isCalled;
@property (nonatomic, assign) UVPresentationBlockType providedType;

@end

NS_ASSUME_NONNULL_END
