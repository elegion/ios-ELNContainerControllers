//
//  ViewController.h
//  Example
//
//  Created by Dmitry Nesterenko on 25.03.16.
//  Copyright © 2016 e-legion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../../Source/ELNScrollViewController.h"

@interface ViewController : UIViewController <ELNScrollableViewController>

@property (nonatomic, weak) ELNScrollViewController *scrollViewController;

@end

