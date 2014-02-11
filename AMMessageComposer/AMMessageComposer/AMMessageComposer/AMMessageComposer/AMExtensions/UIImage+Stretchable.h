//
//  UIImage+Stretchable.h
//  AWSearchBar
//
//  Created by Mohan Rao on 28/01/14.
//  Copyright (c) 2014 Mohan Rao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Stretchable)

+ (UIImage *) imageNameInBundle:(NSString *)name
                  withExtension:(NSString *)extension;

+ (UIImage *) stretchableImageWithName:(NSString *)name
                             extension:(NSString *)extension
                                topCap:(int)topcap
                               leftCap:(int)leftCap
                             bottomCap:(int)bottomCap
                           andRightCap:(int)rightCap;

@end
