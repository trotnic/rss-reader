//
//  UVSourceRepository.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 22.12.20.
//

#import <Foundation/Foundation.h>
#import "UVPListRepositoryType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVSourceRepository : NSObject <UVPListRepositoryType>

- (instancetype)initWithPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
