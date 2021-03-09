//
//  UVStack.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 07.03.2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UVStack : NSObject

- (id)pop;
- (id)peek;
- (void)push:(id)obj;

@end

NS_ASSUME_NONNULL_END
