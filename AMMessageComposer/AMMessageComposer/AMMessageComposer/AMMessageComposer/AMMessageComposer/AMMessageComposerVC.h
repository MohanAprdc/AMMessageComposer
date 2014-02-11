//
//  AMMessageVC.h
//  AWSearchBar
//
//  Created by Mohan Rao on 27/01/14.
//  Copyright (c) 2014 Mohan Rao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    AMMessageCellTypeText = 0,
    AMMessageCellTypeImage,
    AMMessageCellTypeVideo,
    
}AMMessageCellType;

typedef enum {
    
    AMMessageUserPresenceTypeOnline = 0,
    AMMessageUserPresenceTypeOffline,
    AMMessageUserPresenceTypeIdeal,
    AMMessageUserPresenceTypeBusy,
    
}AMMessageUserPresenceType;

@protocol AMMessageComposerDatasource;
@protocol AMMessageComposerDelegate;

@class AMMessageCell;

@interface AMMessageComposerVC : UIViewController

@property (nonatomic, weak) id <AMMessageComposerDelegate> amDelegate;
@property (nonatomic, weak) id <AMMessageComposerDatasource> amDataSource;

-(void) reloadMessagesData;

@end

@protocol AMMessageComposerDatasource <NSObject>

/*  Cell Type
 *
 *  @param indexPath - Row indexPath of message tableview cell
 *
 *  @return AMMessageCellType - type of the cell (text or image or video)
 */
-(AMMessageCellType) typeOfTheMessage:(NSIndexPath *)indexPath;

/*  Text Message
 *
 *  @param indexPath - Row indexPath of message tableView cell
 *
 *  @return string - the message to be displayed in cell of indexPath
 */
-(NSString *) textForTheRowAtIndexPath:(NSIndexPath *)indexPath;

/*  Image Message
 *
 *  @param indexPath - Row indexPath of message tableView
 *
 *  @return Image - the image to be displayed in cell of indexPath
 */
-(UIImage *) imageForTheRowAtIndexPath:(NSIndexPath *)indexPath;

/*  Video Message
 *
 *  @param indexPath - Row indexPath of message tableView
 *
 *  @return String - the path of the video file
 */
-(NSString *) videoPathForTheRowAtIndexPath:(NSIndexPath *)indexPath;

/*  Message Time Stamp
 *
 *  @param indexPath - Row indexPath of message tableView
 *
 *  @return Date - when the message has been sent/received
 */
-(NSDate *) timeStampForRowAtIndexPath:(NSIndexPath *)indexPath;

/*  User Image
 *
 *  @param indexPath - Row indexPath of message TableView
 *
 *  @return Image - Image of the user who sent message - both for sender and receiver
 */
-(UIImage *) userAvatarForRowAtIndexPath:(NSIndexPath *)indexPath;

/*  User Name
 *
 *  @param indexPath - Row indexPath of message TableView
 *
 *  @return String - Username of the user who sent message - both for sender and receiver
 */
-(NSString *) userNameForRowAtIndexPath:(NSIndexPath *)indexPath;

/*  User Presence state
 *
 *  @param indexPath - Row index path of message tableView
 *
 *  @return AMMessageUserPresenceType - presence type of the message sent user
 */
-(AMMessageUserPresenceType) userPresenceStateOfMessageAtIndexPath:(NSIndexPath *)indexPath;

/*  sent or received Message
 *
 *  @param indexPath - Row index path of the message tableview
 *
 *  @return BOOL - is sent or receved message of current user
 */
-(BOOL) isCurrentUserSentMessageAtIndexPath:(NSIndexPath *)indexPath;

/*  Number of messages
 *
 *  @param - nothing
 *  
 *  @return NSInteger - number of rows/messages in a tableview
 */
-(NSInteger) numberOfMessages;

@end

@protocol AMMessageComposerDelegate <NSObject>

@optional
/*  when the message / cell did selected
 *
 *  @param - indexPath - index path of the message / row
 *
 *  @return nothig
 */
-(void) didSelectMessageAtIndexPath:(NSIndexPath *)indexPath;

/*  send message button action delegate
 *
 *  @pram - textMessage - the string message
 *
 *  @return nothing
 */
-(void) sendMessage:(NSString *)textMessage;

/*  send image button action delegate
 *
 *  @param - image - the image which has to be sent as message
 *
 *  @return nothing
 */
-(void) sendImage;

@end
