//
//  MainViewController.m
//  CallCenter
//
//  Created by aiquantong on 22/6/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "CCMainViewController.h"
#import "SearchUserViewController.h"


@interface CCMainViewController ()

@end

@implementation CCMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)onclickGotoChat:(id)sender
{
    SearchUserViewController *suvc = [[SearchUserViewController alloc] initWithNibName:@"SearchUserViewController" bundle:nil];
    [self.navigationController pushViewController:suvc animated:YES];
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
