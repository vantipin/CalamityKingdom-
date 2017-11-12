//
//  ViewController.h
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/30/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface PPBaseGameController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *playerName;
@property (weak, nonatomic) IBOutlet UILabel *popularityLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property (strong, nonatomic) IBOutletCollection(id) NSArray *cityViews;

@property (strong, nonatomic) IBOutletCollection(id) NSArray *playerAbilities;

- (IBAction)plusHour:(id)sender;

- (IBAction)libraryPressed:(id)sender;

@end

