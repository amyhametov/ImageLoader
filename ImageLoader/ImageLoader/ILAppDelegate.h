//
//  ILAppDelegate.h
//  ImageLoader
//
//  Created by Andrey Mukhametov on 14.05.13.
//  Copyright (c) 2013 Andrey Mukhametov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ILMainNavigationController,ILImageListController;

@interface ILAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ILMainNavigationController *viewController;

@end
