//
//  ELNContainerViewController.h
//  e-legion
//
//  Created by Dmitry Nesterenko on 16.11.15.
//  Copyright © 2015 e-legion. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ELNContainerViewController : UIViewController

@property (nonatomic, strong, nullable) UIViewController *contentViewController;

- (instancetype)initWithContentViewController:(nullable UIViewController *)contentViewController;

/// Called before removing content view controller
- (void)willRemoveContentViewController;

/// Called before new view controller will be inserted
- (void)willSetContentViewController;

/// Subclasses must override to configure custom view hierarchy.
///
/// Default implementation is adding a content view to the container view.
- (void)insertContentViewControllerSubview;

@end

NS_ASSUME_NONNULL_END
