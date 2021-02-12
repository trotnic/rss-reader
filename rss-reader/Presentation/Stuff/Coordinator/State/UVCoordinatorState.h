//
//  UVCoordinatorState.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 11.02.2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UVCoordinatorState : NSObject

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, copy) void(^enterCallback)(void);
@property (nonatomic, copy) void(^exitCallback)(void);

- (instancetype)initWithIdentifier:(NSInteger)identifier;

@end

NS_ASSUME_NONNULL_END
