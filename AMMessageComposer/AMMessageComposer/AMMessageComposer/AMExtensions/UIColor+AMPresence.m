//
//  UIColor+AMPresence.m
//  AWSearchBar
//
//  Created by Mohan on 11/02/14.
//  Copyright (c) 2014 Mohan Rao. All rights reserved.
//

#import "UIColor+AMPresence.h"

@implementation UIColor (AMPresence)

+(UIColor *) onlineGreenColor
{
    return [UIColor colorWithRed:0.671 green:0.859 blue:0.145 alpha:1.0];
}

+(UIColor *) offLineGrayColor
{
    return [UIColor colorWithRed:0.584 green:0.584 blue:0.584 alpha:1.0];
}

+(UIColor *) idealOrangeColor
{
    return [UIColor colorWithRed:0.961 green:0.647 blue:0.012 alpha:1.0];
}

+(UIColor *) busyRedColor
{
    return [UIColor colorWithRed:0.824 green:0.098 blue:0.125 alpha:1.0];
}

@end
