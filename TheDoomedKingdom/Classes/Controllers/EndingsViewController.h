//
//  EndingsViewController.h
//  TheDoomedKingdom
//
//  Created by Vlad Antipin on 1/31/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EndingsViewController : UIViewController

//call like
//[EndingsViewController triggerEndingWithController:self];
+ (void)triggerEndingWithController:(UIViewController *)controller endingId:(NSInteger)endingId;

@end
