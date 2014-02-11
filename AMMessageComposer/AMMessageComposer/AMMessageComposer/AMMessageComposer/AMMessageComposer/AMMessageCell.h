//
//  AMMessageCell.h
//  AWSearchBar
//
//  Created by Mohan Rao on 27/01/14.
//  Copyright (c) 2014 Mohan Rao. All rights reserved.
//

#import <UIKit/UIKit.h>

// Maximum image size 200 X 200
#define MAXIMUM_IMAGE_SIZE_WIDHT 200
#define MAXIMUM_IMAGE_SIZE_HEIGHT 200

#define VIDEO_FRAME_WIDTH 200
#define VIDEO_FRAME_HEIGHT 200


/*
 *  This is the generic cell for message of any type 
 *
 *  @userAvatarImgView is an user image for message sent or received
 *
 *  @userNameLbl is a User Name for message sent or received
 *
 *  @messageSentTimeLbl is the time that message sent
 *
 *  @messageLbl this is the text messge label
 *
 *  @messageImage this is the image message
 *
 *  @messageVideoPath is the path of the video file
 *
 *  @isSentMessage this is for differntating the message sent and received
 */

/*
 *      Note : If the message is text message then the @messageImage and @messgeVideo should be nil
 * 
 *      In the same way when setting the image message remining two (text and video) should be nil and same for
 *      and the same for video also.
 */

@interface AMMessageCell : UITableViewCell

@property (nonatomic, strong) UIImageView *userAvatarImgView;
@property (nonatomic, strong) UILabel *userNameLbl;
@property (nonatomic, strong) UILabel *messageSentTimeLbl;
@property (nonatomic, strong) UILabel *messageLbl;
@property (nonatomic, strong) UIImage *messageImage;
@property (nonatomic, strong) NSString *messageVideoPath;

@property (nonatomic, assign) BOOL isSentMessage;

-(void) playOrStopVideo;

@end
