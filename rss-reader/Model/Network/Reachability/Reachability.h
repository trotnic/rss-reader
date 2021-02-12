//
//  Reachability.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 10.02.2021.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

#import "ReachabilityType.h"

extern NSString *kReachabilityChangedNotification;

@interface Reachability : NSObject <ReachabilityType>

+ (instancetype)reachabilityForInternetConnection;
// TODO: make the usage of these methods
- (BOOL)startNotifier;
- (void)stopNotifier;
- (BOOL)connectionRequired;

@end
