//
//  UIColor+voicesColor.m
//  Voices
//
//  Created by John Bogil on 11/1/15.
//  Copyright © 2015 John Bogil. All rights reserved.
//

#import "UIColor+voicesColor.h"

@implementation UIColor (voicesColor)

// HEX #ff860d, RGB(255,134,13), CMYK(0,47,95,0)
+ (UIColor *)voicesOrange {
    return [[UIColor orangeColor]colorWithAlphaComponent:.95];
}

+ (UIColor *)voicesBlack {
    return  [UIColor blackColor];
}

+ (UIColor *)voicesGray {
    return [[UIColor blackColor]colorWithAlphaComponent:0.5];
}

+ (UIColor *)voicesLightGray {
    return [[UIColor grayColor]colorWithAlphaComponent:0.5];
}

+ (UIColor *)voicesBlue {
    return [UIColor colorWithRed:(26.0/255.0) green:(140.0/255.0) blue:(255.0/255.0) alpha:1];
}

+ (UIColor *)voicesLightBlue {
    return [UIColor colorWithRed:(117/255.0) green:(201/255.0) blue:(235/255.0) alpha:1];
}

+ (UIColor *)searchBarBackground {
//    RGB(237,128,25)
    return [UIColor colorWithRed:(237.0/255.0) green:(128.0/255.0) blue:(25/255.0) alpha:1.];
}

@end
