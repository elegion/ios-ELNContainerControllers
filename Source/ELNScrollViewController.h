//
//  ELNScrollViewController.h
//  e-legion
//
//  Created by Dmitry Nesterenko on 12.10.15.
//  Copyright © 2015 e-legion. All rights reserved.
//

#import "ELNContainerViewController.h"

@class ELNScrollViewController;

@protocol ELNScrollableViewController <NSObject>

@property (nonatomic, weak) ELNScrollViewController *scrollViewController;

@end

/// View controller that manages content inside a scroll view.
@interface ELNScrollViewController : ELNContainerViewController

@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) UIView *scrollContentView;

@end
