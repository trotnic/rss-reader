//
//  UVLinksViewController.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 8.12.20.
//

#import <UIKit/UIKit.h>
#import "UVLinksViewType.h"
#import "UVLinksPresenterType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVLinksViewController : UIViewController <UVLinksViewType>


- (instancetype)initWithPresenter:(id<UVLinksPresenterType>)presenter;

@end

NS_ASSUME_NONNULL_END
