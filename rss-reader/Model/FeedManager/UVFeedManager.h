//
//  UVFeedManager.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 15.02.21.
//

#import <Foundation/Foundation.h>
#import "UVFeedManagerType.h"
#import "UVPListRepositoryType.h"
#import "UVSessionType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVFeedManager : NSObject <UVFeedManagerType>

- (instancetype)initWithSession:(id<UVSessionType>)session repository:(id<UVPListRepositoryType>)repository;

@end

NS_ASSUME_NONNULL_END
