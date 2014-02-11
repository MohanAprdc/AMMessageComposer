//
//  AMMessageVC.m
//  AWSearchBar
//
//  Created by Mohan Rao on 27/01/14.
//  Copyright (c) 2014 Mohan Rao. All rights reserved.
//

#import "AMMessageComposerVC.h"
#import "AMMessageCell.h"

#import "UIColor+AMPresence.h"

#define MESSAGE_COMPOSER_HEIGHT 40.0

#define NO_OF_MESSAGGES_HARD_CODED_VALUE 10

@interface AMMessageComposerVC ()<UITableViewDataSource, UITableViewDelegate,
                            UITextViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *messageTableView;
@property (nonatomic, strong) UIView *messageComposerView;
@property (nonatomic, strong) UITextView *messageTextView;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIButton *cameraButton;

@end

@implementation AMMessageComposerVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // message tableView
    [self addMessageTableView];
    
    // message composer view
    [self addMessageComposerView];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self scrollToBottom];
    
    // add keyboard notifications
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void) dealloc
{
    self.messageTableView = nil;
    self.messageTextView = nil;
    self.messageComposerView = nil;
    self.sendButton = nil;
    self.cameraButton = nil;
}

#pragma mark - private methods

-(void) addMessageComposerView
{
    UIView *messageComposerView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.view.frame),
                                                                          CGRectGetMaxY(self.view.frame) - MESSAGE_COMPOSER_HEIGHT,
                                                                          CGRectGetWidth(self.view.frame),
                                                                           MESSAGE_COMPOSER_HEIGHT)];
    messageComposerView.backgroundColor = [UIColor colorWithRed:240.0/255.0
                                                          green:240.0/255.0
                                                           blue:240.0/255.0
                                                          alpha:1.0];
    [self.view addSubview:messageComposerView];
    self.messageComposerView = messageComposerView;
    
    UIImage *divImg = [UIImage imageNamed:@"divder"];
    UIImageView *dividerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0,
                                                                                0.0,
                                                                                CGRectGetWidth(self.view.frame),
                                                                                divImg.size.height)];
    dividerImgView.image = divImg;
    [messageComposerView addSubview:dividerImgView];
    
    // text view
    UITextView *messageTextView = [[UITextView alloc] initWithFrame:CGRectMake(40.0,
                                                                              5.0,
                                                                              CGRectGetWidth(messageComposerView.frame)-100.0,
                                                                               MESSAGE_COMPOSER_HEIGHT - 10.0)];
    messageTextView.layer.cornerRadius = 4.0;
    messageTextView.layer.borderWidth = 1.0;
    messageTextView.layer.borderColor = [UIColor colorWithRed:224.0/255.0
                                                        green:224.0/255.0
                                                         blue:226.0/255.0
                                                        alpha:1.0].CGColor;
    messageTextView.backgroundColor = [UIColor whiteColor];
    messageTextView.delegate = self;
    [messageTextView setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
    [messageComposerView addSubview:messageTextView];
    self.messageTextView = messageTextView;
    
    // Send button
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake(CGRectGetMaxX(messageComposerView.frame) - 55.0,
                                  5.0,
                                  50.0,
                                  MESSAGE_COMPOSER_HEIGHT - 10.0);
    [sendButton setTitle:@"Send" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor colorWithRed:141.0/255.0
                                              green:141.0/255.0
                                               blue:141.0/255.0
                                              alpha:1.0]
                     forState:UIControlStateDisabled];
    [sendButton setTitleColor:[UIColor colorWithRed:51.0/255.0
                                              green:51.0/255.0
                                               blue:255.0/255.0
                                              alpha:1.0]
                     forState:UIControlStateNormal];
    [sendButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0]];
    [sendButton setEnabled:NO];
    [sendButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [messageComposerView addSubview:sendButton];
    self.sendButton = sendButton;
    
    // camera button
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraButton.frame = CGRectMake(CGRectGetMinX(messageComposerView.bounds),
                                    CGRectGetMinY(messageComposerView.bounds),
                                    40.0, 40.0);
    [cameraButton setTitleColor:[UIColor colorWithRed:141.0/255.0
                                             green:141.0/255.0
                                              blue:141.0/255.0
                                              alpha:1.0]
                     forState:UIControlStateNormal];
    [cameraButton setImage:[UIImage imageNamed:@"button_photo"] forState:UIControlStateNormal];
    [cameraButton setImage:[UIImage imageNamed:@"button_photo"] forState:UIControlStateHighlighted];
    [cameraButton addTarget:self action:@selector(getImage) forControlEvents:UIControlEventTouchUpInside];
    [messageComposerView addSubview:cameraButton];
    self.cameraButton = cameraButton;
}

