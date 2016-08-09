//
//  SearchUserViewController.m
//  CallCenter
//
//  Created by aiquantong on 8/8/16.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "SearchUserViewController.h"
#import "AddressBookModule.h"
#import "../CallCenter/3rdParty/Toast/UIView+Toast.h"
#import "UserSearchModel.h"
#import "CCChatViewController.h"


@interface SearchUserViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
    NSMutableArray *mtableArr;
}

@property (nonatomic,strong) IBOutlet UITableView *mtableview;

@end


@implementation SearchUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
#ifdef __IPHONE_7_0
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = YES;
#endif
    
    mtableArr = [[NSMutableArray alloc] initWithCapacity:10];
    self.mtableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.title = @"选择聊天对象";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"聊天" style:UIBarButtonItemStylePlain target:self action:@selector(chatAction:)];
}


-(void)chatAction:(id)sender
{
    NSString *attendId = nil;
    for (UserSearchModel *contact in mtableArr) {
        if (contact.isSelect) {
            attendId = contact.uri;
            break;
        }
    }
    
    if (attendId != nil) {
        CCChatViewController *cv = [[CCChatViewController alloc] init];
        cv.attendId = attendId;
        [self.navigationController pushViewController:cv animated:YES];
    }else{
        [self.view makeToast:@"请选择朋友聊天"];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    if ([searchText length] > 0) {
        
        [AddressBookModule getDomainContactsWithFilter:0 textSearch:searchText callback:^(NSError *error, NSArray *arr) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    [self.view makeToast:[error description]];
                }else{
                    [mtableArr removeAllObjects];
                    
                    for (id <KandyContactProtocol> contact in arr) {
                        UserSearchModel *cccm = [[UserSearchModel alloc] init];
                        cccm.isSelect = NO;
                        cccm.uri = contact.serverIdentifier.uri;
                        cccm.userName = contact.displayName;
                        [mtableArr addObject:cccm];
                    }                    
                    [self.mtableview reloadData];
                }
            });
        }];
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mtableArr count];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tc = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"searchUserCellId"];
    UserSearchModel *us = [mtableArr objectAtIndex:[indexPath row]];
    tc.textLabel.text = us.userName;
    tc.detailTextLabel.text = us.uri;
    tc.accessoryType = us.isSelect ? UITableViewCellAccessoryCheckmark: UITableViewCellAccessoryNone;
    
    return tc;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserSearchModel *cccm = [mtableArr objectAtIndex:[indexPath row]];
    if (!cccm.isSelect) {
        for (int i = 0; i < [mtableArr count]; i++) {
            UserSearchModel *tcccm = [mtableArr objectAtIndex:i];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end



