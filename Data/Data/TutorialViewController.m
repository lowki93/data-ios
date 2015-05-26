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

int translation, indexTutorial;
float duration;
NSMutableArray *titleArray, *subTitleTutorial;
CGFloat dataViewHeight;

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
    [self.verticalLabelConstraint setConstant:dataViewHeight];

    [self.dataView setBackgroundColor:[baseView colorWithRGB:243 :243 :243 :1]];
    [self.dataView initView:self];

    [self updateLabel];

    [self.hourLabel setText:@"toto"];
    [self.view addSubview:self.hourLabel];


    /** hide **/
    [self animatedView:self.tutorialLabel Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translation];
    [self animatedView:self.informationLabel Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translation];

    /** show **/
    [self animatedView:self.tutorialLabel Duration:duration Delay:duration Alpha:1 TranslationX:0 TranslationY:0];
    [self animatedView:self.informationLabel Duration:duration Delay:duration+0.1 Alpha:1 TranslationX:0 TranslationY:0];

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
