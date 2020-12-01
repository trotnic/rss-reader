//
//  FeedTableViewCell.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <UIKit/UIKit.h>
#import "FeedItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedTableViewCell : UITableViewCell

@property (nonatomic, retain, readonly) UILabel *titleLabel;
@property (nonatomic, retain, readonly) UILabel *dateLabel;
@property (nonatomic, retain, readonly) UILabel *categoryLabel;

+ (NSString *)cellIdentifier;
- (void)setupWithViewModel:(id<FeedItemViewModel>)viewModel;

@end

NS_ASSUME_NONNULL_END
