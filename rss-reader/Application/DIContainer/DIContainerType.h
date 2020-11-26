//
//  DIContainerType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 11/26/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DIContainerType;
typedef id _Nonnull (^FactoryBlock)(id<DIContainerType>);

@protocol DIContainerType <NSObject>

- (void)registerServiceOfType:(NSString *)type withCompletion:(FactoryBlock)completion;
- (id)resolveServiceOfType:(NSString *)type;

@end

NS_ASSUME_NONNULL_END
