//
//  TutorialHandler.m
//  Fessup
//
//  Created by Rajesh on 1/4/16.
//  Copyright © 2016 Org. All rights reserved.
//

#import "iTutorialHandler.h"
#import "iStatusNotifier.h"


@interface ITApplication : UIApplication

@end

@implementation ITApplication

- (void)sendEvent:(UIEvent *)event {
    if (event.type == UIEventTypeTouches) {
        [TutorialHandler handleTouch];
    }
    [super sendEvent:event];
}

@end

@implementation ITTutorialViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [TutorialHandler handleTouch];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.isViewLoaded && self.view.window && self.tutorialDirectionType && [TutorialHandler shouldShowTutorial:self.tutorialDirectionType]) {
            [TutorialHandler showTutorialForViewController:self];
        }
    });
}
@end

typedef struct {
    CGPoint fromPoint;
    CGPoint toPoint;
    BOOL isRepeating;
    BOOL shouldReverse;
    NSTimeInterval timeinterval;
} TutorialAnimationOptions;

TutorialAnimationOptions TutorialAnimationOptionsMake(CGPoint fromPoint, CGPoint toPoint, BOOL isRepeating, BOOL shouldReverse, NSTimeInterval timeinterval) {
    TutorialAnimationOptions options;
    options.fromPoint = fromPoint;
    options.toPoint = toPoint;
    options.isRepeating = isRepeating;
    options.shouldReverse = shouldReverse;
    options.timeinterval = timeinterval;
    return options;
};

@interface TutorialHandler ()

@property(nonatomic, strong) UIView *tutorialView;
@property(nonatomic, assign) BOOL isTutorialShowing;

@end

@implementation TutorialHandler
+ (instancetype)sharedTutorialHandler {
    static TutorialHandler *tutorialHandler;
    if (!tutorialHandler) {
        tutorialHandler = [self new];
        [tutorialHandler loadTutorialView];
        [iStatusNotifier setDuration:30];
        [[[iStatusNotifier sharedInstance] lblMessage] setBackgroundColor:[UIColor colorWithRed:.4 green:.7 blue:1 alpha:1]];
    }
    return tutorialHandler;
}

+ (BOOL)isTutorialShowing {
    return [[self sharedTutorialHandler] isTutorialShowing];
}

+ (NSString *)keyForType:(TutorialDirectionType)type  {
    NSString *key;
    switch (type) {
        case kTap :
            key = @"kTap";
            break;
        case kToBottom :
            key = @"kToBottom";
            break;
        case kToTop :
            key = @"kToTop";
            break;
        case kToLeft :
            key = @"kToLeft";
            break;
        case kToRight :
            key = @"kToRight";
            break;
        case kToBottomAndToTop :
            key = @"kToBottomAndToTop";
            break;
        case kToRightAndToLeft :
            key = @"kToRightAndToLeft";
            break;
        default:
            break;
    }
    return key;
}

+ (BOOL)shouldShowTutorial:(TutorialDirectionType)type {
    return ![[NSUserDefaults standardUserDefaults] boolForKey:[self keyForType:type]];
}

+ (void)isTutorialShown:(BOOL)shown type:(TutorialDirectionType) type {
    [[NSUserDefaults standardUserDefaults] setBool:shown forKey:[self keyForType:type]];
}

