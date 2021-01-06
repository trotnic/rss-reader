//
//  UVBaseViewType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 6.01.21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UVBaseViewType <NSObject>

- (void)updatePresentation;
- (void)presentError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
