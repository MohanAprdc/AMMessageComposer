//
//  AMMessageCell.m
//  AWSearchBar
//
//  Created by Mohan Rao on 27/01/14.
//  Copyright (c) 2014 Mohan Rao. All rights reserved.
//

#import "AMMessageCell.h"
#import "UIImage+Stretchable.h"
#import <MediaPlayer/MediaPlayer.h>

#define THUMBNAIL_IMAGE_AT_TIME_INTERVEL 5.0

@interface AMMessageCell()

@property (nonatomic, strong) UIImageView *messageBgView;
@property (nonatomic, strong) UIImageView *messageImageView;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayerController;
@property (nonatomic, strong) UIImage *videoThumbImage;
@property (nonatomic, strong) UIImageView *videoThumbImageView;

@end

@implementation AMMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setUI];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UI utility
-(void) setUI
{
    // user
    UIImageView *userAvatar = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:userAvatar];
    self.userAvatarImgView = userAvatar;
    
    UILabel *userNameLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    userNameLbl.backgroundColor = [UIColor clearColor];
    userNameLbl.textColor = [UIColor colorWithRed:99.0/255.0 green:99.0/255.0 blue:99.0/255.0 alpha:1.0];
    [userNameLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
    userNameLbl.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:userNameLbl];
    self.userNameLbl = userNameLbl;
    
    // message sent time
    UILabel *messageSentTimeLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    messageSentTimeLbl.backgroundColor = [UIColor clearColor];
    messageSentTimeLbl.textColor = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:154.0/255.0
                                                alpha:1.0];
    [messageSentTimeLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
    [self.contentView addSubview:messageSentTimeLbl];
    self.messageSentTimeLbl = messageSentTimeLbl;
    
    // message view
    UIImageView *messageBgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:messageBgView];
    self.messageBgView = messageBgView;
    
    UILabel *messageLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    messageLbl.backgroundColor = [UIColor clearColor];
    messageLbl.numberOfLines = 0;
    [messageLbl setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
    messageLbl.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:messageLbl];
    self.messageLbl = messageLbl;
    
    // imageview
    UIImageView *messageImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:messageImageView];
    self.messageImageView = messageImageView;
    
    // media player
    MPMoviePlayerController *moviePlayerController = [[MPMoviePlayerController alloc] init];
    [moviePlayerController setControlStyle:MPMovieControlStyleEmbedded];
    [moviePlayerController setScalingMode:MPMovieScalingModeAspectFit];
    [moviePlayerController setMovieSourceType:MPMovieSourceTypeFile];
    [moviePlayerController prepareToPlay];
    [self.contentView addSubview:moviePlayerController.view];
    self.moviePlayerController = moviePlayerController;
    
    UIImageView *thumbImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:thumbImageView];
    self.videoThumbImageView = thumbImageView;
}

