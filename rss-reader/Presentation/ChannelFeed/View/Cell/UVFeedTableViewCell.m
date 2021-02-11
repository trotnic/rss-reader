//
//  FeedTableViewCell.m
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import "UVFeedTableViewCell.h"

#import "UIImage+AppIcons.h"

static NSInteger const kPadding                     = 20;
static NSInteger const kMainTitleFontSize           = 18;
static NSInteger const kMainTextFontSize            = 16;
static NSInteger const kSupplementaryTextFontSize   = 14;
static NSInteger const kTextSpacing                 = 20;
static NSInteger const kTitleNumberOfLines          = 0;
static CGFloat   const kExpandAnimationDuration     = 0.2;
static CGFloat   const kExpandAnimationDelay        = 0;

@interface UVFeedTableViewCell ()

@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong, readwrite) UILabel *dateLabel;
@property (nonatomic, strong, readwrite) UILabel *categoryLabel;
@property (nonatomic, strong, readwrite) UILabel *descriptionLabel;

@property (nonatomic, retain) UIStackView *mainStack;
@property (nonatomic, retain) UIStackView *additionalStack;

@property (nonatomic, strong) UIButton *expandButton;

@property (nonatomic, copy) void(^onExpandButtonClickCallback)(void(^)(void));

@property (nonatomic, strong) id<UVFeedItemDisplayModel> model;

@end

@implementation UVFeedTableViewCell

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

- (void)layoutIfNeeded {
    [super layoutIfNeeded];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:kPadding],
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:kPadding],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-kPadding],
        [self.titleLabel.bottomAnchor constraintLessThanOrEqualToAnchor:self.mainStack.topAnchor constant:-kTextSpacing],
        
        [self.mainStack.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:kPadding],
        [self.mainStack.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:kPadding],
        [self.mainStack.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-kPadding],
        [self.mainStack.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-kPadding],
    ]];
}

// MARK: -

- (void)setupLayout {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.mainStack];
    
    [self.mainStack addArrangedSubview:self.descriptionLabel];
    [self.mainStack addArrangedSubview:self.additionalStack];
    
    [self.additionalStack addArrangedSubview:self.dateLabel];
    [self.additionalStack addArrangedSubview:self.categoryLabel];
    [self.additionalStack addArrangedSubview:self.expandButton];
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
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.font = [UIFont systemFontOfSize:kMainTitleFontSize weight:UIFontWeightBold];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _titleLabel;
}

- (UILabel *)descriptionLabel {
    if(!_descriptionLabel) {
        _descriptionLabel = [UILabel new];
        _descriptionLabel.numberOfLines = kTitleNumberOfLines;
        _descriptionLabel.textAlignment = NSTextAlignmentLeft;
        _descriptionLabel.font = [UIFont systemFontOfSize:kMainTextFontSize weight:UIFontWeightRegular];
    }
    return _descriptionLabel;
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
        [_expandButton setImage:UIImage.threeDotsHIcon forState:UIControlStateNormal];
        [_expandButton addTarget:self action:@selector(toggleDescription) forControlEvents:UIControlEventTouchUpInside];
    }
    return _expandButton;
}

- (UIStackView *)mainStack {
    if (!_mainStack) {
        _mainStack = [UIStackView new];
        _mainStack.axis = UILayoutConstraintAxisVertical;
        _mainStack.distribution = UIStackViewDistributionFill;
        _mainStack.spacing = kTextSpacing;
        _mainStack.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _mainStack;
}

- (UIStackView *)additionalStack {
    if (!_additionalStack) {
        _additionalStack = [UIStackView new];
        _additionalStack.axis = UILayoutConstraintAxisHorizontal;
        _additionalStack.distribution = UIStackViewDistributionEqualCentering;
    }
    return _additionalStack;
}

// MARK: -

- (void)setupWithModel:(id<UVFeedItemDisplayModel>)model
      reloadCompletion:(void (^)(void(^callback)(void)))completion {
    self.model = model;
    self.onExpandButtonClickCallback = completion;
    self.dateLabel.text = [self.model articleDate];
    self.titleLabel.text = [self.model articleTitle];
    self.categoryLabel.text = [self.model articleCategory];
    self.descriptionLabel.text = [self.model articleDescription];
    self.descriptionLabel.hidden = !self.model.isExpand;
}

// MARK: -
- (void)toggleDescription {
    self.onExpandButtonClickCallback(^{
        self.model.expand = !self.model.isExpand;
        [UIView animateKeyframesWithDuration:kExpandAnimationDuration delay:kExpandAnimationDelay options:0 animations:^{
            [self.titleLabel.heightAnchor constraintEqualToConstant:self.titleLabel.frame.size.height].active = YES;
            self.descriptionLabel.hidden = !self.model.isExpand;
        } completion:^(BOOL finished) {
            [self.titleLabel.heightAnchor constraintEqualToConstant:self.titleLabel.frame.size.height].active = NO;
        }];
    });
}

@end
