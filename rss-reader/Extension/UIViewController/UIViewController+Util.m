//
//  UIViewController+Util.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 11/26/20.
//

#import "UIViewController+Util.h"

@implementation UIViewController (Util)

- (void)showError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:error.localizedFailureReason
                                                                   message:error.localizedDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(ALERT_OK_BUTTON_TITLE, "")  style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

@end
