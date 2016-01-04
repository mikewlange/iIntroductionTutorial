//
//  TutorialHandler.h
//  Fessup
//
//  Created by Rajesh on 1/4/16.
//  Copyright © 2016 Org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    kTap = 1,
    kToBottom,
    kToTop,
    kToLeft,
    kToRight,
    kToRightAndToLeft,
    kToBottomAndToTop
}TutorialDirectionType;

@interface ITTutorialViewController : UIViewController

@property(nonatomic) TutorialDirectionType tutorialDirectionType;

@end

@interface TutorialHandler : NSObject

+ (BOOL)shouldShowTutorial:(TutorialDirectionType)type;
+ (void)isTutorialShown:(BOOL)shown type:(TutorialDirectionType) type;
+ (BOOL)isTutorialShowing;
+ (void)showTutorialForViewController:(ITTutorialViewController *)viewController;
+ (void)handleTouch;

@end
