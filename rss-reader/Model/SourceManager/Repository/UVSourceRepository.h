//
//  UVSourceRepository.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 22.12.20.
//

#import <Foundation/Foundation.h>
#import "UVSourceRepositoryType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVSourceRepository : NSObject <UVSourceRepositoryType>

- (instancetype)initWithPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
