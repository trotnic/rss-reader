//
//  UVSourceListTableViewCell.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 24.02.2021.
//

#import <UIKit/UIKit.h>
#import "UVRSSLinkViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVSourceListTableViewCell : UITableViewCell

- (void)configureWithViewModel:(id<UVRSSLinkViewModel>)viewModel;

@end

NS_ASSUME_NONNULL_END
