//
//  TutorialHandler.m
//  Fessup
//
//  Created by Rajesh on 4/1/16.
//  Copyright © 2016 Org. All rights reserved.
//

#import "iTutorialHandler.h"

typedef struct {
    CGRect fromFrame;
    CGRect toFrame;
    BOOL isRepeating;
    BOOL shouldReverse;
    NSTimeInterval timeinterval;
} TutorialAnimationOptions;

TutorialAnimationOptions TutorialAnimationOptionsMake(CGRect fromFrame, CGRect toFrame, BOOL isRepeating, BOOL shouldReverse, NSTimeInterval timeinterval) {
    TutorialAnimationOptions options;
    options.fromFrame = fromFrame;
    options.toFrame = toFrame;
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
    }
    return tutorialHandler;
}

+ (BOOL)isTutorialShowing {
    return [[self sharedTutorialHandler] isTutorialShowing];
}

+ (NSString *)keyForType:(TutorialDirectionType)type  {
    NSString *key;
    switch (type) {
        case kTopDrawer :
            key = @"kTopDrawer";
            break;
        case kMainCanvas :
            key = @"kMainCanvas";
            break;
        case kPostCellDeck :
            key = @"kPostCellDeck";
            break;
        case kExpandedViewCanvas :
            key = @"kExpandedViewCanvas";
            break;
        case kPullDownToDismiss :
            key = @"kPullDownToDismiss";
            break;
        default:
            key = @"";
            break;
    }
    return key;
}

+ (BOOL)shouldShowTutorial:(TutorialDirectionType)type {
    return ![[NSUserDefaults standardUserDefaults] boolForKey:[self keyForType:type]];
}

+ (void)showTutorialForViewController:(ViewController *)viewController {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[self keyForType:(TutorialDirectionType)viewController.TutorialDirectionType]];
    NSString *message;
    TutorialHandler *tutorialHandler = [self.class sharedTutorialHandler];
    [tutorialHandler setIsTutorialShowing:YES];
    CGRect windowRect = [[UIApplication sharedApplication] keyWindow].bounds;
    switch (viewController.TutorialDirectionType) {
        case kTopDrawer : {
            message = NSLocalizedString(@"swipe_down_to_top_drawer", nil);
            CGRect fromRect = CGRectMake((windowRect.size.width - 50)/2 , 60, 100, 100);
            CGRect toRect = CGRectMake((windowRect.size.width - 50)/2 , windowRect.size.height, 100, 100);
            [tutorialHandler animateViewWithOptions:TutorialAnimationOptionsMake(fromRect, toRect, YES, NO, 1.5)];
        }
            break;
        case kMainCanvas : {
            message = NSLocalizedString(@"swipe_left_or_right_communities", nil);
            CGRect fromRect = CGRectMake(8, (windowRect.size.height / 3)/2 + 55, 100, 100);
            CGRect toRect = CGRectMake((windowRect.size.width - 100) , (windowRect.size.height / 3)/2 + 55, 100, 100);
            [tutorialHandler animateViewWithOptions:TutorialAnimationOptionsMake(fromRect, toRect, YES, YES, 1)];
        }
            break;
        case kPostCellDeck : {
            message = NSLocalizedString(@"swipe_left_post_cell", nil);
            CGRect fromRect = CGRectMake((windowRect.size.width - 100) , windowRect.size.height/2 + 55, 100, 100);
            CGRect toRect = CGRectMake(8, windowRect.size.height/2 + 55, 100, 100);
            [tutorialHandler animateViewWithOptions:TutorialAnimationOptionsMake(fromRect, toRect, YES, NO, 1)];
        }
            break;
        case kExpandedViewCanvas :
            message = NSLocalizedString(@"swipe_left_or_right_posts", nil);
            CGRect fromRect = CGRectMake(8, windowRect.size.height/2, 100, 100);
            CGRect toRect = CGRectMake((windowRect.size.width - 100) , windowRect.size.height/2, 100, 100);
            [tutorialHandler animateViewWithOptions:TutorialAnimationOptionsMake(fromRect, toRect, YES, YES, 1)];
            break;
        case kPullDownToDismiss : {
            message = NSLocalizedString(@"swipe_down_this_card", nil);
            CGRect fromRect = CGRectMake((windowRect.size.width - 50)/2 , 60, 100, 100);
            CGRect toRect = CGRectMake((windowRect.size.width - 50)/2 , windowRect.size.height, 100, 100);
            [tutorialHandler animateViewWithOptions:TutorialAnimationOptionsMake(fromRect, toRect, YES, NO, 1.5)];
        }
            break;
        default:
            break;
    }
    [viewController setTutorialDirectionType:0];
    [Toast showTutorialMessage:message afterExecution:NO completionBlock:^{
        [self closeTutorialIfVisible];
    }];
}

+ (void)handleTouch {
    [Toast dismiss];
    [self closeTutorialIfVisible];
}

+ (void)closeTutorialIfVisible {
    TutorialHandler *tutorialHandler = [self.class sharedTutorialHandler];
    if ([tutorialHandler isTutorialShowing]) {
        [tutorialHandler.tutorialView setAlpha:0.0];
        [tutorialHandler setIsTutorialShowing:NO];
    }
}

- (void)loadTutorialView {
    _tutorialView = [UIView new];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:_tutorialView];
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_pointer"]];
    [imageview setFrame:_tutorialView.bounds];
    [_tutorialView addSubview:imageview];
    [imageview setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
}

- (void)animateViewWithOptions:(TutorialAnimationOptions)options{
    [_tutorialView setFrame:options.fromFrame];
    [_tutorialView setAlpha:.9f];
    [UIView animateWithDuration:options.timeinterval delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        [_tutorialView setFrame:options.toFrame];
        [_tutorialView setAlpha:.1f];
    }                completion:^(BOOL finished) {
        if (options.isRepeating && [self isTutorialShowing]) {
            if (options.shouldReverse) {
                [self animateViewWithOptions:TutorialAnimationOptionsMake(options.toFrame, options.fromFrame, options.isRepeating, options.shouldReverse, options.timeinterval)];
            } else {
                [self animateViewWithOptions:options];
            }
        }
    }];
}

@end
