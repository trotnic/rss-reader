//
//  UVFeedProviderMock.h
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 2.01.21.
//

#import <Foundation/Foundation.h>
#import "UVFeedProviderType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVFeedProviderMock : NSObject <UVFeedProviderType>

@property (nonatomic, assign) BOOL isCalled;
@property (nonatomic, retain) UVFeedChannel *channel;
@property (nonatomic, retain) NSError *error;

@end

NS_ASSUME_NONNULL_END
