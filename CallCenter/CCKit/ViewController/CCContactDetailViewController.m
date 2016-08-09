//
//  CCContactDetailViewController.m
//  CallCenter
//
//  Created by aiquantong on 8/2/16.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "CCContactDetailViewController.h"

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface CCContactDetailViewController () <ABNewPersonViewControllerDelegate>
@property (nonatomic, strong) ABNewPersonViewController * vcAddrUi;
@end

@implementation CCContactDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Contact Attachment";
    UIBarButtonItem * btnClose = [[UIBarButtonItem alloc]
                                  initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(didTapClose:)];
    self.navigationItem.leftBarButtonItem = btnClose;
    NSString *vCardString = [NSString stringWithContentsOfFile:self.vcfFilePath encoding:NSUTF8StringEncoding error:nil ];
    
    CFDataRef vCardData = (__bridge CFDataRef)[vCardString dataUsingEncoding:NSUTF8StringEncoding];
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABRecordRef defaultSource = ABAddressBookCopyDefaultSource(addressBook);
    
    CFArrayRef vCardPeople = ABPersonCreatePeopleInSourceWithVCardRepresentation(defaultSource, vCardData);
    ABRecordRef person = CFArrayGetValueAtIndex(vCardPeople, 0);
    self.vcAddrUi = [[ABNewPersonViewController alloc] init];
    self.vcAddrUi.newPersonViewDelegate = self;
    self.vcAddrUi.displayedPerson = person;
    CFRelease(vCardPeople);
    CFRelease(defaultSource);
    CFRelease(addressBook);
    
    [self.vcAddrUi willMoveToParentViewController:self];
    [self.view addSubview:self.vcAddrUi.view];
    self.vcAddrUi.view.frame = self.view.frame;
    [self addChildViewController:self.vcAddrUi];
}

#pragma mark - IBActions

-(void)didTapClose:(id)sender{
    [self.vcAddrUi willMoveToParentViewController:nil];
    [self.vcAddrUi.view removeFromSuperview];
    [self.vcAddrUi removeFromParentViewController];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - ABNewPersonViewControllerDelegate

-(void) newPersonViewController:(ABNewPersonViewController *)newPersonView
       didCompleteWithNewPerson:(ABRecordRef)person
{
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
