//
//  ChooseDayViewController.m
//  Data
//
//  Created by kevin Budain on 01/05/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "ChooseDayViewController.h"
#import "BaseViewController.h"

@interface ChooseDayViewController ()

@end

BaseViewController *baseView;

UISwipeGestureRecognizer *leftGesture, *rightGesture;
int nbDayTime, indexDay;
float labelWidth, firstMargin;

@implementation ChooseDayViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    baseView = [[BaseViewController alloc] init];
    [baseView initView:self];

    [self.validateButton setBackgroundImage:[baseView imageWithColor:baseView.purpleColor] forState:UIControlStateHighlighted];
    [[self.validateButton layer] setBorderWidth:1.0f];
    [[self.validateButton layer] setBorderColor:baseView.purpleColor.CGColor];

    nbDayTime = 14;
    labelWidth = self.view.bounds.size.width / 4;
    indexDay = 3;
    firstMargin = ((self.view.bounds.size.width / 2) - (labelWidth / 2 ));

    [self.dayScrollView setBackgroundColor:[UIColor clearColor]];
    [self.dayScrollView setPagingEnabled:YES];
    [self.dayScrollView setContentSize:CGSizeMake( firstMargin * 2 + (labelWidth * (nbDayTime + 1)), self.dayScrollView.bounds.size.height )];
    [self.dayScrollView setShowsHorizontalScrollIndicator:NO];
    [self.dayScrollView setShowsVerticalScrollIndicator:NO];
    [self.dayScrollView setScrollsToTop:NO];

    for (int i= 0; i < nbDayTime; i++) {

        UILabel *label = [[UILabel alloc] init];
        [label setFrame:CGRectMake(firstMargin + (labelWidth * i), 0, labelWidth, self.dayScrollView.bounds.size.height)];
        [label setText:[NSString stringWithFormat:@"%i", i + 1]];
        [label setFont:[UIFont fontWithName:@"MaisonNeue-Book" size:50]];
        [label setTextColor:[baseView colorWithRGB:29 :29 :27 :1]];
        [label setTextAlignment:NSTextAlignmentCenter];

        if ( ((indexDay - 2) == i ) || ((indexDay + 2) == i) ) {

            [label setAlpha:0.2];

        }

        if ( ((indexDay - 1) == i ) || ((indexDay + 1) == i) ) {

            [label setAlpha:0.4];
            
        }

        [self.dayScrollView addSubview:label];

    }

    [self setAutomaticallyAdjustsScrollViewInsets:NO];

    [self moveScrollView];

    leftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    [leftGesture setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.dayScrollView addGestureRecognizer:leftGesture];

    rightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    [rightGesture setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.dayScrollView addGestureRecognizer:rightGesture];

}

-(void)swipeLeft:(UISwipeGestureRecognizer *)recognizer {

    if (indexDay > 0) {

        indexDay--;
        [self moveScrollView];

    }
}

- (void)swipeRight:(UISwipeGestureRecognizer *)recognizer {

    if (indexDay < nbDayTime - 1) {

        indexDay++;
        [self moveScrollView];
        
    }
    
}

- (void)moveScrollView {

    CGRect frame = self.dayScrollView.frame;
    frame.origin.x = labelWidth * indexDay;
    [self.dayScrollView scrollRectToVisible:frame animated:YES];

    [UIView animateWithDuration:0.5  delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{

        int count = 0;

        for (UILabel *label in self.dayScrollView.subviews) {

            if ( ((indexDay - 2) == count ) || ((indexDay + 2) == count) ) {

                [label setAlpha:0.2];

            } else if ( ((indexDay - 1) == count ) || ((indexDay + 1) == count) ) {

                [label setAlpha:0.4];
                
            } else {

                [label setAlpha:1];

            }

            count++;

        }
        
    } completion:^(BOOL finished){
    }];

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{

    return YES;

}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];

}


- (IBAction)validateAction:(id)sender {
}
@end
