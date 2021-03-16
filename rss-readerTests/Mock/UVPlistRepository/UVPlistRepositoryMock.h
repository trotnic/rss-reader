//
//  UVPlistRepositoryMock.h
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 9.01.21.
//

#import <Foundation/Foundation.h>
#import "UVPListRepositoryType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVPlistRepositoryMock : NSObject <UVPListRepositoryType>

@property (nonatomic, strong) NSArray<NSDictionary *> *fetchedToReturn;
@property (nonatomic, assign) BOOL updatedToReturn;
@property (nonatomic, strong) NSArray<NSDictionary *> *dataProvided;
@property (nonatomic, strong) NSError *fetchingErrorToReturn;
@property (nonatomic, strong) NSError *updateErrorToReturn;
@property (nonatomic, assign) BOOL isCalled;

@end

NS_ASSUME_NONNULL_END
