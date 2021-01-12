//
//  UVBaseViewController.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 12.01.21.
//

#import "UVBaseViewController.h"

@interface UVBaseViewController ()

@property (nonatomic, retain) UILabel *placeholderLabel;

@end

@implementation UVBaseViewController

- (void)dealloc
{
    [_placeholderLabel release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLabel];
}

// MARK: -

- (void)showPlaceholderMessage:(NSString *)text {
    self.placeholderLabel.text = text;
    self.placeholderLabel.hidden = NO;
    [self.view bringSubviewToFront:self.placeholderLabel];
}

- (void)hidePlaceholderMessage {
    self.placeholderLabel.text = nil;
    self.placeholderLabel.hidden = YES;
    [self.view sendSubviewToBack:self.placeholderLabel];
}

// MARK: - Private

- (void)setupLabel {
    [self.view addSubview:self.placeholderLabel];
    [NSLayoutConstraint activateConstraints:@[
        [self.placeholderLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.placeholderLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
    ]];
}

// MARK: - Lazy

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [UILabel new];
        _placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _placeholderLabel.textAlignment = NSTextAlignmentCenter;
        _placeholderLabel.hidden = YES;
    }
    return _placeholderLabel;
}

@end
