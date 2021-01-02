//
//  UVBasePresenter.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 2.01.21.
//

#import <Foundation/Foundation.h>
#import "UVBaseViewType.h"
#import "RSSError.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVBasePresenter : NSObject

@property (nonatomic, assign) id<UVBaseViewType> view;

- (void)showError:(RSSError)error;

@end

NS_ASSUME_NONNULL_END
