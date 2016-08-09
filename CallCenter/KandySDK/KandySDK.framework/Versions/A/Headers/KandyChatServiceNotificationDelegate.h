/*
 * Copyright © 2016 GENBAND. All Rights Reserved.
 *
 * GENBAND CONFIDENTIAL. All information, copyrights, trade secrets
 * and other intellectual property rights, contained herein are the property
 * of GENBAND. This document is strictly confidential and must not be
 * copied, accessed, disclosed or used in any manner, in whole or in part,
 * without GENBAND's express written authorization.
 *
*/

#import "KandyMessageProtocol.h"
#import "KandyChatServiceEnums.h"

@class KandyChatMessage;
@class KandyDeliveryAck;
@class KandyTransferProgress;
@class KandyTypingIndication;

@protocol KandyChatServiceNotificationDelegate <NSObject>

/**
 *  Chat message received
 *
 *  @param kandyMessage     the Chat kandyMessage received
 *  @param recipientType    EKandyRecordType representing the recipient type
 */
-(void) onMessageReceived:(id<KandyMessageProtocol>)kandyMessage recipientType:(EKandyRecordType)recipientType;

/**
 *  Received acknowledge for Chat message delivered
 *  You should mark the KandyDeliveryAck as received, in order not to receive it again upon pulling events
 *
 *  @param ackData Acknowledges that the message you delivered was received by the other side 
 */
-(void) onMessageDelivered:(KandyDeliveryAck*)ackData;

/**
 *  User typing indication received
 *
 *  @param typingIndication Typing indication object describing typing state of sender
 *  @param sender           The other user that sent typing indication
 *  @param destination      The destination, can be the group there other user is trying to chat
 */
-(void) onUserTypingIndicationReceived:(KandyTypingIndication*)typingIndication sender:(KandyRecord*)sender destination:(KandyRecord*)destination;

/**
 *  Auto download progress received
 *
 *  @param transferProgress the transfer progress
 *  @param kandyMessage     the Kandy message associated with the progress notification
 */
-(void) onAutoDownloadProgress:(KandyTransferProgress*)transferProgress kandyMessage:(id<KandyMessageProtocol>)kandyMessage;

/**
 *  Auto download finished received
 *
 *  @param error        error in case of failure
 *  @param path         the final absolute path for the downloaded file
 *  @param kandyMessage the Kandy message associated with this notification
 */
-(void) onAutoDownloadFinished:(NSError*)error fileAbsolutePath:(NSString*)path kandyMessage:(id<KandyMessageProtocol>)kandyMessage;

@end
