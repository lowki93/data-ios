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
#import "GeolocViewController.h"

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

    if(self.isSignUp) {
        [self.view setBackgroundColor:[baseView colorWithRGB:0 :0 :0 :0]];
        [self.groundImageView removeFromSuperview];
    } else {
        [self.groundImageView initImageView];
    }

    NSDictionary *dictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"user"];
    [[ApiController sharedInstance] setUserLoad:dictionary];

    if ([ApiController sharedInstance].experience == nil) {

        [self createExperience];

    }

    self.socket = [[ApiController sharedInstance] activeSocket:self];

    NSString *informationParingString = [self.informationParringLabel text];
    [self.informationParringLabel setText:[informationParingString uppercaseString]];

    [baseView addLineHeight:1.4 Label:self.waitingLabel];
    [baseView addLineHeight:1.3 Label:self.informationParringLabel];

    /** title animation **/
    [self animatedView:self.titleLabel Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translation];

    /** content animation **/
    [self animatedView:self.informationParringLabel Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translation];
    [self animatedView:self.waitingLabel Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translation];

    /** line animation **/
    [self animatedView:self.lineView Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:0];

    /** button bottom animation **/
    [self animatedView:self.informationLabel Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translation];
    [self animatedView:self.continueButton Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translation];

    /** loader animation **/
    [self animatedView:self.loaderImageView Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translation];


    [self performSelector:@selector(firstAnimation) withObject:nil afterDelay:duration];
}

- (void)firstAnimation {
    [self animatedView:self.titleLabel Duration:duration Delay:0 Alpha:1 TranslationX:0 TranslationY:0];
    [self animatedView:self.informationParringLabel Duration:duration Delay:duration Alpha:1 TranslationX:0 TranslationY:0];
    [self animatedView:self.waitingLabel Duration:duration Delay:duration Alpha:1 TranslationX:0 TranslationY:0];
    [self animatedView:self.lineView Duration:duration Delay:duration Alpha:1 TranslationX:0 TranslationY:0];
    [self animatedView:self.informationLabel Duration:duration Delay:duration Alpha:1 TranslationX:0 TranslationY:0];
    [self animatedView:self.continueButton Duration:duration Delay:duration Alpha:1 TranslationX:0 TranslationY:0];
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

    [self pairringIsDone];
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

- (void)websocket:(JFRWebSocket*)socket didReceiveMessage:(NSString*)string {

    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    dispatch_async(dispatch_get_main_queue(),^{
        if(jsonDictionary[@"pairing"]) {
            [self performSelector:@selector(pairringIsDone) withObject:nil afterDelay:3.f];
        }
    });
}

- (void)pairringIsDone {

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

        [self performSelector:@selector(excuteSegue) withObject:nil afterDelay:duration];
        
    }

}

- (void)excuteSegue {

    [self.titleLabel removeFromSuperview];
    [self.waitingLabel removeFromSuperview];
    [self.informationLabel removeFromSuperview];
    [self.informationParringLabel removeFromSuperview];
    [self.continueButton removeFromSuperview];
    [self.lineView removeFromSuperview];
    [self.loaderImageView removeFromSuperview];
//    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController *viewController =  [storyboard instantiateViewControllerWithIdentifier:@"PairingDataViewController"];
//    keyWindow.rootViewController = viewController;
//    [keyWindow makeKeyAndVisible];
    [self performSegueWithIdentifier:@"parring_success" sender:self];
//    [baseView showModal:@"PairingDataViewController"];
    //

}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"parring_success"]) {

        GeolocViewController *pairingViewController = [segue destinationViewController];
        pairingViewController.isConnectionPairing = true;
    }
}

@end
