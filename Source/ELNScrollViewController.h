//
//  ELNScrollViewController.h
//  e-legion
//
//  Created by Dmitry Nesterenko on 12.10.15.
//  Copyright © 2015 e-legion. All rights reserved.
//

#import "ELNContainerViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// View controller that manages content inside a scroll view.
@interface ELNScrollViewController : ELNContainerViewController

@property (nonatomic, strong, readonly, nullable) UIScrollView *scrollView;
@property (nonatomic, strong, readonly, nullable) UIView *scrollContentView;

@end

@interface UIViewController (ELNScrollViewController)

@property (nonatomic, weak, readonly, nullable) ELNScrollViewController *eln_scrollViewController;

@end

NS_ASSUME_NONNULL_END
