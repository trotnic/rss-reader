//
//  UVChannelSourceTableViewCell.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 26.02.21.
//

#import <UIKit/UIKit.h>
#import "UVRSSLinkViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVChannelSourceTableViewCell : UITableViewCell

- (void)configureWithViewModel:(id<UVRSSLinkViewModel>)viewModel;

@end

NS_ASSUME_NONNULL_END
