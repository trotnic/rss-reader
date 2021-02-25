//
//  UVSourceListTableViewCell.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 24.02.2021.
//

#import "UVSourceListTableViewCell.h"

@implementation UVSourceListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.numberOfLines = 0;
    }
    return self;
}

- (void)configureWithViewModel:(id<UVRSSLinkViewModel>)viewModel {
    self.textLabel.text = viewModel.linkTitle;
    self.accessoryType = viewModel.isSelected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

@end
