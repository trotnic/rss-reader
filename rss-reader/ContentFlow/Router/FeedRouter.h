//
//  FeedRouter.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <UIKit/UIKit.h>
#import "MainRouter.h"
#import "DIContainerType.h"
#import "ErrorManagerType.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedRouter : NSObject <MainRouter>

@property (nonatomic, retain, readonly) id<ErrorManagerType> errorManager;
@property (nonatomic, retain, readonly) UIApplication *application;

- (instancetype)initWithWindow:(UIWindow *)window dependencies:(id<DIContainerType>)container;

@end

NS_ASSUME_NONNULL_END