-(void) addMessageTableView
{
    UITableView *messagesTableView = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.view.frame),
                                                                                   CGRectGetMinY(self.view.frame),
                                                                                   CGRectGetWidth(self.view.frame),
                                                                                   CGRectGetHeight(self.view.frame)-MESSAGE_COMPOSER_HEIGHT)
                                                                  style:UITableViewStylePlain];
    messagesTableView.dataSource = self;
    messagesTableView.delegate = self;
    messagesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    messagesTableView.backgroundColor = [UIColor colorWithRed:239.0/255.0
                                                        green:239.0/255.0
                                                         blue:239.0/255.0
                                                        alpha:1.0];
    [self.view addSubview:messagesTableView];
    self.messageTableView = messagesTableView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGSize) getSizeforText:(NSString *)message
{
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    context.minimumScaleFactor = 0.8;
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:12.0];
    CGRect frame = [message boundingRectWithSize:CGSizeMake((self.view.frame.size.width - 100.0), 2000)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{ NSFontAttributeName : font}
                                         context:context];
    return frame.size;
}

-(void) scrollToBottom
{
    [self.messageTableView beginUpdates];
    NSIndexPath *lastCellIndexPath = [NSIndexPath indexPathForItem:NO_OF_MESSAGGES_HARD_CODED_VALUE-1
                                                         inSection:0];
    [self.messageTableView scrollToRowAtIndexPath:lastCellIndexPath
                                 atScrollPosition:UITableViewScrollPositionBottom
                                         animated:YES];
    [self.messageTableView endUpdates];
}

-(void) changeTextViewSize
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeTextViewSize) object:nil];
    
    CGSize textViewSize = self.messageTextView.contentSize;
    CGFloat maximumHeight = 66.0;
    if (textViewSize.height > maximumHeight)
    {
        textViewSize.height = maximumHeight;
    }
    else if (textViewSize.height < MESSAGE_COMPOSER_HEIGHT - 10.0)
    {
        textViewSize.height = MESSAGE_COMPOSER_HEIGHT - 10.0;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGFloat heightDifference = textViewSize.height - self.messageTextView.frame.size.height;
    
    self.messageComposerView.frame = CGRectMake(CGRectGetMinX(self.messageComposerView.frame),
                                                CGRectGetMinY(self.messageComposerView.frame) - heightDifference,
                                                CGRectGetWidth(self.messageComposerView.frame),
                                                CGRectGetHeight(self.messageComposerView.frame) + heightDifference);
    
    self.messageTextView.frame = CGRectMake(CGRectGetMinX(self.messageTextView.frame),
                                            CGRectGetMinY(self.messageTextView.frame),
                                            CGRectGetWidth(self.messageTextView.frame),
                                            CGRectGetHeight(self.messageTextView.frame) + heightDifference);
    
    self.messageTableView.frame = CGRectMake(CGRectGetMinX(self.messageTableView.frame),
                                             CGRectGetMinY(self.messageTableView.frame),
                                             CGRectGetWidth(self.messageTableView.frame),
                                             CGRectGetHeight(self.messageTableView.frame) - heightDifference);
    
    [self scrollToBottom];
    [UIView commitAnimations];
}

#pragma mark - public methods
-(void) reloadMessagesData
{
    [self.messageTableView reloadData];
}

