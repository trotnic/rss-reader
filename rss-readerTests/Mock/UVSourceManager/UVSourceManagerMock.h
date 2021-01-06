//
//  UVSourceManagerMock.h
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 3.01.21.
//

#import <Foundation/Foundation.h>
#import "UVSourceManagerType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVSourceManagerMock : NSObject <UVSourceManagerType>

@property (nonatomic, retain) NSArray<RSSLink *> *linksToReturn;
@property (nonatomic, retain) RSSSource *sourceToReturn;
@property (nonatomic, assign) BOOL isCalled;
@property (nonatomic, retain) NSMutableArray<RSSSource *> *sourcesToReturn;
@property (nonatomic, retain) RSSLink *linkToReturn;
@property (nonatomic, retain) NSError *insertionError;
@property (nonatomic, retain) NSError *savingError;

@property (nonatomic, retain) NSURL *providedURL;
@property (nonatomic, retain) NSArray<NSDictionary *> *providedLinks;
@property (nonatomic, assign) BOOL validationResultToReturn;

@end

NS_ASSUME_NONNULL_END