-(void) handleThumbnailImageRequestFinishNotification:(NSNotification*)notifiation
{
    NSDictionary *userinfo = [notifiation userInfo];
    NSError* value = [userinfo objectForKey:MPMoviePlayerThumbnailErrorKey];
    
    if (value!=nil)
    {
        NSLog(@"Error: %@", [value debugDescription]);
    }
    else
    {
        self.videoThumbImageView.image = [userinfo valueForKey:MPMoviePlayerThumbnailImageKey];
        [self.moviePlayerController stop];
    }
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    if (self.isSentMessage)
    {
        // my message
        self.userAvatarImgView.frame = CGRectMake(CGRectGetMaxX(self.contentView.frame) - 64.0,
                                                  CGRectGetMinY(self.contentView.frame) + 16.0,
                                                  60.0,
                                                  60.0);
        self.userAvatarImgView.layer.cornerRadius = CGRectGetHeight(self.userAvatarImgView.frame)/2.0;
        
        self.userNameLbl.frame = CGRectMake(CGRectGetMinX(self.userAvatarImgView.frame),
                                            CGRectGetMaxY(self.userAvatarImgView.frame)+2.0,
                                            CGRectGetWidth(self.userAvatarImgView.frame),
                                            12.0);
        self.messageSentTimeLbl.frame = CGRectMake(CGRectGetMinX(self.contentView.frame) + 10.0,
                                                   CGRectGetMinY(self.contentView.frame) + 14.0,
                                                   CGRectGetWidth(self.contentView.frame) - 20.0,
                                                   12.0);
        self.messageSentTimeLbl.textAlignment = NSTextAlignmentLeft;
        
        if (self.messageImage == nil && self.messageVideoPath.length == 0)
        {
            CGSize messageSize = [self getSizeforText:self.messageLbl.text];
            
            self.messageBgView.frame = CGRectMake(CGRectGetMaxX(self.contentView.frame) - messageSize.width - 100.0,
                                                  CGRectGetMinY(self.contentView.frame) + 30.0,
                                                  messageSize.width + 30.0,
                                                  messageSize.height + 14.0);
            
            self.messageLbl.frame = CGRectMake(CGRectGetMinX(self.messageBgView.frame) + 10.0,
                                               CGRectGetMinY(self.messageBgView.frame) + 5.0,
                                               messageSize.width, messageSize.height);
            
            [self.messageLbl setHidden:NO];
            [self.moviePlayerController.view setHidden:YES];
            [self.videoThumbImageView setHidden:YES];
            [self.messageImageView setHidden:YES];
            
            self.messageBgView.image = [UIImage stretchableImageWithName:@"bg_chatmessage"
                                                               extension:@"png"
                                                                  topCap:20
                                                                 leftCap:8
                                                               bottomCap:13
                                                             andRightCap:26];
        }
        else if(self.messageImage != nil && self.messageVideoPath.length == 0)
        {
            // image message
            
            CGSize imageSize = self.messageImage.size;
            if (imageSize.height > MAXIMUM_IMAGE_SIZE_HEIGHT)
                imageSize.height = MAXIMUM_IMAGE_SIZE_HEIGHT;
            if (imageSize.width > MAXIMUM_IMAGE_SIZE_WIDHT)
                imageSize.width = MAXIMUM_IMAGE_SIZE_WIDHT;
            
            self.messageBgView.frame = CGRectMake(CGRectGetMaxX(self.contentView.frame) - imageSize.width - 90.0,
                                                  CGRectGetMinY(self.contentView.frame) + 30.0,
                                                  imageSize.width + 18.0,
                                                  imageSize.height + 14.0);
            
            self.messageBgView.image = [UIImage stretchableImageWithName:@"bg_chatmessage"
                                                               extension:@"png"
                                                                  topCap:20
                                                                 leftCap:8
                                                               bottomCap:13
                                                             andRightCap:26];
            
            [self.messageLbl setHidden:YES];
            [self.moviePlayerController.view setHidden:YES];
            [self.videoThumbImageView setHidden:YES];
            [self.messageImageView setHidden:NO];
            
            self.messageImageView.frame = CGRectMake(CGRectGetMinX(self.messageBgView.frame) + 6.0,
                                                     CGRectGetMinY(self.messageBgView.frame) + 5.0,
                                                     imageSize.width,
                                                     imageSize.height);
            
            self.messageImageView.image = self.messageImage;
        }
        else
        {
            // video message
            
            CGSize videoSize = CGSizeMake(MAXIMUM_IMAGE_SIZE_WIDHT, MAXIMUM_IMAGE_SIZE_HEIGHT);
            
            self.messageBgView.frame = CGRectMake(CGRectGetMaxX(self.contentView.frame) - videoSize.width - 90.0,
                                                  CGRectGetMinY(self.contentView.frame) + 30.0,
                                                  videoSize.width + 18.0,
                                                  videoSize.height + 14.0);
            
            self.messageBgView.image = [UIImage stretchableImageWithName:@"bg_chatmessage"
                                                               extension:@"png"
                                                                  topCap:20
                                                                 leftCap:8
                                                               bottomCap:13
                                                             andRightCap:26];
            
            self.moviePlayerController.view.frame = CGRectMake(CGRectGetMinX(self.messageBgView.frame) + 6.0,
                                                               CGRectGetMinY(self.messageBgView.frame) + 5.0,
                                                               videoSize.width,
                                                               videoSize.height);
            NSURL *fileUrl = [NSURL fileURLWithPath:self.messageVideoPath];
            [self.moviePlayerController setContentURL:fileUrl];
            [self.moviePlayerController prepareToPlay];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(handleThumbnailImageRequestFinishNotification:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification
                                                       object:self.moviePlayerController];
            
            self.videoThumbImageView.frame = CGRectMake(CGRectGetMinX(self.messageBgView.frame) + 6.0,
                                                        CGRectGetMinY(self.messageBgView.frame) + 5.0,
                                                        videoSize.width,
                                                        videoSize.height);
            
            [self.moviePlayerController requestThumbnailImagesAtTimes:@[[NSNumber numberWithFloat:THUMBNAIL_IMAGE_AT_TIME_INTERVEL]]
                                                           timeOption:MPMovieTimeOptionNearestKeyFrame];
            
            [self.messageLbl setHidden:YES];
            [self.messageImageView setHidden:YES];
            [self.moviePlayerController.view setHidden:YES];
            [self.videoThumbImageView setHidden:NO];
        }
    }
    else
    {
        self.userAvatarImgView.frame = CGRectMake(CGRectGetMinX(self.contentView.frame) + 4.0,
                                                  CGRectGetMinY(self.contentView.frame) + 16.0,
                                                  60.0,
                                                  60.0);
        self.userAvatarImgView.layer.cornerRadius = CGRectGetHeight(self.userAvatarImgView.frame)/2.0;
        
        self.userNameLbl.frame = CGRectMake(CGRectGetMinX(self.userAvatarImgView.frame),
                                            CGRectGetMaxY(self.userAvatarImgView.frame)+2.0,
                                            CGRectGetWidth(self.userAvatarImgView.frame),
                                            12.0);
        self.messageSentTimeLbl.frame = CGRectMake(CGRectGetMinX(self.contentView.frame) + 10.0,
                                                   CGRectGetMinY(self.contentView.frame) + 14.0,
                                                   CGRectGetWidth(self.contentView.frame) - 20.0,
                                                   12.0);
        self.messageSentTimeLbl.textAlignment = NSTextAlignmentRight;
        
        if (self.messageImage == nil && self.messageVideoPath.length == 0)
        {
            CGSize messageSize = [self getSizeforText:self.messageLbl.text];
            self.messageBgView.frame = CGRectMake(CGRectGetMinX(self.contentView.frame) + 70.0,
                                                  CGRectGetMinY(self.contentView.frame) + 30.0,
                                                  messageSize.width + 30.0,
                                                  messageSize.height + 14.0);
            
            self.messageLbl.frame = CGRectMake(CGRectGetMinX(self.messageBgView.frame) + 15.0,
                                               CGRectGetMinY(self.messageBgView.frame) + 5.0,
                                               messageSize.width,
                                               messageSize.height);
            
            [self.messageLbl setHidden:NO];
            [self.messageImageView setHidden:YES];
            [self.videoThumbImageView setHidden:YES];
            [self.moviePlayerController.view setHidden:YES];
            
            self.messageBgView.image = [UIImage stretchableImageWithName:@"bg_chatmessage_others"
                                                               extension:@"png"
                                                                  topCap:22
                                                                 leftCap:10
                                                               bottomCap:13
                                                             andRightCap:26];
        }
        else if(self.messageVideoPath.length == 0)
        {
            CGSize imageSize = self.messageImage.size;
            if (imageSize.height > MAXIMUM_IMAGE_SIZE_HEIGHT)
                imageSize.height = MAXIMUM_IMAGE_SIZE_HEIGHT;
            if (imageSize.width > MAXIMUM_IMAGE_SIZE_WIDHT)
                imageSize.width = MAXIMUM_IMAGE_SIZE_WIDHT;
            
            self.messageBgView.frame = CGRectMake(CGRectGetMinX(self.contentView.frame) + 70.0,
                                                  CGRectGetMinY(self.contentView.frame) + 30.0,
                                                  imageSize.width + 18.0,
                                                  imageSize.height + 14.0);
            
            self.messageBgView.image = [UIImage stretchableImageWithName:@"bg_chatmessage_others"
                                                               extension:@"png"
                                                                  topCap:22
                                                                 leftCap:10
                                                               bottomCap:13
                                                             andRightCap:26];
            
            [self.messageLbl setHidden:YES];
            [self.moviePlayerController.view setHidden:YES];
            [self.videoThumbImageView setHidden:YES];
            [self.messageImageView setHidden:NO];
            
            self.messageImageView.frame = CGRectMake(CGRectGetMinX(self.messageBgView.frame)+12.0,
                                                     CGRectGetMinY(self.messageBgView.frame) + 5.0,
                                                     imageSize.width,
                                                     imageSize.height);
            self.messageImageView.image = self.messageImage;
        }
        else
        {
            // video message
            
            CGSize videoSize = CGSizeMake(MAXIMUM_IMAGE_SIZE_WIDHT, MAXIMUM_IMAGE_SIZE_HEIGHT);
            
            self.messageBgView.frame = CGRectMake(CGRectGetMaxX(self.contentView.frame) + 70.0,
                                                  CGRectGetMinY(self.contentView.frame) + 30.0,
                                                  videoSize.width + 18.0,
                                                  videoSize.height + 14.0);
            
            self.messageBgView.image = [UIImage stretchableImageWithName:@"bg_chatmessage_others"
                                                               extension:@"png"
                                                                  topCap:22
                                                                 leftCap:10
                                                               bottomCap:13
                                                             andRightCap:26];
            
            self.moviePlayerController.view.frame = CGRectMake(CGRectGetMinX(self.messageBgView.frame) + 12.0,
                                                               CGRectGetMinY(self.messageBgView.frame) + 5.0,
                                                               videoSize.width,
                                                               videoSize.height);
            NSURL *fileUrl = [NSURL fileURLWithPath:self.messageVideoPath];
            [self.moviePlayerController setContentURL:fileUrl];
            [self.moviePlayerController prepareToPlay];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(handleThumbnailImageRequestFinishNotification:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification
                                                       object:self.moviePlayerController];
            
            self.videoThumbImageView.frame = CGRectMake(CGRectGetMinX(self.messageBgView.frame) + 12.0,
                                                        CGRectGetMinY(self.messageBgView.frame) + 5.0,
                                                        videoSize.width,
                                                        videoSize.height);
            [self.moviePlayerController requestThumbnailImagesAtTimes:@[[NSNumber numberWithFloat:THUMBNAIL_IMAGE_AT_TIME_INTERVEL]]
                                                           timeOption:MPMovieTimeOptionNearestKeyFrame];
            
            [self.messageLbl setHidden:YES];
            [self.messageImageView setHidden:YES];
            [self.moviePlayerController.view setHidden:YES];
            [self.videoThumbImageView setHidden:NO];
        }
    }
}

#pragma mark - public method
-(CGSize) getSizeforText:(NSString *)message
{
//    CGSize size = [message sizeWithFont:[UIFont fontWithName:@"ProximaNova-Regular" size:12.0]
//                      constrainedToSize:CGSizeMake((self.bounds.size.width - 126.0), 2000)
//                          lineBreakMode:NSLineBreakByWordWrapping];
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    context.minimumScaleFactor = 0.8;
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:12.0];
    CGRect frame = [message boundingRectWithSize:CGSizeMake((self.contentView.frame.size.width - 110.0), 2000)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{ NSFontAttributeName : font}
                                         context:context];
    return frame.size;
}

-(void) playOrStopVideo
{
    [self.videoThumbImageView setHidden:YES];
    [self.moviePlayerController.view setHidden:NO];
    [self.moviePlayerController play];
}

@end
