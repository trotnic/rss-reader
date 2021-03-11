//
//  UVSourceManagerMock.m
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 3.01.21.
//

#import "UVSourceManagerMock.h"

@interface UVSourceManagerMock ()

@end

@implementation UVSourceManagerMock

- (NSArray<UVRSSLink *> *)links {
    self.isCalled = YES;
    return self.linksToReturn;
}

- (BOOL)saveState:(out NSError **)error {
    self.isCalled = YES;
    if (error) {
        *error = self.savingError;
    }
    return YES;
}

- (void)selectLink:(UVRSSLink *)link {
    self.isCalled = YES;
    self.providedLinkToSelect = link;
}

- (UVRSSLink *)selectedLink {
    self.isCalled = YES;
    return self.selectedLinkToReturn;
}

- (void)deleteLink:(UVRSSLink *)link {
    self.isCalled = YES;
    self.providedLinkToDelete = link;
}

- (void)insertLink:(NSDictionary *)rawLink
     relativeToURL:(NSURL *)url {
    self.isCalled = YES;
    self.providedRawLinkToInsert = rawLink;
    self.providedRelativeURL = url;
}



- (void)insertLinks:(NSArray<NSDictionary *> *)rawLinks
      relativeToURL:(NSURL *)url {
    self.isCalled = YES;
    self.providedRawLinksToInsert = rawLinks;
    self.providedRelativeURL = url;
}


- (void)updateLink:(UVRSSLink *)link {
    self.isCalled = YES;
    self.providedLinkToUpdate = link;
}



@end
