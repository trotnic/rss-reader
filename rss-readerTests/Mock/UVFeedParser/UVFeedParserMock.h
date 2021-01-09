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

@property (nonatomic, retain) NSURL *urlProvided;
@property (nonatomic, retain) NSData *dataProvided;
@property (nonatomic, retain) NSError *errorToReturn;
@property (nonatomic, retain) NSDictionary *dictionaryToReturn;
@property (nonatomic, assign) BOOL isCalled;

@end

NS_ASSUME_NONNULL_END
