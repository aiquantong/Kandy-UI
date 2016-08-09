//
//  BasicViewController.m
//  CallCenter
//
//  Created by aiquantong on 7/29/16.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "CCBasicViewController.h"

@interface CCBasicViewController ()<UIGestureRecognizerDelegate>

@end

@implementation CCBasicViewController

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       // [self initNavBack];
    }
    return self;
}


-(void)initNavBack
{
    UINavigationBar * navigationBar = [UINavigationBar appearance];
    //返回按钮的箭头颜色
    [navigationBar setTintColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.000]];
    
    //设置返回样式图片
    UIImage *image = [UIImage imageNamed:@"nav_back"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navigationBar.backIndicatorImage = image;
    navigationBar.backIndicatorTransitionMaskImage = image;
    
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"  ";
    backItem.image = nil;
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationController.navigationItem.backBarButtonItem = backItem;
    self.tabBarController.navigationItem.backBarButtonItem = backItem;
    self.navigationController.tabBarController.navigationItem.backBarButtonItem = backItem;
    self.navigationController.tabBarController.navigationController.navigationItem.backBarButtonItem = backItem;
    
    UIBarButtonItem *buttonItem = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    
    UIOffset offset;
    offset.horizontal = - 500;
    offset.vertical =  - 500;
    [buttonItem setBackButtonTitlePositionAdjustment:offset forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavItem];
    
    [self initGesture];
    
    // Do any additional setup after loading the view.
}

-(void) initNavItem{
    
//#ifdef __IPHONE_7_0
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.extendedLayoutIncludesOpaqueBars = NO;
//    self.automaticallyAdjustsScrollViewInsets = YES;
//#endif

    //[self.navigationController.navigationBar setBarTintColor:Block];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor blackColor], NSForegroundColorAttributeName,
                                                                     nil]
     ];
}


-(void) initGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;
    
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    NSLog(@"[NSStringFromClass([touch.view class]  =%@", NSStringFromClass([touch.view class]));
    
    if ([touch.view isKindOfClass:[UITextField class]]){
        return NO;
    }
    
    if (![touch.view isKindOfClass:[UIButton class]]){
        [self.view endEditing:YES];
    }
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    
    if ([touch.view isKindOfClass:[UIView class]]){
        return NO;
    }
    
    return YES;
}

-(IBAction)nav_back:(id)sender
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setLeftNavItem:(UIImage *)image selector:(SEL) selector{
    
    UIBarButtonItem *lfI = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:selector];
    
    self.navigationItem.leftBarButtonItem = lfI;
}

-(void)setRightNavItem:(UIImage *)image selector:(SEL) selector{
    
    UIBarButtonItem *lfI = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:selector];
    
    self.navigationItem.rightBarButtonItem = lfI;
}


-(void)setLeftNavTitle:(NSString *)leftStr selector:(SEL) selector{
    
    UIBarButtonItem *lfI = [[UIBarButtonItem alloc] initWithTitle:leftStr style:UIBarButtonItemStyleDone target:self action:selector];
    lfI.tintColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = lfI;
}


-(void)setRightNavTitle:(NSString *)rightStr selector:(SEL) selector{
    
    UIBarButtonItem *lfI = [[UIBarButtonItem alloc] initWithTitle:rightStr style:UIBarButtonItemStyleDone target:self action:selector];
    lfI.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = lfI;
}

- (void) setLastCellSeperatorToLeft:(UITableViewCell*) cell edgeInserts:(UIEdgeInsets)edgeInserts
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:edgeInserts];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:edgeInserts];
    }
    
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
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

