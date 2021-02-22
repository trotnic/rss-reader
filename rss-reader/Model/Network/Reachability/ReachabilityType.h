//
//  ReachabilityType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 10.02.2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSInteger {
    NotReachable = 0,
    ReachableViaWiFi,
    ReachableViaWWAN
} NetworkStatus;

@protocol ReachabilityType <NSObject>

- (BOOL)connectionRequired;
- (NetworkStatus)currentReachabilityStatus;

@end

NS_ASSUME_NONNULL_END
