//
//  UIImage+Stretchable.m
//  AWSearchBar
//
//  Created by Mohan Rao on 28/01/14.
//  Copyright (c) 2014 Mohan Rao. All rights reserved.
//

#import "UIImage+Stretchable.h"

@implementation UIImage (Stretchable)

//  getting an image from bundle
+ (UIImage *) imageNameInBundle:(NSString *)name
                  withExtension:(NSString *)extension
{
    @autoreleasepool
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:name
                                                         ofType:extension];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        
        return image;
    }
}

+ (UIImage *) stretchableImageWithName:(NSString *)name
                             extension:(NSString *)extension
                                topCap:(int)topcap
                               leftCap:(int)leftCap
                             bottomCap:(int)bottomCap
                           andRightCap:(int)rightCap
{
    @autoreleasepool
    {
        UIImage *image = [self imageNameInBundle:name
                                   withExtension:extension];
        image = [image stretchableImageWithLeftCapWidth:leftCap
                                           topCapHeight:topcap];
        return image;
    }
}

@end
