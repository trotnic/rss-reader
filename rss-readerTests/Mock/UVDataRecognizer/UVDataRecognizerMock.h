//
//  UVDataRecognizerMock.h
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 3.01.21.
//

#import <Foundation/Foundation.h>
#import "UVDataRecognizerType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVDataRecognizerMock : NSObject <UVDataRecognizerType>

@property (nonatomic, retain) NSDictionary *rawChannel;
@property (nonatomic, retain) NSError *error;
@property (nonatomic, retain) NSArray<NSDictionary *> *rawLinks;
@property (nonatomic, assign) BOOL isCalled;

@end

NS_ASSUME_NONNULL_END
