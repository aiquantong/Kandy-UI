//
//  DBHandler.h
//  QSKey
//
//  Created by aiquantong on 3/23/15.
//  Copyright (c) 2015 QTsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDatabase.h"
#import "ItemModel.h"

@class ItemModel;
@class FMDatabase;

typedef void(^DBCallback)(BOOL res);

@interface DBHandler : NSObject

+ (FMDatabase *)getDB;

+(NSMutableArray *)selectAllItem;

+ (BOOL)insertItemModel:(ItemModel *)model callback:(DBCallback)callback;

+ (BOOL)delItemModel:(ItemModel *)model callback:(DBCallback)callback;

+ (void)run:(void (^)(void))completion;

@end
