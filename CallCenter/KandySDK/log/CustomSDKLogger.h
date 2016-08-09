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

#import <Foundation/Foundation.h>
#import <KandySDK/KandySDK.h>

/**
    The Logger class that will be set as the SDK's logging interface.
 */
@interface CustomSDKLogger : NSObject<KandyLoggerProtocol>

/**
 *  Initialization method for the logger
 *
 *  @param formatter the formatter to use inorder to format the log texts
 *
 *  @return initialized KandyLogger object conforms to KandyLoggerProtocol
 */
-(id)initWithFormatter:(id<KandyLoggingFormatterProtocol>)formatter;

/**
 *  Deletes the Log File
 */
-(void)resetLogFile;

/**
 *  Returns the Log File as NSData* object
 *
 *  @return NSData* object representing the Log File
 */
-(NSData*)getLogFileData;

@end
