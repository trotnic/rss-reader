//
//  NetworkService.h
//  rss-reader
//
//  Created by Uladzislau on 11/24/20.
//

#import <Foundation/Foundation.h>
#import "NetworkServiceType.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetworkService : NSObject <NetworkServiceType>

- (instancetype)initWithSession:(NSURLSession *)session;

@end

NS_ASSUME_NONNULL_END
