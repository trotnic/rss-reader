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

@property (nonatomic, retain, readwrite) UILabel *titleLabel;
@property (nonatomic, retain, readwrite) UILabel *dateLabel;
@property (nonatomic, retain, readwrite) UILabel *descriptionLabel;
@property (nonatomic, retain, readwrite) UILabel *categoryLabel;
@property (nonatomic, retain, readwrite) UIImageView *thumbImageView;


- (void)attachViewModel:(id<FeedItemViewModel>)viewModel;

@end

NS_ASSUME_NONNULL_END
