//
//  DBHandler.m
//  QSKey
//
//  Created by aiquantong on 3/23/15.
//  Copyright (c) 2015 QTsoft. All rights reserved.
//

#import "DBHandler.h"

static FMDatabase *db;
static dispatch_queue_t dbqueue;

@implementation DBHandler

+ (FMDatabase *)getDB {
    if (!db) {
        db = [self prepareDatabase];
    }
    return db;
}

// ready user数据库, 其后所有的数据库操作对象即是针对user的数据库。
+ (FMDatabase *)prepareDatabase {
    NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbfilePath = [documentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"tvc.sqlite"]];
    FMDatabase *fmdb = [FMDatabase databaseWithPath:dbfilePath];
    
    if (![fmdb open]) {
        [fmdb close];
        NSLog(@"Severe error occurs when trying to initially connect to database !\n");
        return nil;
    }
    
    NSDictionary *attributes = @{NSFileProtectionKey : NSFileProtectionNone};
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] setAttributes:attributes
                                                    ofItemAtPath:dbfilePath
                                                           error:&error];
    if (!success) {
        NSLog(@"File protection failed: %@", error);
    }
    
    //2016-01-16 21:54:45
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [fmdb setDateFormat:dateformatter];
    
    NSError *err = nil;
  
    err = nil;
    NSString *saveSql = @"create table if not exists 'call_item' (\
    'id' integer primary key autoincrement not NULL,\
    'userID' text not NULL,\
    'display' text not NULL,\
    'endTime' text not NULL,\
    'startTime' long long not NULL,\
    'genTime' long long not NULL,\
    'duration' text not NULL,\
    'state' int not NULL,\
    'callType' int not NULL,\
    'direct' int not NULL);";
    
    [fmdb executeUpdate:saveSql values:nil error:&err];
    if (nil != err) {
        NSLog(@"Error occurs when trying to create call_item table: %@\n", [err localizedDescription]);
    }

    return fmdb;
}


#pragma mark plate

+(NSMutableArray *)selectAllItem
{
    NSString *selctSql = @"select * from call_item order by genTime DESC";
    NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:10];
    
    FMResultSet *sdResultSet = [db executeQuery:selctSql];
    while ([sdResultSet next]) {
        ItemModel *item = [[ItemModel alloc] init];

        item.iid = [sdResultSet intForColumn:@"id"];
        item.userID = [sdResultSet stringForColumn:@"userID"];
        item.display = [sdResultSet stringForColumn:@"display"];
        item.endTime = [sdResultSet stringForColumn:@"endTime"];
        item.startTime = [sdResultSet doubleForColumn:@"startTime"];
      
        item.genTime = [sdResultSet doubleForColumn:@"genTime"];
      
        item.duration = [sdResultSet stringForColumn:@"duration"];
        item.state = [sdResultSet intForColumn:@"state"];
        item.callType = [sdResultSet intForColumn:@"callType"];
        item.direct = [sdResultSet intForColumn:@"direct"];
      
        [ret addObject:item];
    }
    
    [sdResultSet close];
    return ret;
}


+ (BOOL)insertItemModel:(ItemModel *)model callback:(DBCallback)callback;
{
    
    __block long long rel = -1;
    if (model == nil) {
        return NO;
    }
    
    [DBHandler run:^{
    
        NSString *sql = @"insert or replace into call_item(userID, display, endTime, startTime, genTime, duration, state, callType, direct) values(?,?,?,?,?,?,?,?,?);";
        FMDatabase *db = [DBHandler getDB];
        
        BOOL r = [db executeUpdate:sql, model.userID, model.display, model.endTime,@(model.startTime), @(model.genTime), model.duration, @(model.state), @(model.callType), @(model.direct)];
        
        if (r) {
            rel = [db lastInsertRowId];
        } else {
            NSLog(@"%@", [db lastError]);
        }
      if (callback) {
        callback(r);
      }
    }];
    
    return YES;
}


+ (BOOL)delItemModel:(ItemModel *)model callback:(DBCallback)callback;
{
    
    __block long long rel = -1;
    if (model == nil) {
        return NO;
    }
    
    [DBHandler run:^{
        NSString *sql = @"delete from call_item where id == ?";
        FMDatabase *db = [DBHandler getDB];
        
        BOOL r = [db executeUpdate:sql, @(model.iid)];
        
        if (r) {
            rel = [db lastInsertRowId];
        } else {
            NSLog(@"%@", [db lastError]);
        }
      if (callback) {
        callback(r);
      }
    }];
    
    return YES;
}



#pragma mark open function

+ (void)run:(void (^)(void))completion {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbqueue = dispatch_queue_create("dbqueue", DISPATCH_QUEUE_SERIAL);
    });
    
    dispatch_sync(dbqueue, ^{
        completion();
    });
}



@end
