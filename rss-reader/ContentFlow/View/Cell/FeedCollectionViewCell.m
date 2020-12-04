//
//  FeedCollectionViewCell.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 12/4/20.
//

#import "FeedCollectionViewCell.h"

@interface FeedCollectionViewCell ()

@property (nonatomic, retain, readwrite) UILabel *titleLabel;
@property (nonatomic, retain, readwrite) UILabel *dateLabel;
@property (nonatomic, retain, readwrite) UILabel *categoryLabel;
@property (nonatomic, retain, readwrite) UILabel *descriptionLabel;

@property (nonatomic, retain) UIStackView *mainStack;

@property (nonatomic, retain) UIStackView *supplementaryTextStack;
@property (nonatomic, retain) UIStackView *supplementaryButtonStack;
@property (nonatomic, retain) UIStackView *supplementarySectionStack;

@property (nonatomic, retain) UIButton *expandButton;

@property (nonatomic, retain) id<FeedItemViewModel> viewModel;

@end

@implementation FeedCollectionViewCell

+ (NSString *)cellIdentifier {
    return NSStringFromClass(self);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
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
    
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addSubview:self.mainStack];
    
    [NSLayoutConstraint activateConstraints:@[
//        [self.contentView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
//        [self.contentView.topAnchor constraintEqualToAnchor:self.topAnchor],
//        [self.contentView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.contentView.bottomAnchor constraintEqualToAnchor:self.mainStack.bottomAnchor],
        [self.mainStack.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
        [self.mainStack.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:20],
        [self.mainStack.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20],
        [self.mainStack.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-20]
    ]];
}

// MARK: - Lazy

- (UILabel *)categoryLabel {
    if(!_categoryLabel) {
        _categoryLabel = [UILabel new];
        _categoryLabel.textColor = UIColor.grayColor;
        _categoryLabel.font = [UIFont systemFontOfSize:14];
    }
    return _categoryLabel;
}

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    }
    return _titleLabel;
}

- (UILabel *)descriptionLabel {
    if(!_descriptionLabel) {
        _descriptionLabel = [UILabel new];
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.textAlignment = NSTextAlignmentLeft;
        _descriptionLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    }
    return _descriptionLabel;
}

- (UILabel *)dateLabel {
    if(!_dateLabel) {
        _dateLabel = [UILabel new];
        _dateLabel.font = [UIFont systemFontOfSize:14];
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
        _supplementaryTextStack.spacing = 20 / 2;
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
        _mainStack.spacing = 20;
        _mainStack.axis = UILayoutConstraintAxisVertical;
        _mainStack.alignment = UIStackViewAlignmentFill;
        _mainStack.distribution = UIStackViewDistributionFill;
        _mainStack.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _mainStack;
}

// MARK: -

- (void)toggleDescription {
    self.descriptionLabel.hidden = !self.viewModel.isExpand;
    self.viewModel.expand = !self.viewModel.isExpand;
}

- (void)setupWithViewModel:(id<FeedItemViewModel>)viewModel
          reloadCompletion:(void(^)(void))completion {
    self.viewModel = viewModel;
    self.dateLabel.text = [self.viewModel articleDate];
    self.titleLabel.text = [self.viewModel articleTitle];
    self.categoryLabel.text = [self.viewModel articleCategory];
    self.descriptionLabel.text = [self.viewModel articleDescription];
    self.descriptionLabel.hidden = !self.viewModel.isExpand;
}

@end
