//
//  ELNScrollViewController.m
//  e-legion
//
//  Created by Dmitry Nesterenko on 12.10.15.
//  Copyright © 2015 e-legion. All rights reserved.
//

#import "ELNScrollViewController.h"

static UIViewAnimationOptions ELNAnimationOptionsFromAnimationCurve(NSUInteger curve) {
    NSCAssert(UIViewAnimationCurveLinear << 16 == UIViewAnimationOptionCurveLinear, @"Unexpected implementation of UIViewAnimationCurve");
    return curve << 16;
}

@interface ELNScrollViewControllerScrollView : UIScrollView @end

@implementation ELNScrollViewControllerScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.delaysContentTouches = NO;
    }
    return self;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if ([view isKindOfClass:[UIControl class]]) {
        return YES;
    } else {
        return [super touchesShouldCancelInContentView:view];
    }
}

@end


@interface ELNScrollViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *scrollContentView;
@property (nonatomic, strong) NSLayoutConstraint *contentHeight;
@property (nonatomic, assign) CGFloat topLayoutGuideLength;
@property (nonatomic, assign) CGFloat bottomLayoutGuideLength;
@property (nonatomic, assign) CGFloat keyboardBottomInset;
@property (nonatomic, assign) BOOL keyboardNotificationsObservationEnabled;

@end

@implementation ELNScrollViewController

#pragma mark - Managing the View

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    self.scrollView = [[ELNScrollViewControllerScrollView alloc] initWithFrame:view.bounds];
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    if ([UIView instancesRespondToSelector:@selector(setLayoutMargins:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpartial-availability"
        self.scrollView.layoutMargins = UIEdgeInsetsZero;
#pragma clang diagnostic pop
    }
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [view addSubview:self.scrollView];

    self.scrollContentView = [[UIView alloc] initWithFrame:view.bounds];
    self.scrollContentView.translatesAutoresizingMaskIntoConstraints = NO;
    if ([UIView instancesRespondToSelector:@selector(setLayoutMargins:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpartial-availability"
        self.scrollContentView.layoutMargins = UIEdgeInsetsZero;
#pragma clang diagnostic pop
    }
    [self.scrollView addSubview:self.scrollContentView];
    
    // content view's edges are pinned to the superview's edges
    // content view's width must be equal to the superview's width
    // content view's height must be equal to the superview's height with a low priority
    NSDictionary *bindings = @{@"view": view, @"scrollView": self.scrollView, @"scrollContentView": self.scrollContentView};
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[scrollContentView(==scrollView)]-(0)-|" options:0 metrics:nil views:bindings]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[scrollContentView]-(0)-|" options:0 metrics:nil views:bindings]];
    self.contentHeight = [NSLayoutConstraint constraintWithItem:self.scrollContentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    self.contentHeight.priority = UILayoutPriorityDefaultLow;
    [view addConstraint:self.contentHeight];
}

#pragma mark - Responding to View Events

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.scrollView flashScrollIndicators];
    
    self.keyboardNotificationsObservationEnabled = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.keyboardNotificationsObservationEnabled = NO;
}

#pragma mark - Content Insets

- (void)setKeyboardBottomInset:(CGFloat)keyboardBottomInset {
    if (_keyboardBottomInset == keyboardBottomInset) {
        return;
    }
    _keyboardBottomInset = keyboardBottomInset;
    
    [self updateScrollViewContentInset];
}

- (void)setTopLayoutGuideLength:(CGFloat)topLayoutGuideLength {
    if (_topLayoutGuideLength == topLayoutGuideLength) {
        return;
    }
    _topLayoutGuideLength = topLayoutGuideLength;
    
    [self updateScrollViewContentInset];
}

- (void)setBottomLayoutGuideLength:(CGFloat)bottomLayoutGuideLength {
    if (_bottomLayoutGuideLength == bottomLayoutGuideLength) {
        return;
    }
    _bottomLayoutGuideLength = bottomLayoutGuideLength;
    
    [self updateScrollViewContentInset];
}

