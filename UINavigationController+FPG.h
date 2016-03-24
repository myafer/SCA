//
//  UINavigationController+FPG.h
//  SCA
//
//  Created by 口贷网 on 16/3/24.
//  Copyright © 2016年 Afer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (FPG)

@end

@interface UIViewController (FPG)

@property (nonatomic, assign) CGFloat fd_interactivePopMaxAllowedInitialDistanceToLeftEdge;
@property (nonatomic, copy) NSString *bb;
@end