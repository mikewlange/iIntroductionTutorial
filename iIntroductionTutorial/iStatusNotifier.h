//
//  iStatusNotifier.h
//  iStatusNotifier
//
//  Created by Rajesh on 3/25/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface iStatusNotifier : NSObject

+ (instancetype)sharedInstance;
+ (void)showStatusBarAlert:(NSString *)stMessage;
+ (void)showStatusBarAlert:(NSString *)stMessage completion:(void (^)(void))completion;
+ (void)dismiss;
+ (void)setDuration:(NSTimeInterval)duration;

@property(nonatomic,strong) UILabel *lblMessage;
@property(nonatomic,assign) NSTimeInterval iDuration;

@end
