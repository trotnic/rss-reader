//
//  UIViewController+ErrorPresenter.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 11/26/20.
//

#import "UIViewController+ErrorPresenter.h"

@implementation UIViewController (ErrorPresenter)

- (void)showError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:error.localizedFailureReason
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
