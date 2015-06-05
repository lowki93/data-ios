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
DataView *dataView;

UISwipeGestureRecognizer *leftGesture, *rightGesture;
UITapGestureRecognizer *closeAllInformationDataGesture;

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

    titleArray = [@[@"Hours 1/4", @"Captation 2/4", @"Hours data 3/4", @"Daily data 4/4", @""] mutableCopy ];
    subTitleTutorial = [@[@"chaque point correspond\nà une heure de la journée", @"le point centrale t’indique\nque l’application capte des ddonnées", @"TAPE SUR UNE HEURE POUR\nVOIR LES DONNÉES RÉCOLTÉES", @"TAPE SUR UNE HEURE POUR\nVOIR LES DONNÉES RÉCOLTÉES", @""] mutableCopy ];

    baseView = [[BaseViewController alloc] init];
    [baseView initView:self];

    dataViewHeight = self.view.bounds.size.height * 0.33;

    UIView *contentView = [[UIView alloc] init];
    [contentView setFrame:CGRectMake(0, dataViewHeight, self.view.bounds.size.width, self.view.bounds.size.height * 0.67)];
    [contentView setBackgroundColor:[baseView colorWithRGB:243 :243 :243 :1]];
    [self.view addSubview:contentView];

    dataView = [[DataView alloc] init];
    [dataView setFrame:CGRectMake(0, 0, contentView.bounds.size.width, contentView.bounds.size.height)];
    dataView.informationButton = FALSE;
    [dataView initView:self];
    [contentView addSubview:dataView];

    [self updateLabel];

    [self.hourLabel setText:@"6:00 PM"];
    [self.verticalLabelConstraint setConstant:(self.view.bounds.size.height * 0.655)];
    [self.view addSubview:self.hourLabel];

    NSString *pathJson = [[NSBundle mainBundle] pathForResource:@"tutorialExperience" ofType:@"json"];

    if([[NSFileManager defaultManager] fileExistsAtPath:pathJson]){

        NSString *jsonString = [[NSString alloc] initWithContentsOfFile:pathJson encoding:NSUTF8StringEncoding error:nil];
        NSData * jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        self.parsedData = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];

        dictionnary = self.parsedData[@"day"];

    }

    self.pageControl = [[customPageControl alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height * 0.25, self.view.frame.size.width, 37)];
    [self.pageControl setNumberOfPages:4];
    [self.pageControl setTransform: CGAffineTransformMakeScale(1.2, 1.2)];
    [self.view addSubview:self.pageControl];

    [self.tutorialTimeLineView initView:self];
    [self.tutorialTimeLineView setAlpha:0];
//    [self.tutorialTimeLineView startAnimation];
    [self.view bringSubviewToFront:self.tutorialTimeLineView];

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

    rightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    [rightGesture setDirection:UISwipeGestureRecognizerDirectionRight];

    [self performSelector:@selector(addGesture) withObject:nil afterDelay:2];

    closeAllInformationDataGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAllInformationData:)];

    self.informationDataGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(informationData:)];

    self.closeInformationGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeInformationData:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updateLabel {

    [self.tutorialLabel setText:[[titleArray objectAtIndex:indexTutorial] capitalizedString]];
    [self.informationLabel setText:[[subTitleTutorial objectAtIndex:indexTutorial] uppercaseString]];
    [baseView addLineHeight:1.5 Label:self.informationLabel];

}

- (void)swipeRight:(UISwipeGestureRecognizer *)recognizer {
    if(indexTutorial > 0) {
        indexTutorial--;
        if (indexTutorial == 0) {
            [dataView hideButton];
            [dataView.captionImageView setHidden:YES];
            [self animatedView:self.hourLabel Duration:duration Delay:3 Alpha:1 TranslationX:0 TranslationY:0];
        }
    }
}