#pragma mark - button actions
-(void) sendMessage
{
    if ([self.amDelegate respondsToSelector:@selector(sendMessage:)])
    {
        [self.amDelegate sendMessage:self.messageTextView.text];
    }
}

-(void) getImage
{
    if ([self.amDelegate respondsToSelector:@selector(sendImage)])
    {
        [self.amDelegate sendImage];
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
     Number of messages = number of rows
     */
    if ([self.amDataSource respondsToSelector:@selector(numberOfMessages)])
    {
        return [self.amDataSource numberOfMessages];
    }
    else
        return 0;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     Message Type
     */
    AMMessageCellType type = AMMessageCellTypeText;
    if ([self.amDataSource respondsToSelector:@selector(typeOfTheMessage:)])
    {
        type = [self.amDataSource typeOfTheMessage:indexPath];
    }
    
    if (type == AMMessageCellTypeText)
    {
        //         Text Message
        
        if ([self.amDataSource respondsToSelector:@selector(textForTheRowAtIndexPath:)])
        {
            NSString *message = [self.amDataSource textForTheRowAtIndexPath:indexPath];
            CGSize size = [self getSizeforText:message];
            CGFloat rowHeight = 100.0;
            if (size.height > 70.0)
            {
                rowHeight = size.height + 60.0;
            }
            return rowHeight;
        }
    }
    else if (type == AMMessageCellTypeImage)
    {
        //         Image Message
        
        if ([self.amDataSource respondsToSelector:@selector(imageForTheRowAtIndexPath:)])
        {
            CGFloat rowHeight = 100.0;
            UIImage *image = [self.amDataSource imageForTheRowAtIndexPath:indexPath];
            if (image.size.height > MAXIMUM_IMAGE_SIZE_HEIGHT)
            {
                rowHeight = MAXIMUM_IMAGE_SIZE_HEIGHT + 50.0;
            }
            else if (image.size.height > 70.0)
            {
                rowHeight = image.size.height + 60.0;
            }
            return rowHeight;
        }
    }
    else if (type == AMMessageCellTypeVideo)
    {
        //         Video Message
        if ([self.amDataSource respondsToSelector:@selector(videoPathForTheRowAtIndexPath:)])
        {
            return VIDEO_FRAME_HEIGHT + 50.0;
        }
        
    }
    
    return 0.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [[AMMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor colorWithRed:239.0/255.0
                                                           green:239.0/255.0
                                                            blue:239.0/255.0
                                                           alpha:1.0];
    }
    
    /*
     message cell type
     */
    AMMessageCellType type = AMMessageCellTypeText;
    if ([self.amDataSource respondsToSelector:@selector(typeOfTheMessage:)])
    {
        type = [self.amDataSource typeOfTheMessage:indexPath];
    }
    
    if (type == AMMessageCellTypeText)
    {
//         Text Message
        
        if ([self.amDataSource respondsToSelector:@selector(textForTheRowAtIndexPath:)])
        {
            cell.messageLbl.text = [self.amDataSource textForTheRowAtIndexPath:indexPath];
            cell.messageImage = nil;
            cell.messageVideoPath = nil;
        }
    }
    else if (type == AMMessageCellTypeImage)
    {
//         Image Message
        
        if ([self.amDataSource respondsToSelector:@selector(imageForTheRowAtIndexPath:)])
        {
            cell.messageImage = [self.amDataSource imageForTheRowAtIndexPath:indexPath];
            cell.messageLbl.text = nil;
            cell.messageVideoPath = nil;
        }
    }
    else if (type == AMMessageCellTypeVideo)
    {
//         Video Message
        if ([self.amDataSource respondsToSelector:@selector(videoPathForTheRowAtIndexPath:)])
        {
            cell.messageVideoPath = [self.amDataSource videoPathForTheRowAtIndexPath:indexPath];
            cell.messageLbl.text = nil;
            cell.messageImage = nil;
        }
        
    }
    
    /*
     Time Stamp
     */
    if ([self.amDataSource respondsToSelector:@selector(timeStampForRowAtIndexPath:)])
    {
        cell.messageSentTimeLbl.text = [self.amDataSource timeStampForRowAtIndexPath:indexPath].description;
    }
    
    /*
     UserName
     */
    if ([self.amDataSource respondsToSelector:@selector(userNameForRowAtIndexPath:)])
    {
        cell.userNameLbl.text = [self.amDataSource userNameForRowAtIndexPath:indexPath];
    }
    
    /*
     UserImage
     */
    if ([self.amDataSource respondsToSelector:@selector(userAvatarForRowAtIndexPath:)])
    {
        cell.userAvatarImgView.image = [self.amDataSource userAvatarForRowAtIndexPath:indexPath];
    }
    
    /*
     SENT or RECEIVED message
     */
    if ([self.amDataSource respondsToSelector:@selector(isCurrentUserSentMessageAtIndexPath:)])
    {
        cell.isSentMessage = [self.amDataSource isCurrentUserSentMessageAtIndexPath:indexPath];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMMessageCell *cell = (AMMessageCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.messageVideoPath.length > 0)
    {
        [cell playOrStopVideo];
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)        textView:(UITextView *)textView
 shouldChangeTextInRange:(NSRange)range
         replacementText:(NSString *)text
{
    NSString *txt = [[textView.text stringByReplacingCharactersInRange:range withString:text] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (txt.length == 0)
    {
        [self.sendButton setEnabled:NO];
    }
    else
    {
        [self.sendButton setEnabled:YES];
    }
    [self changeTextViewSize];
    return YES;
}

#pragma mark - UIScrollViewDelegate
-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [self.messageTextView resignFirstResponder];
}

#pragma mark - Keyboard Notifications
- (void)keyBoardWillShow:(NSNotification *)notification
{
    NSDictionary* userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    [userInfo[UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [userInfo[UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    
    UIViewAnimationOptions animationOptions = (animationCurve << 16); // convert from UIViewAnimationCurve to UIViewAnimationOptions
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    typeof(self) __weak weakself = self;
    
    // translate our view with the same duration and curve as the keyboard animation
    [UIView animateWithDuration:animationDuration delay:0 options:animationOptions animations:^{
        
        weakself.messageTableView.frame = CGRectMake(CGRectGetMinX(weakself.messageTableView.frame),
                                                     CGRectGetMinY(weakself.messageTableView.frame),
                                                     CGRectGetWidth(weakself.messageTableView.frame),
                                                     CGRectGetHeight(weakself.messageTableView.frame) - keyboardSize.height);
        weakself.messageComposerView.frame = CGRectMake(CGRectGetMinX(weakself.messageComposerView.frame),
                                                        CGRectGetMinY(weakself.messageComposerView.frame) - keyboardSize.height,
                                                        CGRectGetWidth(weakself.messageComposerView.frame),
                                                        CGRectGetHeight(weakself.messageComposerView.frame));
        
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)keyBoardWillHide:(NSNotification *)notification
{
    NSDictionary* userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    [userInfo[UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [userInfo[UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    
    UIViewAnimationOptions animationOptions = (animationCurve << 16); // convert from UIViewAnimationCurve to UIViewAnimationOptions
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    typeof(self) __weak weakself = self;
    
    // translate our view with the same duration and curve as the keyboard animation
    [UIView animateWithDuration:animationDuration delay:0 options:animationOptions animations:^{
        
        weakself.messageTableView.frame = CGRectMake(CGRectGetMinX(weakself.messageTableView.frame),
                                                     CGRectGetMinY(weakself.messageTableView.frame),
                                                     CGRectGetWidth(weakself.messageTableView.frame),
                                                     CGRectGetHeight(weakself.messageTableView.frame) + keyboardSize.height);
        weakself.messageComposerView.frame = CGRectMake(CGRectGetMinX(weakself.messageComposerView.frame),
                                                        CGRectGetMinY(weakself.messageComposerView.frame) + keyboardSize.height,
                                                        CGRectGetWidth(weakself.messageComposerView.frame),
                                                        CGRectGetHeight(weakself.messageComposerView.frame));
        
    } completion:^(BOOL finished) {
        
    }];
    
}


@end
