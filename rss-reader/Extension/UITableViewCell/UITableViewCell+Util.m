//
//  UITableViewCell+Util.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 25.02.21.
//

#import "UITableViewCell+Util.h"

@implementation UITableViewCell (Util)

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

@end
