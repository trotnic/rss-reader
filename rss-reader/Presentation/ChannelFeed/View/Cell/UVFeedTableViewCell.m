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
@property (nonatomic, retain) UIStackView *auxiliaryStack;

@property (nonatomic, retain) UIButton *expandButton;

@property (nonatomic, copy) void(^buttonClickedCallback)(void(^)(void));

@property (nonatomic, retain) id<UVFeedItemDisplayModel> model;

@end

@implementation UVFeedTableViewCell

// MARK: -

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupAppearance];
    }
    return self;
}

- (void)dealloc {
    [_titleLabel release];
    [_dateLabel release];
    [_categoryLabel release];
    [_descriptionLabel release];
    [_mainStack release];
    [_auxiliaryStack release];
    [_expandButton release];
    [_buttonClickedCallback release];
    [_model release];
    [super dealloc];
}

// MARK: - Lazy Properties

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
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.font = [UIFont systemFontOfSize:kMainTitleFontSize weight:UIFontWeightBold];
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
        _mainStack.spacing = kTextSpacing;
        _mainStack.axis = UILayoutConstraintAxisVertical;
        _mainStack.distribution = UIStackViewDistributionFill;
        _mainStack.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _mainStack;
}

- (UIStackView *)auxiliaryStack {
    if (!_auxiliaryStack) {
        _auxiliaryStack = [UIStackView new];
        _auxiliaryStack.axis = UILayoutConstraintAxisHorizontal;
        _auxiliaryStack.distribution = UIStackViewDistributionEqualSpacing;
    }
    return _auxiliaryStack;
}

// MARK: - Private

- (void)setupAppearance {
    [self arrangeViews];
    [self setupConstraints];
}

- (void)arrangeViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.mainStack];
    
    [self.mainStack addArrangedSubview:self.descriptionLabel];
    [self.mainStack addArrangedSubview:self.auxiliaryStack];
    
    [self.auxiliaryStack addArrangedSubview:self.dateLabel];
    [self.auxiliaryStack addArrangedSubview:self.categoryLabel];
    [self.auxiliaryStack addArrangedSubview:self.expandButton];
}

- (void)setupConstraints {
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

- (void)toggleDescription {
    self.buttonClickedCallback(^{
        self.model.expand = !self.model.isExpand;
        [UIView animateKeyframesWithDuration:kExpandAnimationDuration delay:kExpandAnimationDelay options:0 animations:^{
            [self.titleLabel.heightAnchor constraintEqualToConstant:self.titleLabel.frame.size.height].active = YES;
            self.descriptionLabel.hidden = !self.model.isExpand;
        } completion:^(BOOL finished) {
            [self.titleLabel.heightAnchor constraintEqualToConstant:self.titleLabel.frame.size.height].active = NO;
        }];
    });
}

// MARK: - Interface

- (void)setupWithModel:(id<UVFeedItemDisplayModel>)model
      reloadCompletion:(void (^)(void(^callback)(void)))completion {
    self.model = model;
    self.buttonClickedCallback = completion;
    self.dateLabel.text = self.model.articleDate;
    self.titleLabel.text = self.model.title;
    self.categoryLabel.text = self.model.category;
    self.descriptionLabel.text = self.model.summary;
    self.descriptionLabel.hidden = !self.model.isExpand;
}

@end
