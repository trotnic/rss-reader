//
//  UVBaseViewController.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 12.01.21.
//

#import "UVBaseViewController.h"

#import "UVDebug.h"

#ifdef DEBUG_AREA

#import "UVDebugViewController.h"

#endif

@interface UVBaseViewController ()

@property (nonatomic, retain) UILabel *placeholderLabel;

#ifdef DEBUG_AREA

@property (nonatomic, strong) UIButton *butty;

#endif

@end

@implementation UVBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLabel];
    
#ifdef DEBUG_AREA
    
    self.butty = [UIButton new];
    self.butty.backgroundColor = [UIColor.redColor colorWithAlphaComponent:0.05];
    self.butty.translatesAutoresizingMaskIntoConstraints = NO;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(dothings:)];
    [self.butty addGestureRecognizer:longPress];
    [self.view addSubview:self.butty];
    
    
    [NSLayoutConstraint activateConstraints:@[
        [self.butty.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:50],
        [self.butty.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-50],
        [self.butty.heightAnchor constraintEqualToConstant:50],
        [self.butty.widthAnchor constraintEqualToConstant:50],
    ]];
    
    
#endif
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
#ifdef DEBUG_AREA
    [self.view bringSubviewToFront:self.butty];
#endif
}

#ifdef DEBUG_AREA

- (void)dothings:(UILongPressGestureRecognizer*)gesture {
    if ( gesture.state == UIGestureRecognizerStateEnded ) {
        UVDebugViewController *control = [UVDebugViewController new];
//        UIAlertController *control = [UIAlertController alertControllerWithTitle:@"LOLKEK" message:@"CHEBUREK" preferredStyle:UIAlertControllerStyleActionSheet];
//        [control addAction:[UIAlertAction actionWithTitle:@"👌" style:UIAlertActionStyleCancel handler:nil]];
        [self.navigationController pushViewController:control animated:YES];
    }
}

#endif

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
