//
//  PairingViewController.m
//  Data
//
//  Created by kevin Budain on 30/04/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "PairingViewController.h"
#import "BaseViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface PairingViewController ()

@end

BaseViewController *baseView;

int translation, translationY;
float duration;

@implementation PairingViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    translation = 20;
    translationY = 75;
    duration = 0.5;

    baseView = [[BaseViewController alloc] init];
    [baseView initView:self];

    if ([ApiController sharedInstance].experience == nil) {

        [self createExperience];

    }
//    [baseView loadLoader:self.loaderImageView View:self.view];
//    NSArray *extraArgs = [[NSArray alloc] initWithObjects:self.loaderImageView, self.view, nil];
//    [NSThread detachNewThreadSelector:@selector(generateTutorialAnimationImage:View:) toTarget:baseView withObject:extraArgs];

    NSString *informationParingString = [self.informationParringLabel text];
    [self.informationParringLabel setText:[informationParingString uppercaseString]];

    [baseView addLineHeight:1.3 Label:self.waitingLabel];
    [baseView addLineHeight:1.3 Label:self.informationParringLabel];

    /** title animation **/
    [self animatedView:self.titleLabel Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translation];
    [self animatedView:self.titleLabel Duration:duration Delay:0 Alpha:1 TranslationX:0 TranslationY:0];

    /** content animation **/
    [self animatedView:self.informationParringLabel Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translation];
    [self animatedView:self.waitingLabel Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translation];

    [self animatedView:self.informationParringLabel Duration:duration Delay:duration Alpha:1 TranslationX:0 TranslationY:0];
    [self animatedView:self.waitingLabel Duration:duration Delay:duration Alpha:1 TranslationX:0 TranslationY:0];

    /** line animation **/
    [self animatedView:self.lineView Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:0];
    [self animatedView:self.lineView Duration:duration Delay:duration Alpha:1 TranslationX:0 TranslationY:0];

    /** button bottom animation **/
    [self animatedView:self.informationLabel Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translation];
    [self animatedView:self.continueButton Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translation];

    [self animatedView:self.informationLabel Duration:duration Delay:duration Alpha:1 TranslationX:0 TranslationY:0];
    [self animatedView:self.continueButton Duration:duration Delay:duration Alpha:1 TranslationX:0 TranslationY:0];

    /** loader animation **/
    [self animatedView:self.loaderImageView Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translation];
    [self animatedView:self.loaderImageView Duration:duration Delay:duration Alpha:1 TranslationX:0 TranslationY:0];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)animatedView:(UIView *)view Duration:(float)duration Delay:(float)delay Alpha:(float)alpha TranslationX:(int)translationX TranslationY:(int)translationY{

    [UIView animateWithDuration:duration delay:delay options:0 animations:^{

        [view setAlpha:alpha];
        [view setTransform:CGAffineTransformMakeTranslation(translationX, translationY)];

    } completion:nil];

}

- (IBAction)action:(id)sender {

    if ([ApiController sharedInstance].experience != nil) {

        /** loader **/
        [self animatedView:self.loaderImageView Duration:duration Delay:0 Alpha:0 TranslationX:-translationY TranslationY:0];

        /** title animation **/
        [self animatedView:self.titleLabel Duration:duration Delay:0 Alpha:0 TranslationX:-translationY TranslationY:0];

        /** content animation **/
        [self animatedView:self.informationParringLabel Duration:duration Delay:0 Alpha:0 TranslationX:-translationY TranslationY:0];
        [self animatedView:self.waitingLabel Duration:duration Delay:0 Alpha:0 TranslationX:-translationY TranslationY:0];

        /** line animation **/
        [self animatedView:self.lineView Duration:0 Delay:0 Alpha:0 TranslationX:-translationY TranslationY:0];

        /** button bottom animation **/
        [self animatedView:self.informationLabel Duration:duration Delay:0 Alpha:0 TranslationX:-translationY TranslationY:0];
        [self animatedView:self.continueButton Duration:duration Delay:0 Alpha:0 TranslationX:-translationY TranslationY:0];

        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

            [self performSegueWithIdentifier:@"parring_success" sender:self];
        
        });

    }

}

- (void)createExperience {

    NSString *urlString = [[ApiController sharedInstance] getUrlExperienceCreate];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary *dictionary = responseObject[@"user"];
        [[ApiController sharedInstance] setUserLoad:dictionary];
        NSLog(@"experience created");

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        NSLog(@"error create experience : %@", error);
        [self performSelector:@selector(createExperience) withObject:nil afterDelay:5.];

    }];

}

//- (void)generateTutorialAnimationImage {
//
//    @autoreleasepool {
//
//        NSMutableArray *imageArray = [[NSMutableArray alloc] init];
//
//        for( int index = 0; index < 40; index++ ){
//
//            NSString *imageName = [NSString stringWithFormat:@"loader_%i.png", index];
//            [imageArray addObject:[UIImage imageNamed:imageName]];
//
//        };
//
//        [self.loaderImageView setAnimationImages: imageArray];
//        [self.loaderImageView setAnimationDuration: 1.3];
//        [self.loaderImageView setAnimationRepeatCount:0];
//
//        [self performSelectorOnMainThread:@selector(addTutorialAnimationImage) withObject:NULL waitUntilDone:NO];
//
//    }
//    
//}
//
//- (void) addTutorialAnimationImage {
//    
//    [self.view addSubview:self.loaderImageView];
//    [self.loaderImageView startAnimating];
//    
//}

@end
