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

@property (nonatomic, retain) NSArray<UVRSSLink *> *linksToReturn;
@property (nonatomic, assign) BOOL saveStateToReturn;
@property (nonatomic, assign) BOOL isCalled;
@property (nonatomic, retain) UVRSSLink *providedLinkToSelect;
@property (nonatomic, retain) UVRSSLink *selectedLinkToReturn;
@property (nonatomic, retain) UVRSSLink *providedLinkToDelete;
@property (nonatomic, retain) UVRSSLink *providedLinkToUpdate;
@property (nonatomic, retain) NSDictionary *providedRawLinkToInsert;
@property (nonatomic, retain) NSArray<NSDictionary *> *providedRawLinksToInsert;
@property (nonatomic, retain) NSURL *providedRelativeURL;
@property (nonatomic, retain) NSError *savingError;

@end

NS_ASSUME_NONNULL_END
