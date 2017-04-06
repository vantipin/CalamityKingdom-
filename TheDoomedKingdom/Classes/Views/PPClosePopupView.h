//
//  PPClosePopupView.h
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/31/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPCityInfoController.h"
//#import "PaperView.h"

@protocol PPCloseDelegate <NSObject>

- (void)close;

@end


@interface PPClosePopupView : UIView

@property (nonatomic, strong) id parent;
@property (nonatomic, weak) id<PPCloseDelegate> closeDelegate;

@end
