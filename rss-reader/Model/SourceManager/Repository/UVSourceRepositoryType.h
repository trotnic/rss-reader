//
//  UVSourceRepositoryType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 22.12.20.
//

#import <Foundation/Foundation.h>
#import "UVPropertyListConvertible.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UVSourceRepositoryType <NSObject>

- (NSArray<NSDictionary *> *)fetchData:(out NSError **)error;
- (void)updateData:(NSArray<NSDictionary *> *)data error:(out NSError **)error;

@end

NS_ASSUME_NONNULL_END
