//
//  FeedCollectionViewCell.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 12/4/20.
//

#import <UIKit/UIKit.h>
#import "FeedItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedCollectionViewCell : UICollectionViewCell

+ (NSString *)cellIdentifier;
- (void)setupWithViewModel:(id<FeedItemViewModel>)viewModel reloadCompletion:(void(^)(void))completion;

@end

NS_ASSUME_NONNULL_END
