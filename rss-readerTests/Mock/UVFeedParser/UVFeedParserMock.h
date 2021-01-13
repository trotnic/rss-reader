//
//  UVFeedParserMock.h
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 8.01.21.
//

#import <Foundation/Foundation.h>
#import "UVFeedParserType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVFeedParserMock : NSObject <UVFeedParserType>

@property (nonatomic, strong) NSURL *urlProvided;
@property (nonatomic, strong) NSData *dataProvided;
@property (nonatomic, strong) NSError *errorToReturn;
@property (nonatomic, strong) NSDictionary *dictionaryToReturn;
@property (nonatomic, assign) BOOL isCalled;

@end

NS_ASSUME_NONNULL_END
