//
//  ViewController.m
//  iIntroductionTutorial
//
//  Created by Rajesh on 1/4/16.
//  Copyright © 2016 Org. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTutorialDirectionType:(TutorialDirectionType)([self.navigationController.viewControllers indexOfObject:self] + 1)];
    if (self.navigationController.viewControllers.count == kToBottomAndToTop) {
        [self.navigationItem setRightBarButtonItems:nil];
    }
    NSString *message;
    switch (self.tutorialDirectionType) {
        case kTap:
            message = NSLocalizedString(@"Tap indicator If not visible please kill the app and come back ", nil);
            break;
        case kToBottom :
            message = NSLocalizedString(@"Swipe down tutorial", nil);
            break;
        case kToTop :
            message = NSLocalizedString(@"Swipe up tutorial", nil);
            break;
        case kToLeft :
            message = NSLocalizedString(@"Swipe Left tutorial", nil);
            break;
        case kToRight :
            message = NSLocalizedString(@"Swipe Right tutorial", nil);
            break;
        case kToBottomAndToTop :
            message = NSLocalizedString(@"Swipe Up or Down tutorial", nil);
            break;
        case kToRightAndToLeft :
            message = NSLocalizedString(@"Swipe Right or Left tutorial", nil);
            break;
        default:
            break;
    }

    [self.messageLabel setText:message];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
