//
//  ELNContainerViewController.m
//  e-legion
//
//  Created by Dmitry Nesterenko on 16.11.15.
//  Copyright © 2015 e-legion. All rights reserved.
//

#import "ELNContainerViewController.h"

@implementation ELNContainerViewController

#pragma mark - Initialization

- (instancetype)initWithContentViewController:(UIViewController *)contentViewController {
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.contentViewController = contentViewController;
    }
    return self;
}

#pragma mark - Managing the Status Bar

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.contentViewController;
}

#pragma mark - Navigation Interface

/// Returns child view controllers navigation item if possible.
- (UINavigationItem *)navigationItem {
    UINavigationItem *navigationItem = self.contentViewController.navigationItem;
    return navigationItem ?: [super navigationItem];
}

#pragma mark - Managing the View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.contentViewController != nil) {
        [self insertContentViewController:self.contentViewController];
    }
}

#pragma mark - Content View Controller

- (void)setContentViewController:(UIViewController *)contentViewController {
    if (_contentViewController == contentViewController) {
        return;
    }
    
    // will set
    if (self.contentViewController != nil) {
        [self willRemoveContentViewController];
        
        // remove content view controller
        [self.contentViewController willMoveToParentViewController:nil];
        [self.contentViewController.view removeFromSuperview];
        [self.contentViewController removeFromParentViewController];

        self.title = nil;
    }
    
    _contentViewController = contentViewController;
    
    // did set
    if (self.contentViewController != nil) {
        [self willSetContentViewController];
        if (self.isViewLoaded) {
            [self insertContentViewController:self.contentViewController];
        }
        self.title = self.contentViewController.title;
    }
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)willRemoveContentViewController {
    // for subclasses
}

- (void)willSetContentViewController {
    // for subclasses
}

- (void)insertContentViewControllerSubview {
    UIViewController *viewController = self.contentViewController;
    viewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    viewController.view.frame = self.view.bounds;
    [self.view addSubview:viewController.view];
}

- (void)insertContentViewController:(UIViewController *)viewController {
    [self addChildViewController:viewController];

    if ([UIView instancesRespondToSelector:@selector(setLayoutMargins:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpartial-availability"
        viewController.view.layoutMargins = UIEdgeInsetsZero;
#pragma clang diagnostic pop
    }
    
    [self insertContentViewControllerSubview];
    [viewController didMoveToParentViewController:self];
    
    self.title = viewController.title;
}

@end
