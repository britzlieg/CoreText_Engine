//
//  demo_2_ViewController.m
//  CoreText_Test
//
//  Created by ZhijieLi on 15/2/17.
//  Copyright (c) 2015年 ZhijieLi. All rights reserved.
//

#import "demo_2_ViewController.h"
#import "CTViewB.h"

@interface demo_2_ViewController ()
@property (weak,nonatomic) IBOutlet CTViewB *ctvb;
@end

@implementation demo_2_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.ctvb) {
        NSLog(@"not nil");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
