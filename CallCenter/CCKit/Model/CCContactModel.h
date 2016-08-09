//
//  CCContactModel.h
//  CallCenter
//
//  Created by aiquantong on 7/29/16.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KandySDK/KandySDK.h>


@interface CCContactModel : NSObject

@property(nonatomic,assign)BOOL isSelect;
@property(nonatomic, strong)id <KandyContactProtocol> contact;

@end
