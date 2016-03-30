//
//  ELNScrollViewController.h
//  e-legion
//
//  Created by Dmitry Nesterenko on 12.10.15.
//  Copyright © 2015 e-legion. All rights reserved.
//

#import "ELNContainerViewController.h"

/// View controller that manages content inside a scroll view.
@interface ELNScrollViewController : ELNContainerViewController

@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) UIView *scrollContentView;

@end

@interface UIViewController (ELNScrollViewController)

@property (nonatomic, weak, readonly) ELNScrollViewController *eln_scrollViewController;

@end
