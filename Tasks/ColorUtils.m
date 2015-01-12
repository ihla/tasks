//
//  ColorUtils.m
//  Tasks
//
//  Created by Lubos Ilcik on 1/11/15.
//  Copyright (c) 2015 Lubos Ilcik. All rights reserved.
//

#import "ColorUtils.h"


@implementation ColorUtils

+(NSArray*)colorNameArray {
    NSArray *names = @[
                       @"Purple",
                       @"Green",
                       @"Blue",
                       @"Yellow",
                       @"Brown",
                       @"Red",
                       @"Orange"
                       ];
    return names;
}

+(NSArray*)uiColorArray {
    NSArray *uiColors = @[
                          [UIColor purpleColor],
                          [UIColor greenColor],
                          [UIColor blueColor],
                          [UIColor yellowColor],
                          [UIColor brownColor],
                          [UIColor redColor],
                          [UIColor orangeColor]
                          ];
    return uiColors;
}

+(UIImage *)imageWithColorName:(NSString *)name rect:(CGRect)rect {
    if ([name isEqualToString:Purple]) {
        return [self imageWithColor:[UIColor purpleColor] rect:rect];
    } else if ([name isEqualToString:Green]) {
        return [self imageWithColor:[UIColor greenColor] rect:rect];
    } else if ([name isEqualToString:Blue]) {
        return [self imageWithColor:[UIColor blueColor] rect:rect];
    } else if ([name isEqualToString:Yellow]) {
        return [self imageWithColor:[UIColor yellowColor] rect:rect];
    } else if ([name isEqualToString:Brown]) {
        return [self imageWithColor:[UIColor brownColor] rect:rect];
    } else if ([name isEqualToString:Red]) {
        return [self imageWithColor:[UIColor redColor] rect:rect];
    } else if ([name isEqualToString:Orange]) {
        return [self imageWithColor:[UIColor orangeColor] rect:rect];
    }
    return [self imageWithColor:[UIColor whiteColor] rect:rect];
}

+(UIImage *)imageWithColor:(UIColor *)color rect:(CGRect)rect {
    //    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
