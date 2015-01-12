//
//  ColorUtils.h
//  Tasks
//
//  Created by Lubos Ilcik on 1/11/15.
//  Copyright (c) 2015 Lubos Ilcik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorNames.h"

@interface ColorUtils : NSObject

+(NSArray*)colorNameArray;
+(NSArray*)uiColorArray;
+(NSDictionary*)colorsDictionary;
+(UIImage *)imageWithColorName:(NSString *)name rect:(CGRect)rect;
+(UIImage *)imageWithColor:(UIColor *)color rect:(CGRect)rect;

@end
