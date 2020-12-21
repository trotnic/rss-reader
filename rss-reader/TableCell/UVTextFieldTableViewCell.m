//
//  UVTextFieldTableViewCell.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 17.12.20.
//

#import "UVTextFieldTableViewCell.h"

@interface UVTextFieldTableViewCell ()

@property (nonatomic, retain, readwrite) UITextField *textField;

@end

@implementation UVTextFieldTableViewCell

+ (NSString *)reuseIdentifier {
    return NSStringFromClass(self);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupLayout];
    }
    return self;
}

- (void)dealloc
{
    [_textField release];
    [super dealloc];
}

// MARK: -

- (void)setupLayout {
    [self.contentView addSubview:self.textField];
    [NSLayoutConstraint activateConstraints:@[
        [self.textField.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16.0],
        [self.textField.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.textField.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16.0],
        [self.textField.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
    ]];
}

// MARK: - Lazy

- (UITextField *)textField {
    if(!_textField) {
        _textField = [UITextField new];
        _textField.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _textField;
}


@end
