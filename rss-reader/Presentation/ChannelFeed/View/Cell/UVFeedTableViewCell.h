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
<<<<<<< HEAD:rss-reader/Presentation/ChannelFeed/View/Cell/UVFeedTableViewCell.h
- (void)setupWithModel:(id<UVFeedItemDisplayModel>)model reloadCompletion:(void(^)(void))completion;
=======
- (void)setupWithModel:(id<UVFeedItemDisplayModel>)model;
>>>>>>> develop:rss-reader/ContentFlow/View/Cell/FeedTableViewCell.h

@end

NS_ASSUME_NONNULL_END
