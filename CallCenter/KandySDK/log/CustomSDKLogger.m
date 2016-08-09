/*
 * Copyright 2015 © GENBAND US LLC, All Rights Reserved
 * This software embodies materials and concepts which are
 * proprietary to GENBAND and/or its licensors and is made
 * available to you for use solely in association with GENBAND
 * products or services which must be obtained under a separate
 * agreement between you and GENBAND or an authorized GENBAND
 * distributor or reseller.
 
 * THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER
 * AND/OR ITS LICENSORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * THE WARRANTY AND LIMITATION OF LIABILITY CONTAINED IN THIS
 * AGREEMENT ARE FUNDAMENTAL PARTS OF THE BASIS OF GENBAND’S BARGAIN
 * HEREUNDER, AND YOU ACKNOWLEDGE THAT GENBAND WOULD NOT BE ABLE TO
 * PROVIDE THE PRODUCT TO YOU ABSENT SUCH LIMITATIONS.  IN THOSE
 * STATES AND JURISDICTIONS THAT DO NOT ALLOW CERTAIN LIMITATIONS OF
 * LIABILITY, GENBAND’S LIABILITY SHALL BE LIMITED TO THE GREATEST
 * EXTENT PERMITTED UNDER APPLICABLE LAW.
 
 * Restricted Rights legend:
 * Use, duplication, or disclosure by the U.S. Government is
 * subject to restrictions set forth in subdivision (c)(1) of
 * FAR 52.227-19 or in subdivision (c)(1)(ii) of DFAR 252.227-7013.
 */

#import "CustomSDKLogger.h"

@implementation CustomSDKLogger

#define kLogFileName @"Log.TXT"
#define kOldLogFileName @"oldLog.TXT"
#define kSwapFileSize 1024 * 1024 * 10

@synthesize loggingFormatter;


-(id)initWithFormatter:(id<KandyLoggingFormatterProtocol>)formatter
{
  self = [super init];
  if (self)
  {
    [self resetLogFile];
    self.loggingFormatter = formatter;
  }
  return self;
}


#pragma mark - Public

-(void)resetLogFile{
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *filePath = [NSString stringWithFormat:@"%@/%@",documentsDirectory, kLogFileName];
  
  BOOL isDir = NO;
  NSError *error = nil;
  if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir]) {
    
    
    unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error] fileSize];
    
    if (error!= nil) {
      NSLog(@"%s [Line %d] error %@", __PRETTY_FUNCTION__, __LINE__, [error description]);
      return;
    }
    
    if (fileSize > kSwapFileSize) {
      NSString *oldFilePath = [NSString stringWithFormat:@"%@/%@",documentsDirectory, kOldLogFileName];
      BOOL isOldDir = NO;
      
      if ([[NSFileManager defaultManager] fileExistsAtPath:oldFilePath isDirectory:&isOldDir]){
        if (!isDir) {
          [[NSFileManager defaultManager] removeItemAtPath:oldFilePath error:&error];
          
          if (error!= nil) {
            NSLog(@"%s [Line %d] error %@", __PRETTY_FUNCTION__, __LINE__, [error description]);
            return;
          }
        }
      }
      
      [[NSFileManager defaultManager] moveItemAtPath:filePath toPath:oldFilePath error:&error];
      if (error!= nil) {
        NSLog(@"%s [Line %d] error %@", __PRETTY_FUNCTION__, __LINE__, [error description]);
        return;
      }
      
    }else{
      
    }
    
  }else{
    
  }
}


-(NSData*)getLogFileData{
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *txtFilePath = [documentsDirectory stringByAppendingPathComponent:kLogFileName];
  NSData *logData = [NSData dataWithContentsOfFile:txtFilePath];
  return logData;
}


#pragma mark - KandyLoggerProtocol

-(void)logWithLevel:(EKandyLogLevel)level andLogString:(NSString *)logString{
  // NSLog(@"Level: %lu , Log: %@", (unsigned long)level, logString);
  
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *fileName = [NSString stringWithFormat:@"%@/%@",documentsDirectory, kLogFileName];
  
  NSString *fileContent = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
  NSMutableArray *arrLogEntries = [NSMutableArray arrayWithArray:[fileContent componentsSeparatedByString:@"\n"]];
  [arrLogEntries addObject:logString];
  fileContent = [arrLogEntries componentsJoinedByString:@"\n"];
  
  NSError *error = nil;
  [fileContent writeToFile:fileName atomically:NO encoding:NSUTF8StringEncoding error:nil];
  
  if (error!= nil) {
    NSLog(@"%s [Line %d] error %@", __PRETTY_FUNCTION__, __LINE__, [error description]);
    return;
  }
  
}

@end