- (void)updateScrollViewContentInset {
    CGFloat topInset = self.topLayoutGuideLength;
    CGFloat bottomInset = MAX(self.bottomLayoutGuideLength, self.keyboardBottomInset);

    // content inset
    UIEdgeInsets contentInset = self.scrollView.contentInset;
    if (contentInset.bottom != bottomInset) {
        contentInset.bottom = bottomInset;
    }
    if (contentInset.top != topInset) {
        contentInset.top = topInset;
    }
    if (!UIEdgeInsetsEqualToEdgeInsets(self.scrollView.contentInset, contentInset)) {
        self.scrollView.contentInset = contentInset;
    }
    
    // scroll indicator inset
    UIEdgeInsets scrollIndicatorInsets = self.scrollView.scrollIndicatorInsets;
    if (scrollIndicatorInsets.bottom != bottomInset) {
        scrollIndicatorInsets.bottom = bottomInset;
    }
    if (scrollIndicatorInsets.top != topInset) {
        scrollIndicatorInsets.top = topInset;
    }
    if (!UIEdgeInsetsEqualToEdgeInsets(self.scrollView.scrollIndicatorInsets, scrollIndicatorInsets)) {
        self.scrollView.scrollIndicatorInsets = scrollIndicatorInsets;
    }
    
    // height constraint
    CGFloat contentHeightInset = topInset + bottomInset;
    if (self.contentHeight.constant != -contentHeightInset) {
        self.contentHeight.constant = -contentHeightInset;
    }
}

#pragma mark - Configuring the View's Layout Behavior

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.automaticallyAdjustsScrollViewInsets) {
        self.topLayoutGuideLength = [self.topLayoutGuide length];
        self.bottomLayoutGuideLength = [self.bottomLayoutGuide length];
    }
}

#pragma mark - Container View Controller

- (void)willRemoveContentViewController {
    if ([self.contentViewController conformsToProtocol:@protocol(ELNScrollableViewController)]) {
        [(id<ELNScrollableViewController>)self.contentViewController setScrollViewController:nil];
    }
    self.contentHeight = nil;
}

- (void)willSetContentViewController {
    if ([self.contentViewController conformsToProtocol:@protocol(ELNScrollableViewController)]) {
        [(id<ELNScrollableViewController>)self.contentViewController setScrollViewController:self];
    }
}

- (void)insertContentViewControllerSubview {
    UIViewController *viewController = self.contentViewController;
    viewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollContentView addSubview:viewController.view];

    NSDictionary *bindings = @{@"view": viewController.view};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[view]-(0)-|" options:0 metrics:nil views:bindings]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[view]-(0)-|" options:0 metrics:nil views:bindings]];
}

#pragma mark - Keyboard

- (void)setKeyboardNotificationsObservationEnabled:(BOOL)keyboardNotificationsObservationEnabled {
    if (_keyboardNotificationsObservationEnabled == keyboardNotificationsObservationEnabled) {
        return;
    }
    _keyboardNotificationsObservationEnabled = keyboardNotificationsObservationEnabled;
    
    if (self.keyboardNotificationsObservationEnabled) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)keyboardWillShowNotification:(NSNotification *)notification {
    [self animateWithNotification:notification];
}

- (void)keyboardWillHideNotification:(NSNotification *)notification {
    [self animateWithNotification:notification];
}

- (void)animateWithNotification:(NSNotification *)notification {
    CGRect frameBegin = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect frameEnd = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSUInteger curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    
    UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState | ELNAnimationOptionsFromAnimationCurve(curve);
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        [self animateKeyboardFromFrame:frameBegin toFrame:frameEnd];
    } completion:nil];
}

- (void)animateKeyboardFromFrame:(CGRect)frameBegin toFrame:(CGRect)frameEnd {
    CGRect frameInView = [self.view convertRect:frameEnd fromView:nil];
    self.keyboardBottomInset = MAX(self.scrollView.bounds.size.height - frameInView.origin.y, 0);
    [self.view layoutIfNeeded];
}

@end
