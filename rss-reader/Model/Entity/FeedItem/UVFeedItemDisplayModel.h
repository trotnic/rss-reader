//
//  UVFeedItemDisplayModel.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UVFeedItemDisplayModel <NSObject>

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *category;
@property (nonatomic, copy, readonly) NSString *articleDate;
@property (nonatomic, copy, readonly) NSString *summary;
@property (nonatomic, assign, getter=isExpand) BOOL expand;
@property (nonatomic, assign, readonly, getter=isReading) BOOL reading;

@end

NS_ASSUME_NONNULL_END
