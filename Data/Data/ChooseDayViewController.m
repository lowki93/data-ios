//
//  ChooseDayViewController.m
//  Data
//
//  Created by kevin Budain on 01/05/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "ChooseDayViewController.h"
#import "BaseViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "DataViewController.h"

@interface ChooseDayViewController ()

@end

BaseViewController *baseView;

UISwipeGestureRecognizer *leftGesture, *rightGesture;
int nbDayTime, indexDay, translation;
float labelWidth, firstMargin, duration;

@implementation ChooseDayViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    baseView = [[BaseViewController alloc] init];
    [baseView initView:self];

    duration = 0.5f;
    translation = 75;

    [baseView addLineHeight:1.4 Label:self.informationLabel];

    [self.validateButton initButton];

    nbDayTime = 14;
    labelWidth = self.view.bounds.size.width / 4;
    indexDay = 7;
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
        [label setFont:[UIFont fontWithName:@"MaisonNeue-Book" size:55]];
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
    [self animatedView:self.titleLabel Duration:0 Delay:0 Alpha:0 Translaton:translation];
    [self animatedView:self.informationLabel Duration:0 Delay:0 Alpha:0 Translaton:translation];
    [self animatedView:self.validateButton Duration:0 Delay:0 Alpha:0 Translaton:translation];
    [self animatedView:self.dayLabel Duration:0 Delay:0 Alpha:0 Translaton:0];
    [self animatedView:self.dayScrollView Duration:0 Delay:0 Alpha:0 Translaton:0];

    [self animatedView:self.titleLabel Duration:duration Delay:0 Alpha:1 Translaton:0];
    [self animatedView:self.informationLabel Duration:duration Delay:0 Alpha:1 Translaton:0];
    [self animatedView:self.validateButton Duration:duration Delay:0 Alpha:1 Translaton:0];
    [self animatedView:self.dayLabel Duration:duration Delay:duration Alpha:1 Translaton:0];
    [self animatedView:self.dayScrollView Duration:duration Delay:duration Alpha:1 Translaton:0];

    leftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    [leftGesture setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.dayScrollView addGestureRecognizer:leftGesture];

    rightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    [rightGesture setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.dayScrollView addGestureRecognizer:rightGesture];

}

- (void)highlightBorder {

    [[self.validateButton layer] setBorderColor:[[baseView colorWithRGB:26 :26 :26 :1] CGColor]];

}

- (void)unhighlightBorder {

    [[self.validateButton layer] setBorderColor:[[baseView colorWithRGB:157 :157 :157 :1] CGColor]];
    
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
        
    } completion:nil];

}

- (void)animatedView:(UIView *)view Duration:(float)duration Delay:(float)delay Alpha:(float)alpha Translaton:(int)translation{

    [UIView animateWithDuration:duration delay:delay options:0 animations:^{

        [view setAlpha:alpha];
        [view setTransform:CGAffineTransformMakeTranslation(translation, 0)];

    } completion:nil];
    
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{

    return YES;

}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];

}


- (IBAction)validateAction:(id)sender {

    [self updateDateExperience];

}

- (void)updateDateExperience {

    NSDate *now = [[NSDate alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *endDate = [now dateByAddingTimeInterval:+(1. * (indexDay + 1) * 86400)];
    NSString *endDateString = [dateFormat stringFromDate:endDate];

    NSString *urlString = [[ApiController sharedInstance] getUrlExperienceDate];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"startDate": [[ApiController sharedInstance] getDate],
                                 @"endDate": endDateString
                                 };
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary *dictionary = responseObject[@"user"];
        [[ApiController sharedInstance] setUserLoad:dictionary];

        [self animatedView:self.titleLabel Duration:duration Delay:0 Alpha:0 Translaton:0];
        [self animatedView:self.informationLabel Duration:duration Delay:0 Alpha:0 Translaton:0];
        [self animatedView:self.validateButton Duration:duration Delay:0 Alpha:0 Translaton:0];
        [self animatedView:self.dayLabel Duration:duration Delay:0 Alpha:0 Translaton:0];
        [self animatedView:self.dayScrollView Duration:duration Delay:0 Alpha:0 Translaton:0];

        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * 2 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

            [self performSegueWithIdentifier:@"time_data" sender:self];
            
        });

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        NSLog(@"%@", error);
        [self performSelector:@selector(updateDateExperience) withObject:nil afterDelay:5];
        
    }];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"time_data"]) {
        DataViewController *viewController = [segue destinationViewController];
        viewController.experience = [ApiController sharedInstance].experience;
    }

}

@end
