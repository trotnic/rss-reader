//
//  FeedTableViewCell.m
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import "FeedTableViewCell.h"

static NSInteger const kPadding = 20;
static NSInteger const kFontSize = 17;
static NSInteger const kTextSpacing = 20;
static NSInteger const kTitleNumberOfLines = 0;

@interface FeedTableViewCell ()

@property (nonatomic, retain, readwrite) UILabel *titleLabel;
@property (nonatomic, retain, readwrite) UILabel *dateLabel;
@property (nonatomic, retain, readwrite) UILabel *categoryLabel;

@property (nonatomic, retain) UIStackView *mainStack;
@property (nonatomic, retain) UIStackView *textSubStack;
@property (nonatomic, retain) UIStackView *textMainStack;

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
    [_textSubStack release];
    [_textMainStack release];
    [_categoryLabel release];    
    [super dealloc];
}

// MARK: -

- (void)setupLayout {
    [self.textSubStack addArrangedSubview:self.dateLabel];
    [self.textSubStack addArrangedSubview:self.categoryLabel];
    
    [self.textMainStack addArrangedSubview:self.titleLabel];
    [self.textMainStack addArrangedSubview:self.textSubStack];
    
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
        _categoryLabel.font = [UIFont systemFontOfSize:kFontSize];
    }
    return _categoryLabel;
}

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines = kTitleNumberOfLines;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:kFontSize weight:UIFontWeightBold];
    }
    return _titleLabel;
}

- (UILabel *)dateLabel {
    if(!_dateLabel) {
        _dateLabel = [UILabel new];
        _dateLabel.font = [UIFont systemFontOfSize:kFontSize];
    }
    return _dateLabel;
}

- (UIStackView *)textSubStack {
    if(!_textSubStack) {
        _textSubStack = [UIStackView new];
        _textSubStack.axis = UILayoutConstraintAxisHorizontal;
        _textSubStack.distribution = UIStackViewDistributionEqualSpacing;
    }
    return _textSubStack;
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
