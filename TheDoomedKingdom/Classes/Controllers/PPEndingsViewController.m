//
//  PPEndingsViewController.m
//  TheDoomedKingdom
//
//  Created by Vlad Antipin on 1/31/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import "PPEndingsViewController.h"
#import "PPIntroViewController.h"
#import "SoundController.h"
#import "PPEnding.h"
#import "PPGame.h"

#define kRGB(r, g, b, a) [UIColor colorWithRed:(r)/255. green:(g)/255. blue:(b)/255. alpha:(a)]
#define filePathWithName(fileEndPath) [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] bundlePath],(fileEndPath)]

@interface PPEndingsViewController ()
{
    BOOL displayinTextInProcess;
}

@property (nonatomic) IBOutlet UIImageView *imageInfo;
@property (nonatomic) IBOutlet UIButton *buttonContinue;
@property (nonatomic) IBOutlet UITextView *textViewInfo;

@property (nonatomic) NSInteger endingId;

@end

@implementation PPEndingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    UIImage* image = [UIImage imageWithContentsOfFile:filePathWithName(@"background.png")];
    self.view.layer.contents = (id)image.CGImage;
    self.view.layer.masksToBounds = true;
    
    [super viewWillAppear:animated];
    
    NSString *endingIdString = [NSString stringWithFormat:@"%li", (long)self.endingId];
    NSArray *endings = [[PPGame instance].endings filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.identifier == %@", endingIdString]];
    
    [self setEnding:[endings lastObject]];

    displayinTextInProcess = true;
    self.textViewInfo.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setEnding:(PPEnding *)ending {
    [[SoundController sharedInstance] pause];
    
    [[SoundController sharedInstance] playSoundName:ending.endingSound];
    
    self.imageInfo.alpha = 0;
    NSString *text = ending.text;
    UIImage *image = [UIImage imageNamed:ending.imageName];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.imageInfo.alpha = 1;
        self.imageInfo.image = image;
    } completion:nil];
    
    self.textViewInfo.font = [UIFont fontWithName:@"Helvetica" size:23];
    self.textViewInfo.textColor = kRGB(255, 254, 212, 1);
    
    float timeToDisplayChar = 0.003;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0),^{
        for (int i = 0; i < text.length; i++) {
            dispatch_async(dispatch_get_main_queue(),^{
                NSString *stringToAdd = [text substringWithRange:NSMakeRange(i, 1)];
                self.textViewInfo.text = [self.textViewInfo.text stringByAppendingString:stringToAdd];
            });
            
            [NSThread sleepForTimeInterval:self->displayinTextInProcess ? timeToDisplayChar : 0];
        }
        
        self->displayinTextInProcess = false;
    });
    
    
}

+ (void)showWithEndingId:(NSInteger)endingId {
    PPEndingsViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"EndingStoryId"];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [UIView transitionFromView:window.rootViewController.view
                        toView:viewController.view
                      duration:0.65f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    completion:^(BOOL finished){
                        window.rootViewController = viewController;
                    }];
}

- (void)buttonEnabled {
    self.buttonContinue.userInteractionEnabled = true;
}

- (IBAction)continueButtonTap:(id)sender {
    
    //display text piece
    if (displayinTextInProcess) {
        //clear text box and start from beginning
        displayinTextInProcess = false;
        self.buttonContinue.userInteractionEnabled = false;
        [NSTimer scheduledTimerWithTimeInterval: 0.5 target: self
                                       selector: @selector(buttonEnabled) userInfo: nil repeats: NO];
    }
    else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            PPIntroViewController *controller = [self.storyboard instantiateInitialViewController];
            
            if (controller) {
                [UIApplication sharedApplication].delegate.window.rootViewController = controller;
            }
        });
        
    }
}


@end
