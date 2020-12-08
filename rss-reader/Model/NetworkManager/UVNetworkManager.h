//
//  UVNetworkManager.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 7.12.20.
//

#import <Foundation/Foundation.h>
#import "UVNetworkManagerType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVNetworkManager : NSObject <UVNetworkManagerType>

- (instancetype)initWithSession:(NSURLSession *)session;

@end

NS_ASSUME_NONNULL_END
