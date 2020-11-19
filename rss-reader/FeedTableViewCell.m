//
//  FeedTableViewCell.m
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import "FeedTableViewCell.h"

@interface FeedTableViewCell ()

@property (nonatomic, retain) id<FeedItemViewModel> viewModel;

@end

@implementation FeedTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [UILabel new];
        _dateLabel = [UILabel new];
        _descriptionLabel = [UILabel new];
        _categoryLabel = [UILabel new];
        _thumbImageView = [UIImageView new];
        [self setupView];
    }
    return self;
}

- (void)setupView {
    UIStackView *textSubStack = [[UIStackView alloc] initWithArrangedSubviews:@[
        self.categoryLabel,
        self.dateLabel
    ]];
    
    textSubStack.axis = UILayoutConstraintAxisHorizontal;
    textSubStack.distribution = UIStackViewDistributionEqualSpacing;
    
    UIStackView *textMainStack = [[UIStackView alloc] initWithArrangedSubviews:@[
        self.titleLabel,
        textSubStack
    ]];
    
    textMainStack.axis = UILayoutConstraintAxisVertical;
    textMainStack.alignment = UIStackViewAlignmentFill;
    textMainStack.spacing = 15;
    
    UIStackView *mainStack = [[UIStackView alloc] initWithArrangedSubviews:@[
        self.thumbImageView,
        textMainStack
    ]];
    
    [self.contentView addSubview:mainStack];
    mainStack.translatesAutoresizingMaskIntoConstraints = NO;
    
    [mainStack.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20].active = YES;
    [mainStack.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:20].active = YES;
    [mainStack.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20].active = YES;
    [mainStack.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-20].active = YES;
    
    mainStack.axis = UILayoutConstraintAxisHorizontal;
    
    self.titleLabel.numberOfLines = 4;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    self.thumbImageView.hidden = YES;
    
    [textSubStack release];
    [textMainStack release];
    [mainStack release];
    
    [self setupLabels];
}

- (void)setupLabels {
    self.categoryLabel.font = [UIFont systemFontOfSize:16];
    self.categoryLabel.textColor = UIColor.grayColor;
    
    self.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    
    self.dateLabel.font = [UIFont systemFontOfSize:16];
}

- (void)attachViewModel:(id<FeedItemViewModel>)viewModel {
    self.viewModel = [viewModel retain];
    self.titleLabel.text = [viewModel articleTitle];
    self.categoryLabel.text = [viewModel articleCategory];
    self.dateLabel.text = [viewModel articleDate];
}

- (void)dealloc
{
    [_viewModel release];
    [_titleLabel release];
    [_dateLabel release];
    [_descriptionLabel release];
    [_categoryLabel release];
    [_thumbImageView release];
    [super dealloc];
}

@end
