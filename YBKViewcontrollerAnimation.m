//
//  YBKViewcontrollerAnimation.m
//  medicineCommonPeople
//
//  Created by  liyang on 15/7/11.
//  Copyright (c) 2015年 liyang. All rights reserved.
//

#import "YBKViewcontrollerAnimation.h"

@implementation YBKViewcontrollerAnimation
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{

    return 0.3;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    // 可以看做为destination ViewController
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    // 可以看做为source ViewController
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    // 添加toView到容器上
    [[transitionContext containerView] addSubview:toViewController.view];
    toViewController.view.transform=CGAffineTransformMakeTranslation(320, 0);
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        // 动画效果有很多,这里就展示个左偏移
        
        fromViewController.view.transform = CGAffineTransformScale(fromViewController.view.transform, 0.95, 0.95);
        toViewController.view.transform = CGAffineTransformMakeTranslation(0, 0);;
    } completion:^(BOOL finished) {
        fromViewController.view.transform = CGAffineTransformIdentity;
        // 声明过渡结束-->记住，一定别忘了在过渡结束时调用 completeTransition: 这个方法
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];

}
@end
