//
//  OCViewController.m
//  OCModule
//
//  Created by jintao on 2019/11/4.
//  Copyright © 2019 jintao. All rights reserved.
//

#import "OCViewController.h"

@interface OCViewController ()

@end

@implementation OCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"OC Controller 🚀🚀🚀";
    self.view.backgroundColor = [UIColor greenColor];
    // Do any additional setup after loading the view.
}

@end

// extern C and __attribute__((visibility("default")))
OBJC_EXPORT NSDictionary* OCControllerInterface(NSDictionary* params) {
    UINavigationController *naviController = params[@"navi"];
    OCViewController *oc_controller = [[OCViewController alloc] init];
    [naviController pushViewController:oc_controller animated:true];
    return nil;
}
