//
//  UVSession.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 07.03.2021.
//

#import <Foundation/Foundation.h>
#import "UVSessionType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVSession : NSObject <UVSessionType>

@property (nonatomic, assign) BOOL shouldRestore;

- (instancetype)initWithDefaults:(NSUserDefaults *)defaults;

@end

NS_ASSUME_NONNULL_END
