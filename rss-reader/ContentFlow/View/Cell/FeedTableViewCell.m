//
//  FeedTableViewCell.m
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import "FeedTableViewCell.h"

NSInteger const kPadding = 20;
NSInteger const kMainTextFontSize = 18;
NSInteger const kSupplementaryTextFontSize = 14;
NSInteger const kTextSpacing = 20;
NSInteger const kTitleNumberOfLines = 0;

@interface FeedTableViewCell ()

@property (nonatomic, retain) UIStackView *mainStack;
@property (nonatomic, retain) UIStackView *textMainStack;

@property (nonatomic, retain) UIStackView *supplementaryTextStack;
@property (nonatomic, retain) UIStackView *supplementaryButtonStack;
@property (nonatomic, retain) UIStackView *supplementarySectionStack;

@property (nonatomic, retain) UIButton *expandButton;

@end

@implementation FeedTableViewCell

+ (NSString *)cellIdentifier {
    return NSStringFromClass(self);
}

// MARK: -

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupLayout];
    }
    return self;
}

- (void)dealloc
{
    [_mainStack release];
    [_dateLabel release];
    [_titleLabel release];
    [_textMainStack release];
    [_categoryLabel release];
    [_expandButton release];
    
    [_supplementaryTextStack release];
    [_supplementaryButtonStack release];
    [_supplementarySectionStack release];
    [super dealloc];
}

// MARK: -

- (void)setupLayout {
    [self.supplementaryTextStack addArrangedSubview:self.dateLabel];
    [self.supplementaryTextStack addArrangedSubview:self.categoryLabel];
    
    [self.supplementaryButtonStack addArrangedSubview:self.expandButton];
    
    [self.supplementarySectionStack addArrangedSubview:self.supplementaryTextStack];
    [self.supplementarySectionStack addArrangedSubview:self.supplementaryButtonStack];
    
    [self.textMainStack addArrangedSubview:self.titleLabel];
    [self.textMainStack addArrangedSubview:self.supplementarySectionStack];
    
    [self.mainStack addArrangedSubview:self.textMainStack];
    
    [self.contentView addSubview:self.mainStack];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.mainStack.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:kPadding],
        [self.mainStack.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:kPadding],
        [self.mainStack.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-kPadding],
        [self.mainStack.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-kPadding]
    ]];
}

// MARK: -

- (UILabel *)categoryLabel {
    if(!_categoryLabel) {
        _categoryLabel = [UILabel new];
        _categoryLabel.textColor = UIColor.grayColor;
        _categoryLabel.font = [UIFont systemFontOfSize:kSupplementaryTextFontSize];
    }
    return _categoryLabel;
}

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines = kTitleNumberOfLines;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:kMainTextFontSize weight:UIFontWeightBold];
    }
    return _titleLabel;
}

- (UILabel *)dateLabel {
    if(!_dateLabel) {
        _dateLabel = [UILabel new];
        _dateLabel.font = [UIFont systemFontOfSize:kSupplementaryTextFontSize];
    }
    return _dateLabel;
}

- (UIButton *)expandButton {
    if(!_expandButton) {
        _expandButton = [UIButton new];
        [_expandButton setImage:[UIImage systemImageNamed:@"ellipsis"] forState:UIControlStateNormal];
    }
    return _expandButton;
}

- (UIStackView *)supplementarySectionStack {
    if(!_supplementarySectionStack) {
        _supplementarySectionStack = [UIStackView new];
        _supplementarySectionStack.axis = UILayoutConstraintAxisHorizontal;
        _supplementarySectionStack.distribution = UIStackViewDistributionEqualSpacing;
    }
    return _supplementarySectionStack;
}

- (UIStackView *)supplementaryTextStack {
    if(!_supplementaryTextStack) {
        _supplementaryTextStack = [UIStackView new];
        _supplementaryTextStack.axis = UILayoutConstraintAxisHorizontal;
        _supplementaryTextStack.spacing = kTextSpacing / 2;
    }
    return _supplementaryTextStack;
}

- (UIStackView *)supplementaryButtonStack {
    if(!_supplementaryButtonStack) {
        _supplementaryButtonStack = [UIStackView new];
        _supplementaryButtonStack.axis = UILayoutConstraintAxisVertical;
        _supplementaryButtonStack.distribution = UIStackViewDistributionFill;
        _supplementaryButtonStack.alignment = UIStackViewAlignmentTrailing;
    }
    return _supplementaryButtonStack;
}

- (UIStackView *)textMainStack {
    if(!_textMainStack) {
        _textMainStack = [UIStackView new];
        _textMainStack.spacing = kTextSpacing;
        _textMainStack.alignment = UIStackViewAlignmentFill;
        _textMainStack.axis = UILayoutConstraintAxisVertical;
    }
    return _textMainStack;
}

- (UIStackView *)mainStack {
    if(!_mainStack) {
        _mainStack = [UIStackView new];
        _mainStack.axis = UILayoutConstraintAxisHorizontal;
        _mainStack.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _mainStack;
}

// MARK: -

- (void)setupWithViewModel:(id<FeedItemViewModel>)viewModel {
    self.dateLabel.text = [viewModel articleDate];
    self.titleLabel.text = [viewModel articleTitle];
    self.categoryLabel.text = [viewModel articleCategory];
}

@end
