//
<<<<<<< HEAD
//  UVFeedItemDisplayModel.h
=======
<<<<<<< HEAD:rss-reader/Presentation/ChannelFeed/Presenter/UVFeedPresenterType.h
//  UVFeedPresenterType.h
=======
//  UVFeedItemDisplayModel.h
>>>>>>> develop:rss-reader/Model/Entity/FeedItem/UVFeedItemDisplayModel.h
>>>>>>> develop
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

<<<<<<< HEAD
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UVFeedItemDisplayModel <NSObject>

@property (nonatomic, assign, getter=isExpand) BOOL expand;
@property (nonatomic, assign) CGRect frame;

- (NSString *)articleTitle;
- (NSString *)articleCategory;
- (NSString *)articleDate;
- (NSString *)articleDescription;
=======
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

<<<<<<< HEAD:rss-reader/Presentation/ChannelFeed/Presenter/UVFeedPresenterType.h
@protocol UVFeedPresenterType <NSObject>
=======
@protocol UVFeedItemDisplayModel <NSObject>
>>>>>>> develop:rss-reader/Model/Entity/FeedItem/UVFeedItemDisplayModel.h

- (void)updateFeed;
- (void)openArticleAt:(NSInteger)row;
>>>>>>> develop

@end

NS_ASSUME_NONNULL_END
