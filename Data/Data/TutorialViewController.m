//
//  TutorialViewController.m
//  Data
//
//  Created by kevin Budain on 26/05/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "TutorialViewController.h"
#import "BaseViewController.h"

@interface TutorialViewController ()

@end

BaseViewController *baseView;

UISwipeGestureRecognizer *leftGesture;

int translation, indexTutorial, dataCount;
float duration;
NSMutableArray *titleArray, *subTitleTutorial;
CGFloat dataViewHeight;

NSDictionary *dictionnary;

@implementation TutorialViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    translation = 20;
    duration = 0.5;
    indexTutorial = 0;

    titleArray = [@[@"Hours 1/4", @"Captation 2/4", @"Hours data 3/4", @"Daily data 4/4"] mutableCopy ];
    subTitleTutorial = [@[@"chaque point correspond\nà une heure de la journée", @"le point centrale t’indique\nque l’application capte des ddonnées", @"TAPE SUR UNE HEURE POUR\nVOIR LES DONNÉES RÉCOLTÉES", @"TAPE SUR UNE HEURE POUR\nVOIR LES DONNÉES RÉCOLTÉES"] mutableCopy ];

    baseView = [[BaseViewController alloc] init];
    [baseView initView:self];

    dataViewHeight = self.view.bounds.size.height * 0.30;
    [self.verticalConstraint setConstant:dataViewHeight];

    [self.dataView setBackgroundColor:[baseView colorWithRGB:243 :243 :243 :1]];
    [self.dataView setFrame:CGRectMake(0, dataViewHeight, self.view.bounds.size.width, self.view.bounds.size.height * 0.70)];
    [self.dataView initView:self];

    [self updateLabel];

    [self.hourLabel setText:@"toto"];
    [self.verticalLabelConstraint setConstant:(self.view.bounds.size.height * 0.65) - (self.hourLabel.bounds.size.height / 2)];
    [self.view addSubview:self.hourLabel];

    NSString *pathJson = [[NSBundle mainBundle] pathForResource:@"tutorialExperience" ofType:@"json"];

    if([[NSFileManager defaultManager] fileExistsAtPath:pathJson]){

        NSString *jsonString = [[NSString alloc] initWithContentsOfFile:pathJson encoding:NSUTF8StringEncoding error:nil];
        NSData * jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        self.parsedData = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];

        dictionnary = self.parsedData[@"day"];

    }

    /** hide **/
    [self animatedView:self.hourLabel Duration:0 Delay:0 Alpha:0 TranslationX:-translation TranslationY:0];
    [self animatedView:self.tutorialLabel Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translation];
    [self animatedView:self.informationLabel Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translation];

    /** show **/
    [self animatedView:self.tutorialLabel Duration:duration Delay:duration Alpha:1 TranslationX:0 TranslationY:0];
    [self animatedView:self.informationLabel Duration:duration Delay:duration+0.1 Alpha:1 TranslationX:0 TranslationY:0];
    [self animatedView:self.hourLabel Duration:duration Delay:duration * 2 Alpha:1 TranslationX:0 TranslationY:0];

    /** gesture **/
    leftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    [leftGesture setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:leftGesture];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updateLabel {

    [self.tutorialLabel setText:[[titleArray objectAtIndex:indexTutorial] uppercaseString]];
    [self.informationLabel setText:[[subTitleTutorial objectAtIndex:indexTutorial] uppercaseString]];
    [baseView addLineHeight:1.3 Label:self.informationLabel];

}

/** swipe gesture **/
- (void)swipeLeft:(UISwipeGestureRecognizer *)recognizer {

    indexTutorial++;
    if(indexTutorial == 1) {

        [self animatedView:self.hourLabel Duration:duration Delay:0 Alpha:0 TranslationX:-translation TranslationY:0];

        for (CAShapeLayer *layer in self.dataView.layer.sublayers) {

            if ([layer isKindOfClass:[CAShapeLayer class]]) {

                CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
                [opacityAnimation setFromValue: [NSNumber numberWithFloat:1]];
                [opacityAnimation setToValue: [NSNumber numberWithFloat:0]];
                [opacityAnimation setDuration: duration];
                [opacityAnimation setFillMode:kCAFillModeForwards];
                [opacityAnimation setRemovedOnCompletion:NO];

                [layer addAnimation:opacityAnimation forKey:@"opacityAnimation"];
                
            }

        }
        self.tutorialDay = [[Day alloc] initWithDictionary:dictionnary error:nil];
        dataCount = (int)[self.tutorialDay.data count];
        for (int i = 0; i < dataCount; i++) {
            [self.dataView generateData:i Day:self.tutorialDay];
        }
        [self.dataView performSelector:@selector(activeCapta) withObject:nil afterDelay:3];

    }

    [UIView animateWithDuration:duration delay:0 options:0 animations:^{

        [self.informationLabel setAlpha:0];
        [self.tutorialLabel setAlpha:0];
        [self.tutorialLabel setTransform:CGAffineTransformMakeTranslation(-translation, 0)];
        [self.informationLabel setTransform:CGAffineTransformMakeTranslation(-translation, 0)];

    } completion:^(BOOL finished){

        [self updateLabel];
        [self.informationLabel setTransform:CGAffineTransformMakeTranslation(translation, 0)];
        [self.tutorialLabel setTransform:CGAffineTransformMakeTranslation(translation, 0)];

        [UIView animateWithDuration:duration delay:0 options:0 animations:^{

            [self.informationLabel setAlpha:1];
            [self.tutorialLabel setAlpha:1];
            [self.tutorialLabel setTransform:CGAffineTransformMakeTranslation(0, 0)];
            [self.informationLabel setTransform:CGAffineTransformMakeTranslation(0, 0)];

        } completion:nil];

    }];

    if(indexTutorial == 3) {

        [self.view removeGestureRecognizer:leftGesture];
    }

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {

    return YES;
}

- (void)animatedView:(UIView *)view Duration:(float)duration Delay:(float)delay Alpha:(float)alpha TranslationX:(int)translationX TranslationY:(int)translationY{

    [UIView animateWithDuration:duration delay:delay options:0 animations:^{

        [view setAlpha:alpha];
        [view setTransform:CGAffineTransformMakeTranslation(translationX, translationY)];

    } completion:nil];
    
}

@end
