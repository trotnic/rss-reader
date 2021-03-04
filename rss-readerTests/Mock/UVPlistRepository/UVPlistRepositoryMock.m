//
//  UVPlistRepositoryMock.m
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 9.01.21.
//

#import "UVPlistRepositoryMock.h"

@implementation UVPlistRepositoryMock

- (NSArray<NSDictionary *> *)fetchData:(out NSError **)error {
    self.isCalled = YES;
    if (error) {
        *error = self.fetchingErrorToReturn;
    }
    return self.fetchedToReturn;
}

- (BOOL)updateData:(NSArray<NSDictionary *> *)data
             error:(out NSError **)error {
    self.isCalled = YES;
    self.dataProvided = data;
    if (error) {
        *error = self.updateErrorToReturn;
    }
    return self.updatedToReturn;
}

@end
