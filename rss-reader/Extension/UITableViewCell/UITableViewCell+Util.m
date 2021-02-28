//
//  UITableViewCell+Util.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 28.02.2021.
//

#import "UITableViewCell+Util.h"

@implementation UITableViewCell (Util)

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

@end
