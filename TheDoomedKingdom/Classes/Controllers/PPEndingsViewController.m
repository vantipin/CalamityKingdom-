//
//  PPEndingsViewController.m
//  TheDoomedKingdom
//
//  Created by Vlad Antipin on 1/31/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import "PPEndingsViewController.h"
#import "PPLandingController.h"
#import "SoundController.h"
#import "PPEnding.h"
#import "PPGame.h"

#define timeToDisplayChar 0.03

#define kRGB(r, g, b, a) [UIColor colorWithRed:(r)/255. green:(g)/255. blue:(b)/255. alpha:(a)]
#define filePathWithName(fileEndPath) [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] bundlePath],(fileEndPath)]

@interface PPEndingsViewController ()

@property (nonatomic) IBOutlet UIImageView *imageInfo;
@property (nonatomic) IBOutlet UIButton *buttonContinue;
@property (nonatomic) IBOutlet UITextView *textViewInfo;

@property (nonatomic) IBOutlet UIButton *closeButton;
@property (nonatomic) NSString *text;

@property (nonatomic) BOOL displayinTextInProcess;

@property (nonatomic) NSInteger endingId;

@end

@implementation PPEndingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.skipUpdates) {
        return;
    }
    
//    UIImage* image = [UIImage imageWithContentsOfFile:filePathWithName(@"background.png")];
//    self.view.layer.contents = (id)image.CGImage;
//    self.view.layer.masksToBounds = true;
//    
    [super viewWillAppear:animated];
    
    NSString *endingIdString = [NSString stringWithFormat:@"%li", (long)self.endingId];
    NSArray *endings = [[PPGame instance].endings filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.identifier == %@", endingIdString]];
    
    
    
    _displayinTextInProcess = true;
    self.textViewInfo.text = @"";
    [self.closeButton setHidden:YES];
    
    [self setEnding:[endings lastObject]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)appendTextForIndex:(NSInteger)index {
    if (index < self.text.length) {
        self.textViewInfo.text = [self.text substringToIndex:index];
        
        index++;
        __weak __typeof(self) weakSelf = self;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((self.displayinTextInProcess ? timeToDisplayChar : 0.) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf appendTextForIndex:index];
        });
    } else {
        [self.closeButton setHidden:NO];
    }
}

- (void)setEnding:(PPEnding *)ending {
    [[SoundController sharedInstance] pause];
    
    [[SoundController sharedInstance] playSoundName:ending.endingSound];
    
    self.imageInfo.alpha = 0;
    self.text = ending.text;
    UIImage *image = [UIImage imageNamed:ending.imageName];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.imageInfo.alpha = 1;
        self.imageInfo.image = image;
    } completion:nil];
    
    self.textViewInfo.font = [UIFont fontWithName:@"Helvetica" size:23];
    self.textViewInfo.textColor = kRGB(255, 254, 212, 1);
    
    [self appendTextForIndex:0];
}

+ (void)showWithEndingId:(NSInteger)endingId {
    PPEndingsViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"EndingStoryId"];
    
    viewController.endingId = endingId;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [UIView transitionFromView:window.rootViewController.view
                        toView:viewController.view
                      duration:0.65f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    completion:^(BOOL finished){
                        
                        viewController.skipUpdates = YES;
                        window.rootViewController = viewController;
                        viewController.skipUpdates = NO;
                    }];
}

- (void)buttonEnabled {
    self.buttonContinue.userInteractionEnabled = true;
}

- (IBAction)continueButtonTap:(id)sender {
    
    //display text piece
    if (_displayinTextInProcess) {
        //clear text box and start from beginning
        _displayinTextInProcess = false;
        self.buttonContinue.userInteractionEnabled = false;
        [NSTimer scheduledTimerWithTimeInterval: 0.5 target: self
                                       selector: @selector(buttonEnabled) userInfo: nil repeats: NO];
    } else {
        [self.closeButton setHidden:NO];
    }
}

- (void)startOver {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [PPLandingController show];
    });
}

- (IBAction)closeButtonPressed:(id)sender {
    [self startOver];
}

@end

