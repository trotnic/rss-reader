//
//  UVTextFieldTableViewCell.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 17.12.20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UVTextFieldTableViewCell : UITableViewCell

@property (nonatomic, retain, readonly) UITextField *textField;
+ (NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END