+ (void)showTutorialForViewController:(ITTutorialViewController *)viewController {
    [self isTutorialShown:YES type:(TutorialDirectionType)viewController.tutorialDirectionType];
    NSString *message;
    TutorialHandler *tutorialHandler = [self.class sharedTutorialHandler];
    CGRect windowRect;

    for (UIWindow *aWindow in [UIApplication sharedApplication].windows) {
        if ([aWindow windowLevel] == UIWindowLevelNormal) {
            windowRect = aWindow.bounds;
        }
    }
    CGPoint fromPoint;
    CGPoint toPoint;
    BOOL isRepeating = YES;
    BOOL shouldReverse = NO;
    NSTimeInterval timeinterval;
    switch (viewController.tutorialDirectionType) {
        case kTap: {
            message = NSLocalizedString(@"Tap on indicatied area", nil);
            fromPoint = CGPointMake((windowRect.size.width - 50)/2 , 60);
            toPoint = CGPointMake((windowRect.size.width - 50)/2 , 60);
            timeinterval = .8;
        }
            break;
        case kToBottom : {
            message = NSLocalizedString(@"Swipe down", nil);
            fromPoint = CGPointMake((windowRect.size.width - 50)/2 , 60);
            toPoint = CGPointMake((windowRect.size.width - 50)/2 , windowRect.size.height);
            timeinterval = 1.5;
        }
            break;
        case kToTop : {
            message = NSLocalizedString(@"Swipe up", nil);
            fromPoint = CGPointMake((windowRect.size.width - 50)/2 , windowRect.size.height);
            toPoint = CGPointMake((windowRect.size.width - 50)/2 , 0);
            timeinterval = 1.5;
        }
            break;
        case kToLeft : {
            message = NSLocalizedString(@"Swipe Left", nil);
            fromPoint = CGPointMake((windowRect.size.width - 100) , windowRect.size.height/2);
            toPoint = CGPointMake(8 , windowRect.size.height/2);
            timeinterval = 1.f;
        }
            break;
        case kToRight : {
            message = NSLocalizedString(@"Swipe Right", nil);
            fromPoint = CGPointMake(8 , windowRect.size.height/2);
            toPoint = CGPointMake((windowRect.size.width - 100) , windowRect.size.height/2);
            timeinterval = 1.f;
        }
            break;
        case kToBottomAndToTop : {
            message = NSLocalizedString(@"Swipe Up or Down", nil);
            fromPoint = CGPointMake((windowRect.size.width - 50)/2 , 60);
            toPoint = CGPointMake((windowRect.size.width - 50)/2 , windowRect.size.height);
            timeinterval = 1.5;
            shouldReverse = YES;
        }
            break;
        case kToRightAndToLeft : {
            message = NSLocalizedString(@"Swipe Right or Left", nil);
            fromPoint = CGPointMake(8 , windowRect.size.height/2);
            toPoint = CGPointMake((windowRect.size.width - 100) , windowRect.size.height/2);
            timeinterval = 1.f;
            shouldReverse = YES;
        }
            break;
        default:
            break;
    }
    [tutorialHandler animateViewWithOptions:TutorialAnimationOptionsMake(fromPoint, toPoint, isRepeating, shouldReverse, timeinterval)];
    [tutorialHandler setIsTutorialShowing:YES];
    [viewController setTutorialDirectionType:0];
    [iStatusNotifier showStatusBarAlert:message completion:^{
        [self closeTutorialIfVisible];
    }];
}

+ (void)handleTouch {
    if ([[self sharedTutorialHandler] isTutorialShowing]) {
        [iStatusNotifier dismiss];
        [self closeTutorialIfVisible];
    }
}

+ (void)closeTutorialIfVisible {
    TutorialHandler *tutorialHandler = [self sharedTutorialHandler];
    if ([tutorialHandler isTutorialShowing]) {
        [tutorialHandler.tutorialView setAlpha:0.0];
        [tutorialHandler setIsTutorialShowing:NO];
    }
}

- (void)loadTutorialView {
    _tutorialView = [UIView new];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:_tutorialView];
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pointer"]];
    [imageview setFrame:_tutorialView.bounds];
    [_tutorialView addSubview:imageview];
    [imageview setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
}

- (void)animateViewWithOptions:(TutorialAnimationOptions)options{
    CGRect fromFrame = CGRectMake(options.fromPoint.x ,options.fromPoint.y, 100, 100);
    CGRect toFrame = CGRectMake(options.toPoint.x ,options.toPoint.y, 100, 100);
    
    [_tutorialView setFrame:fromFrame];
    [_tutorialView setAlpha:.9f];
    [UIView animateWithDuration:options.timeinterval delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        [_tutorialView setFrame:toFrame];
        [_tutorialView setAlpha:.3f];
    }                completion:^(BOOL finished) {
        if (options.isRepeating && [self isTutorialShowing]) {
            if (options.shouldReverse) {
                [self animateViewWithOptions:TutorialAnimationOptionsMake(options.toPoint, options.fromPoint, options.isRepeating, options.shouldReverse, options.timeinterval)];
            } else {
                [self animateViewWithOptions:options];
            }
        }
    }];
}

@end
