//
//  UVSearchViewControllerDelegate.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 20.12.20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UVSearchViewControllerDelegate <NSObject>

- (void)searchAcceptedWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
