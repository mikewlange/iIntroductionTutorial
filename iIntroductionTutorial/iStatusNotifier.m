//
//  iStatusNotifier.m
//  iStatusNotifier
//
//  Created by Rajesh on 3/25/15.
//

#import "iStatusNotifier.h"
@interface iStatusNotifier()
@property(nonatomic,strong) UIWindow *statusWindow;
@property(nonatomic,assign) BOOL isVisible;
@property (nonatomic, strong) void (^completion)(void);
@end

@implementation iStatusNotifier

+ (instancetype)sharedInstance
{
    static iStatusNotifier *objNotifier;
    if (!objNotifier)
    {
        objNotifier = [[self alloc] init];
        
        objNotifier.statusWindow = [[UIWindow alloc] initWithFrame:[[UIApplication sharedApplication] statusBarFrame]];
        objNotifier.statusWindow.windowLevel = UIWindowLevelStatusBar;
        [objNotifier.statusWindow makeKeyAndVisible];
        objNotifier.lblMessage = [[UILabel alloc] initWithFrame:objNotifier.statusWindow.frame];
        [objNotifier.lblMessage setBackgroundColor:[UIColor whiteColor]];
        [objNotifier.lblMessage setTextAlignment:NSTextAlignmentCenter];
        [objNotifier.statusWindow addSubview:objNotifier.lblMessage];
        [[[iStatusNotifier sharedInstance] lblMessage] setAlpha:0.];
    }
    return objNotifier;
}

+ (void)showStatusBarAlert:(NSString *)stMessage {
    iStatusNotifier *notifier = [iStatusNotifier sharedInstance];
    [[notifier lblMessage] setHidden:NO];
    [[notifier lblMessage] setText:stMessage];
    [[notifier lblMessage] setAlpha:0.];
    [UIView animateWithDuration:0.5f delay:0. options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        [notifier setIsVisible:YES];
        [[notifier lblMessage] setAlpha:1.];
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([notifier iDuration] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (notifier.isVisible) {
                [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
                    [[notifier lblMessage] setAlpha:0.];
                }completion:^(BOOL finished) {
                    if (notifier.completion) notifier.completion();
                    [self dismiss];
                }];
            }
        });
    }];
}

+ (void)setDuration:(NSTimeInterval)duration {
    [[self sharedInstance] setIDuration:duration];
}

+ (void)showStatusBarAlert:(NSString *)stMessage completion:(void (^)(void))completion {
    [[iStatusNotifier sharedInstance] setCompletion:completion];
    [self showStatusBarAlert:stMessage];
}

+ (void)dismiss {
    iStatusNotifier *notifier = [iStatusNotifier sharedInstance];
    if (notifier.isVisible) {
        [notifier setCompletion:nil];
        [[notifier lblMessage] setHidden:YES];
        [notifier setIsVisible:NO];
    }
}

@end
