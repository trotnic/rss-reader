//
//  UVCoordinatorTransition.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 11.02.2021.
//

#import <Foundation/Foundation.h>
#import "UVCoordinatorState.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVCoordinatorTransition : NSObject

@property (nonatomic, strong) UVCoordinatorState *initial;
@property (nonatomic, strong) UVCoordinatorState *terminal;
@property (nonatomic, assign) NSInteger identifier;

- (instancetype)initWithInitial:(UVCoordinatorState *)iState
                       terminal:(UVCoordinatorState *)tState
                     identifier:(NSInteger)identifier;

@end

NS_ASSUME_NONNULL_END
