//
//  ViewController.m
//  MZActionSheetDemo
//
//  Created by 麦子 on 16/7/27.
//  Copyright © 2016年 麦子. All rights reserved.
//

#import "DemoViewController.h"
#import "MZActionSheet.h"

@interface DemoViewController ()

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViewController];
    [self createUI];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)initViewController {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)createUI {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"视图弹出" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 100, 40);
    button.center = self.view.center;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonClick:(UIButton *)sender {
    MZActionSheet *sheet = [[MZActionSheet alloc] initWithTitle:@"这是标题" clickedAtIndex:^(NSInteger index) {
        switch (index) {
            case 0:
            {
                NSLog(@"第一个按钮点击");
            }
                break;
            case 1:
            {
                NSLog(@"第二个按钮点击");
            }
                break;
            case 2:
            {
                NSLog(@"取消按钮点击");
            }
                break;
            default:
                break;
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"按钮1", @"按钮2", nil];
    sheet.titleFont = [UIFont systemFontOfSize:18];
    sheet.titleColor = [UIColor blackColor];
    [sheet show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