/** swipe gesture **/
- (void)swipeLeft:(UISwipeGestureRecognizer *)recognizer {

    [self removeGesture];
    indexTutorial++;
    [self.pageControl setCurrentPage:indexTutorial];

    if(indexTutorial == 1) {

        [self animatedView:self.hourLabel Duration:duration Delay:0 Alpha:0 TranslationX:-translation TranslationY:0];

        for (CAShapeLayer *layer in dataView.layer.sublayers) {

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
        if([dataView.buttonArray count] == 0) {
            dataCount = (int)[self.tutorialDay.data count];
            for (int i = 0; i < dataCount; i++) {
                [dataView generateData:i Day:self.tutorialDay];
            }
            [dataView updateAllInformation];
        } else {
            [dataView showButton];
        }
        [dataView performSelector:@selector(activeCapta) withObject:nil afterDelay:3];
        [self performSelector:@selector(addGesture) withObject:nil afterDelay:3];

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

    if(indexTutorial == 2) {
        [dataView removeCapta];
        [dataView addActionForButton];
        [dataView writeSelecteButtonView:10];
        [self addGesture];

    }

    if(indexTutorial == 3) {

        [UIView animateWithDuration:dataView.informationView.duration  delay:dataView.informationView.duration-0.2  options:0 animations:^{

            [dataView.selectedButtonImageView setAlpha:1];

        } completion:^(BOOL finished){

            [dataView performSelector:@selector(removeButtonSelector) withObject:nil afterDelay:3.5];
            [self addGesture];
            
        }];
        [dataView removeActionForButton];
        [self.view addGestureRecognizer:self.informationDataGesture];
    }

    if(indexTutorial == 4) {
        [self removeGesture];
        [self animatedView:self.tutorialTimeLineView Duration:duration Delay:0 Alpha:1 TranslationX:0 TranslationY:0];
        [self.tutorialTimeLineView performSelector:@selector(startAnimation) withObject:nil afterDelay:duration * 2];

        [UIView animateWithDuration:duration delay:duration * 8 options:0 animations:^{

            for (UIView *view in self.view.subviews) {
                [view setAlpha:0];
            }

        } completion:^(BOOL finished){

            [self performSegueWithIdentifier:@"tutorial_data" sender:self];
            
        }];
    }

}

- (void)informationData:(UITapGestureRecognizer *)tapGestureRecognizer {

    [self.view removeGestureRecognizer:self.informationDataGesture];

    [dataView animatedCaptionImageView:0];
    [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{

        CGAffineTransform transform = dataView.transform;
        dataView.transform = CGAffineTransformScale(transform, 1.2, 1.2);

    } completion:nil];

    [UIView animateWithDuration:0.5 delay:0.2 options:0 animations:^{

        dataView.allDataView.transform = CGAffineTransformIdentity;
        dataView.allDataView.alpha = 1;


    } completion:^(BOOL finished){

        [dataView.allDataView animatedAllLabel:dataView.allDataView.duration Translation:0 Alpha:1];
        [self.view addGestureRecognizer:closeAllInformationDataGesture];

    }];

}

- (void)closeInformationData:(UITapGestureRecognizer *)tapGestureRecognizer {

    [self hideInformationData];
    [self.view removeGestureRecognizer:self.closeInformationGesture];
    
}

- (void)closeAllInformationData:(UITapGestureRecognizer *)tapGestureRecognizer {

    [dataView animatedCaptionImageView:1];
    [dataView.allDataView animatedAllLabel:dataView.allDataView.duration
                               Translation:dataView.allDataView.translation
                                     Alpha:0];

    [UIView animateWithDuration:0.5 delay:dataView.allDataView.duration options:0 animations:^{

        dataView.transform = CGAffineTransformIdentity;
        [dataView scaleInformationView:dataView.allDataView];

    } completion:^(BOOL finished){

        [self.view addGestureRecognizer:self.informationDataGesture];

    }];

}

- (void)removeGesture {
    [self.view removeGestureRecognizer:leftGesture];
    [self.view removeGestureRecognizer:rightGesture];
}

- (void)addGesture {
    [self.view addGestureRecognizer:leftGesture];
    [self.view addGestureRecognizer:rightGesture];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {

    return YES;
}

/** animation **/
- (void)animatedView:(UIView *)view Duration:(float)duration Delay:(float)delay Alpha:(float)alpha TranslationX:(int)translationX TranslationY:(int)translationY{

    [UIView animateWithDuration:duration delay:delay options:0 animations:^{

        [view setAlpha:alpha];
        [view setTransform:CGAffineTransformMakeTranslation(translationX, translationY)];

    } completion:nil];
    
}

- (void)hideInformationData {

    dataView.informationViewActive = NO;

    [dataView animatedCaptionImageView:1];

    [dataView.informationView animatedAllLabel:dataView.informationView.duration
                                   Translation:dataView.informationView.translation
                                         Alpha:0];

    [UIView animateWithDuration:dataView.informationView.duration
                          delay:dataView.informationView.duration
                        options:0 animations:^{

                            [dataView scaleInformationView:dataView.informationView];


                        } completion:nil];

    [UIView animateWithDuration:dataView.informationView.duration delay:0 options:0 animations:^{

        [dataView.hoursLabel setAlpha:0];

    } completion:nil];

    [dataView removeBorderButton];

}

@end
