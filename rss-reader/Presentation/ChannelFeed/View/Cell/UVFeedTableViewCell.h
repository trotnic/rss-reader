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

@property (nonatomic, retain, readonly) UILabel *titleLabel;
@property (nonatomic, retain, readonly) UILabel *dateLabel;
@property (nonatomic, retain, readonly) UILabel *categoryLabel;
@property (nonatomic, retain, readonly) UILabel *descriptionLabel;

+ (NSString *)cellIdentifier;
- (void)setupWithModel:(id<UVFeedItemDisplayModel>)model reloadCompletion:(void(^)(void))completion;

@end

NS_ASSUME_NONNULL_END
