//
//  FeedTableViewCell.m
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import "FeedTableViewCell.h"

NSInteger const kPadding = 20;
NSInteger const kMainTitleFontSize = 18;
NSInteger const kMainTextFontSize = 16;
NSInteger const kSupplementaryTextFontSize = 14;
NSInteger const kTextSpacing = 20;
NSInteger const kTitleNumberOfLines = 0;

@interface FeedTableViewCell ()

@property (nonatomic, retain, readwrite) UILabel *titleLabel;
@property (nonatomic, retain, readwrite) UILabel *dateLabel;
@property (nonatomic, retain, readwrite) UILabel *categoryLabel;
@property (nonatomic, retain, readwrite) UILabel *descriptionLabel;

@property (nonatomic, retain) UIStackView *mainStack;
@property (nonatomic, retain) UIStackView *supplementaryTextStack;
@property (nonatomic, retain) UIStackView *supplementaryButtonStack;
@property (nonatomic, retain) UIStackView *supplementarySectionStack;

@property (nonatomic, retain) UIButton *expandButton;

@property (nonatomic, copy) void(^setupCompletion)(BOOL);

@property (nonatomic, retain) id<FeedItemViewModel> viewModel;

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
    [_categoryLabel release];
    [_expandButton release];
    [_descriptionLabel release];
    [_setupCompletion release];
    [_viewModel release];
    
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
    
    [self.mainStack addArrangedSubview:self.titleLabel];
    [self.mainStack addArrangedSubview:self.descriptionLabel];
    [self.mainStack addArrangedSubview:self.supplementarySectionStack];
    
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
        _titleLabel.font = [UIFont systemFontOfSize:kMainTitleFontSize weight:UIFontWeightBold];
    }
    return _titleLabel;
}

// MARK: --

- (UILabel *)descriptionLabel {
    if(!_descriptionLabel) {
        _descriptionLabel = [UILabel new];
        _descriptionLabel.numberOfLines = kTitleNumberOfLines;
        _descriptionLabel.textAlignment = NSTextAlignmentLeft;
        _descriptionLabel.font = [UIFont systemFontOfSize:kMainTextFontSize weight:UIFontWeightRegular];
    }
    return _descriptionLabel;
}
// MARK: --

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
        [_expandButton setImage:[UIImage imageNamed:@"ellipsis"] forState:UIControlStateNormal];
        [_expandButton addTarget:self action:@selector(toggleDescription) forControlEvents:UIControlEventTouchUpInside];
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

- (UIStackView *)mainStack {
    if(!_mainStack) {
        _mainStack = [UIStackView new];
        _mainStack.spacing = kTextSpacing;
        _mainStack.axis = UILayoutConstraintAxisVertical;
        _mainStack.alignment = UIStackViewAlignmentFill;
        _mainStack.distribution = UIStackViewDistributionFill;
        _mainStack.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _mainStack;
}

// MARK: -

- (void)setupWithViewModel:(id<FeedItemViewModel>)viewModel
          reloadCompletion:(void(^)(BOOL))completion {
    self.viewModel = viewModel;
    self.viewModel.frame = self.frame;
    self.setupCompletion = completion;
    self.dateLabel.text = [self.viewModel articleDate];
    self.titleLabel.text = [self.viewModel articleTitle];
    self.categoryLabel.text = [self.viewModel articleCategory];
    self.descriptionLabel.text = [self.viewModel articleDescription];
    [self layoutIfNeeded];
    self.descriptionLabel.hidden = !self.viewModel.isExpand;
}

// MARK: -
- (void)toggleDescription {
    self.viewModel.expand = !self.viewModel.isExpand;
    self.descriptionLabel.hidden = self.viewModel.isExpand;
    self.viewModel.frame = self.bounds;
    self.setupCompletion(self.viewModel.isExpand);
}

@end
