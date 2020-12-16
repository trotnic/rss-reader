//
//  BaseViewType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 16.12.20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BaseViewType <NSObject>

- (void)presentError:(NSError *)error;
- (void)updatePresentation;

@end

NS_ASSUME_NONNULL_END
