//
//  UINavigationController+FPG.m
//  SCA
//
//  Created by 口贷网 on 16/3/24.
//  Copyright © 2016年 Afer. All rights reserved.
//

#import "UINavigationController+FPG.h"
#import <objc/runtime.h>
#import "YBKViewcontrollerAnimation.h"

@interface _BDelegate : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UINavigationController *nav;

@end

@implementation _BDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    if (self.nav.viewControllers.count <= 1) {
        return NO;
    }
    UIViewController *topVC = self.nav.viewControllers.lastObject;
    CGPoint beginningLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (beginningLocation.x > topVC.fd_interactivePopMaxAllowedInitialDistanceToLeftEdge && topVC.fd_interactivePopMaxAllowedInitialDistanceToLeftEdge > 0) {
        return NO;
    }
    
    if ([[self.nav valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }

    
    return YES;
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        YBKViewcontrollerAnimation *animation1=  [[YBKViewcontrollerAnimation alloc]init];
        return animation1;
    }
    return nil;
}


@end




@implementation UINavigationController (FPG)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class           = [self class];
        SEL originalSelector  = @selector(pushViewController:animated:);
        SEL swizzledSelector  = @selector(bPushViewController:animated:);
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL pro = class_conformsToProtocol(class, @protocol(UIViewControllerAnimatedTransitioning));
        if (!pro) {
            class_addProtocol(class, @protocol(UIViewControllerAnimatedTransitioning));
        }
        BOOL success          = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (UIPanGestureRecognizer *)bges {
    UIPanGestureRecognizer *pan = objc_getAssociatedObject(self, _cmd);
    if (!pan) {
        pan = [[UIPanGestureRecognizer alloc] init];
        pan.maximumNumberOfTouches = 1;
        objc_setAssociatedObject(self, _cmd, pan, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    NSLog(@"%@", pan);
    return pan;
}


- (void)bPushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self bPushViewController:viewController animated:animated];
    if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.bges]) {
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.bges];
        NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
        id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
        self.bges.delegate = self.bDelegate;
        
        int i = 0;
        
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wno-Wprotocol"
        viewController.navigationController.delegate = self;
#pragma clang diagnostic pop
        
        [self.bges addTarget:internalTarget action:internalAction];
        
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
}

- (_BDelegate *)bDelegate {
    _BDelegate *dele = objc_getAssociatedObject(self, _cmd);
    if (!dele) {
        dele = [[_BDelegate alloc] init];
        dele.nav = self;
        objc_setAssociatedObject(self, _cmd, dele, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return dele;
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    
    if (operation == UINavigationControllerOperationPush) {
        YBKViewcontrollerAnimation *animation1=  [[YBKViewcontrollerAnimation alloc]init];
        return animation1;
    }
    return nil;
}

@end

@implementation UIViewController (FPG)

- (CGFloat)fd_interactivePopMaxAllowedInitialDistanceToLeftEdge {
    
#if CGFLOAT_IS_DOUBLE
    double d = [objc_getAssociatedObject(self, _cmd) doubleValue];
    return d;
#else
    return [objc_getAssociatedObject(self, _cmd) floatValue];
#endif
}


- (void)setFd_interactivePopMaxAllowedInitialDistanceToLeftEdge:(CGFloat)distance {
    
    SEL key = @selector(fd_interactivePopMaxAllowedInitialDistanceToLeftEdge);
    objc_setAssociatedObject(self, key, @(distance), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)bb {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setBb:(NSString *)str {
    SEL key = @selector(bb);
    objc_setAssociatedObject(self, key, str, OBJC_ASSOCIATION_COPY_NONATOMIC);
}



@end