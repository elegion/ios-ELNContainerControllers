//
//  AppDelegate.m
//  Example
//
//  Created by Dmitry Nesterenko on 25.03.16.
//  Copyright © 2016 e-legion. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <ELNContainerControllers/ELNContainerControllers.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ViewController *viewController = [ViewController new];
    ELNScrollViewController *scrollViewController = [[ELNScrollViewController alloc] initWithContentViewController:viewController];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:scrollViewController];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];

    return YES;
}

@end
