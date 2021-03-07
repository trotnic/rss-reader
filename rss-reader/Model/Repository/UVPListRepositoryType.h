//
//  UVSourceRepositoryType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 22.12.20.
//

#import <Foundation/Foundation.h>
#import "UVPropertyListConvertible.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UVPListRepositoryType <NSObject>

- (NSArray<NSDictionary *> *)fetchData:(NSString *)file error:(out NSError **)error;
- (BOOL)updateData:(NSArray<NSDictionary *> *)data file:(NSString *)file error:(out NSError **)error;
- (BOOL)isFileExists:(NSString *)file;

@end

NS_ASSUME_NONNULL_END
