//
//  IntroViewController.m
//  TheDoomedKingdom
//
//  Created by Vlad Antipin on 1/31/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import "IntroViewController.h"
#import "SoundController.h"
#import "PPBaseGameController.h"
#import "EndingsViewController.h"

#define kRGB(r, g, b, a) [UIColor colorWithRed:(r)/255. green:(g)/255. blue:(b)/255. alpha:(a)]
#define filePathWithName(fileEndPath) [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] bundlePath],(fileEndPath)]


#define replica_1 @"Давным-давно, в Безмятежном Королевстве..."
#define replica_2 @"Великий архимаг варил борщ."
#define replica_3 @"И все было бы хорошо."
#define replica_4 @"Если бы великий архимаг по ошибке не добавил в борщ..."
#define replica_5 @"КРОВЬ ВЕРХОВНОГО БОГА ТЬМЫ"
#define replica_6 @"Вместо петрушки."

//(У архимага появляется облачко с текстом "упс")
//(Показываем башню)
#define replica_7 @"Тем самым архимаг обрек Безмятежное Королевство"
#define replica_8 @"На гибель в течение десяти дней."
//- экран королевства и начало игры

@interface IntroViewController ()
{
    BOOL displayinTextInProcess;
    int displayingCursor;
    NSArray *dataSource;
}

@property (nonatomic) IBOutlet UIImageView *imageInfo;
@property (nonatomic) IBOutlet UIButton *buttonContinue;
@property (nonatomic) IBOutlet UITextView *textViewInfo;



@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    displayingCursor = 0;
    displayinTextInProcess = false;
    dataSource = @[replica_1,
                   replica_2,
                   replica_3,
                   replica_4,
                   replica_5,
                   replica_6,
                   replica_7,
                   replica_8];
    self.textViewInfo.text = @"";
    self.textViewInfo.font = [UIFont fontWithName:@"Helvetica" size:33];
    self.textViewInfo.textColor = kRGB(255, 254, 212, 1);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    UIImage* image = [UIImage imageWithContentsOfFile:filePathWithName(@"background.png")];
    self.view.layer.contents = (id)image.CGImage;
    self.view.layer.masksToBounds = true;
    
    [super viewWillAppear:animated];
    
    //play main music
    [[SoundController sharedInstance] resume];
    
    //start display text
    [self displayText:dataSource[displayingCursor]];
}

- (void)displayText:(NSString *)text {
    self.textViewInfo.text = @"";
    self.textViewInfo.font = [UIFont fontWithName:@"Helvetica" size:33];
    self.textViewInfo.textColor = kRGB(255, 254, 212, 1);
    displayinTextInProcess = true;
    float timeToDisplayChar = 0.009;
    
    if (displayingCursor == 6) {
        
        self.imageInfo.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.imageInfo.alpha = 1;
            self.imageInfo.image = [UIImage imageNamed:@"intro2.png"];
        } completion:^(BOOL finished) {
            [[SoundController sharedInstance] playEvent];
        }];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0),^{
        for (int i = 0; i < text.length; i++) {
            dispatch_async(dispatch_get_main_queue(),^{
                NSString *stringToAdd = [text substringWithRange:NSMakeRange(i, 1)];
                self.textViewInfo.text = [self.textViewInfo.text stringByAppendingString:stringToAdd];
                self.textViewInfo.font = [UIFont fontWithName:@"Helvetica" size:33];
                self.textViewInfo.textColor = kRGB(255, 254, 212, 1);
            });

            [NSThread sleepForTimeInterval:displayinTextInProcess ? timeToDisplayChar : 0];
        }
        displayinTextInProcess = false;
        displayingCursor ++;
        if (displayingCursor > dataSource.count - 1) {
            dispatch_async(dispatch_get_main_queue(),^{
                [self.buttonContinue setTitle:@"Нажмите чтобы продолжить..." forState:UIControlStateNormal];
                self.buttonContinue.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:33];
            });
        }
    });
}

- (void)buttonEnabled {
    self.buttonContinue.userInteractionEnabled = true;
}

- (IBAction)continueButtonTap:(id)sender {
    
    if (displayingCursor <= dataSource.count - 1) {
        //display text piece
        if (displayinTextInProcess) {
            //clear text box and start from beginning
            displayinTextInProcess = false;
            self.buttonContinue.userInteractionEnabled = false;
            [NSTimer scheduledTimerWithTimeInterval: 0.5 target: self
                                           selector: @selector(buttonEnabled) userInfo: nil repeats: NO];
        }
        else {
            //start displaying text
            [self displayText:dataSource[displayingCursor]];
        }
        
    }
    else {
        //start the game
        PPBaseGameController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MainScreenStoryId"];
        if (controller) {
            self.view.window.rootViewController = controller;
        }
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
