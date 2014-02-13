//
//  ViewController.m
//  AMMessageComposer
//
//  Created by Mohan on 11/02/14.
//  Copyright (c) 2014 Mohan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

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
    
    self.amDataSource = self;
    self.amDelegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ACMessageComposerDatasource
-(NSInteger) numberOfMessages
{
    return 10;
}

-(AMMessageCellType) typeOfTheMessage:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0)
    {
        if (indexPath.row % 4 == 0)
            return AMMessageCellTypeVideo;
        else
            return AMMessageCellTypeImage;
    }
    else
        return AMMessageCellTypeText;
}

-(BOOL) isCurrentUserSentMessageAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0)
        return YES;
    else
        return NO;
}

-(NSString *) textForTheRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Hi How are you doingsddsfafsddsaffsf sdfljlsf djfaslf dsldj 1234";
}

-(UIImage *) imageForTheRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIImage imageNamed:@"geek"];
}

-(NSString *) videoPathForTheRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[NSBundle mainBundle] pathForResource:@"SteveJobs" ofType:@"mp4"];
}

-(NSString *) userNameForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0)
        return @"Me";
    else
        return @"Mohan";
}

-(NSDate *) timeStampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [NSDate date];
}

-(UIImage *) userAvatarForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIImage imageNamed:@"avatar"];
}


@end
