//
//  UVNetwork.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 27.12.20.
//

#import <Foundation/Foundation.h>
#import "UVNetworkManagerType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVNetwork : NSObject <UVNetworkManagerType>

+ (instancetype)shared;

@end

NS_ASSUME_NONNULL_END
