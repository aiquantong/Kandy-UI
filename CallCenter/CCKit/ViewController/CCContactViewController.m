//
//  CCContactViewController.m
//  CallCenter
//
//  Created by aiquantong on 7/28/16.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "CCContactViewController.h"
#import "../../KandySDK/AddressBookModule.h"
#import "../Model/CCContactModel.h"

@interface CCContactViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
    UITableView *mtableView;
    NSMutableArray *mtableArr;
}

@end

@implementation CCContactViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    #ifdef __IPHONE_7_0
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = YES;
    #endif

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendLocationAction:)];
    
    UISearchBar *sb = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    [self.view addSubview:sb];
    sb.delegate = self;
    
    mtableArr = [[NSMutableArray alloc] initWithCapacity:10];
    mtableView = [[UITableView alloc] initWithFrame:CGRectMake(0,sb.frame.size.height,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height - sb.frame.size.height) style:UITableViewStylePlain];
    [self.view addSubview:mtableView];
    mtableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    mtableView.delegate = self;
    mtableView.dataSource = self;
    
    [AddressBookModule getDeviceContact:^(NSError *error, NSArray *arr) {
        if (error) {
            NSLog(@"error == %@", [error description]);
        }else{
            [mtableArr removeAllObjects];
            for (id <KandyContactProtocol> contact in arr) {
                CCContactModel *cccm = [[CCContactModel alloc] init];
                cccm.isSelect = NO;
                cccm.contact = contact;
                [mtableArr addObject:cccm];
            }
            [mtableView reloadData];
        }
    }];
}

-(void)sendLocationAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseContact:)]) {
        CCContactModel *selectModel = nil;
        for (CCContactModel *ccm in mtableArr) {
            if (ccm.isSelect) {
                selectModel = ccm;
                break;
            }
        }
        if (selectModel) {
            [self.delegate chooseContact:selectModel.contact];
        }

    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark searchbar
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    KDALog(@"searchBar");
    [AddressBookModule getDeviceContactsWithFilter:0 textSearch:searchText callback:^(NSError *error, NSArray *arr) {
        if (error) {
            NSLog(@"error == %@", [error description]);
        }else{
            [mtableArr removeAllObjects];
            for (id <KandyContactProtocol> contact in arr) {
                CCContactModel *cccm = [[CCContactModel alloc] init];
                cccm.isSelect = NO;
                cccm.contact = contact;
                [mtableArr addObject:cccm];
            }
            [mtableView reloadData];
        }
    }];
}


#pragma mark tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [mtableArr count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"locationAddressCell"];
    CCContactModel *cccm = [mtableArr objectAtIndex:indexPath.row];
    
    cell.textLabel.text = cccm.contact.displayName;
    cell.accessoryType = cccm.isSelect?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCContactModel *cccm = [mtableArr objectAtIndex:indexPath.row];
    if (!cccm.isSelect) {
        for (int i = 0; i < [mtableArr count]; i++) {
            CCContactModel *tcccm = [mtableArr objectAtIndex:i];
            if (tcccm.isSelect) {
                tcccm.isSelect = NO;
                NSIndexPath *tIndexpath = [NSIndexPath indexPathForRow:i inSection:0];
                [tableView deselectRowAtIndexPath:tIndexpath animated:YES];
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:tIndexpath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }
    cccm.isSelect = !cccm.isSelect;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
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
