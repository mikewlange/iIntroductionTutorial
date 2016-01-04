//
//  TutorialHandler.h
//  Fessup
//
//  Created by Rajesh on 4/1/16.
//  Copyright © 2016 Org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"

typedef enum {
    kToBottom,
    kToTop,
    kToLeft,
    kToRight,
    kToRightAndToLeft,
    kToBottomAndToTop
}TutorialDirectionType;

@interface TutorialHandler : NSObject

+ (BOOL)shouldShowTutorial:(TutorialDirectionType)type;
+ (BOOL)isTutorialShowing;
+ (void)showTutorialForViewController:(ViewController *)viewController;
+ (void)handleTouch;

@end
