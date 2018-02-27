//
//  EndingsViewController.m
//  TheDoomedKingdom
//
//  Created by Vlad Antipin on 1/31/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import "EndingsViewController.h"
#import "IntroViewController.h"
#import "SoundController.h"
#import "PPEnding.h"
#import "PPGame.h"

#define ending_victory @"Безмятежное Королевство спасено от ужасных бедствий - и все благодаря вам! Глядя на ликующих жителей из окон собственной башни, подаренной вам королем, вы как-то не хотите вспоминать о том, что это именно из-за вас эти ужасные бедствия и начались.\nКто старое помянет - тому глаз вон!"

#define ending_loose_fame @"Вам удалось спасти Безмятежное Королевство от полного разрушения, но не удалось вернуть расположение его жителей. Поэтому на рассвете по приказу короля вас повесили под крики разгневанной толпы.\nХорошо, что архимага не убить петлей. Придется поискать другое королевство, где вам будут рады."

#define ending_loose_destruction @"Вам не удалось спасти Безмятежное Королевство. Теперь по Удачбургу маршируют зомби-нацисты, в Потехограде мутанты доедают остатки жителей, а Блинска вообще больше не существует.\nПридется поискать другое королевство, где жители еще живы."

#define kRGB(r, g, b, a) [UIColor colorWithRed:(r)/255. green:(g)/255. blue:(b)/255. alpha:(a)]
#define filePathWithName(fileEndPath) [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] bundlePath],(fileEndPath)]

@interface EndingsViewController ()
{
    BOOL displayinTextInProcess;
}

@property (nonatomic) IBOutlet UIImageView *imageInfo;
@property (nonatomic) IBOutlet UIButton *buttonContinue;
@property (nonatomic) IBOutlet UITextView *textViewInfo;

@end

@implementation EndingsViewController

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
    
#warning set correct ending
    NSArray *endings = [PPGame instance].endings;
    [self setEnding:endings[arc4random() % endings.count]];

    displayinTextInProcess = true;
    self.textViewInfo.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setEnding:(PPEnding *)ending {
    [[SoundController sharedInstance] pause];
    
    self.imageInfo.alpha = 0;
    NSString *text = ending.text;
    UIImage *image = [UIImage imageNamed:ending.imageName];
    [[SoundController sharedInstance] playSoundName:ending.endingSound];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.imageInfo.alpha = 1;
        self.imageInfo.image = image;
    } completion:nil];
    
    float timeToDisplayChar = 0.003;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0),^{
        for (int i = 0; i < text.length; i++) {
            dispatch_async(dispatch_get_main_queue(),^{
                NSString *stringToAdd = [text substringWithRange:NSMakeRange(i, 1)];
                self.textViewInfo.text = [self.textViewInfo.text stringByAppendingString:stringToAdd];
                self.textViewInfo.font = [UIFont fontWithName:@"Helvetica" size:23];
                self.textViewInfo.textColor = kRGB(255, 254, 212, 1);
            });
            
            [NSThread sleepForTimeInterval:displayinTextInProcess ? timeToDisplayChar : 0];
        }
        displayinTextInProcess = false;
        [self.buttonContinue setTitle:@"Нажмите чтобы начать заново." forState:UIControlStateNormal];
        self.buttonContinue.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:33];
    });
    
    
}

+ (void)triggerEndingWithController:(UIViewController *)controller {
    EndingsViewController *endingController = [controller.storyboard instantiateViewControllerWithIdentifier:@"EndingStoryId"];
    if (controller) {
        controller.view.window.rootViewController = endingController;
    }
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
            IntroViewController *controller = [self.storyboard instantiateInitialViewController];
            
            if (controller) {
                [UIApplication sharedApplication].delegate.window.rootViewController = controller;
            }
        });
        
    }
}


@end
