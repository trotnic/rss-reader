//
//  UVFeedTableViewCell.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <UIKit/UIKit.h>
#import "UVFeedItemDisplayModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVFeedTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *dateLabel;
@property (nonatomic, strong, readonly) UILabel *categoryLabel;
@property (nonatomic, strong, readonly) UILabel *descriptionLabel;

+ (NSString *)cellIdentifier;
- (void)setupWithModel:(id<UVFeedItemDisplayModel>)model reloadCompletion:(void(^)(void(^callback)(void)))completion;

@end

NS_ASSUME_NONNULL_END
