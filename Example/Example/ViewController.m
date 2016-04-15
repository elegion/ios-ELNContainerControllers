//
//  ViewController.m
//  Example
//
//  Created by Dmitry Nesterenko on 25.03.16.
//  Copyright © 2016 e-legion. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)buttonTapped:(id)sender {
    [self.navigationController pushViewController:[UIViewController new] animated:YES];
}

@end
