//
//  PaperView.m
//  TheDoomedKingdom
//
//  Created by Vlad Antipin on 1/31/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import "PaperView.h"

#define kRGB(r, g, b, a) [UIColor colorWithRed:(r)/255. green:(g)/255. blue:(b)/255. alpha:(a)]
#define filePathWithName(fileEndPath) [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] bundlePath],(fileEndPath)]

@implementation PaperView

//- (void)awakeFromNib {
//    [self setPaperView];
//}
//
//- (void)loadView {
//    [self setPaperView];
//}
//
//- (void)setPaperView {
//    self.backgroundColor = [UIColor clearColor];
//    UIImage* image = [UIImage imageWithContentsOfFile:filePathWithName(@"background.png")];
//    self.layer.contents = (id)image.CGImage;
//    self.layer.masksToBounds = true;
//}
//
///*
//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}
//*/

@end
