//
//  DataViewController.m
//  Data
//
//  Created by kevin Budain on 30/04/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "DataViewController.h"

@interface DataViewController ()

@end

BaseViewController *baseView;

int nbDay, margin, indexDay = 0, positionTop, heigtViewDetail;
UISwipeGestureRecognizer *leftGesture, *rightGesture, *upGesture;
UITapGestureRecognizer *tapGesture;
float firstScale;
float secondScale;

@implementation DataViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    baseView = [[BaseViewController alloc] init];
    [baseView initView:self];

    for (UIView *subView in self.contentScrollView.subviews)
    {
        [subView removeFromSuperview];
    }

    nbDay = (int)[ApiController sharedInstance].nbDay;
    indexDay = 1;
    margin = 40;
    firstScale = 0.8;
    secondScale = 0.5;
    positionTop = self.view.bounds.size.height * 0.25;
    heigtViewDetail = self.view.bounds.size.height * 0.75;

    /** TIMELINE **/
    [self.timeLineView setBackgroundColor:[UIColor clearColor]];
    [self.timeLineView initTimeLine:nbDay indexDay:indexDay];
    self.timeLineView.alpha = 0;
    [self.timeLineView setHidden:YES];


    [self.contentScrollView setPagingEnabled:YES];
    [self.contentScrollView setContentSize:CGSizeMake(((self.view.bounds.size.width + margin) * nbDay), self.view.bounds.size.height)];
    [self.contentScrollView setBackgroundColor:[UIColor clearColor]];
    [self.contentScrollView setShowsHorizontalScrollIndicator:NO];
    [self.contentScrollView setShowsVerticalScrollIndicator:NO];
    [self.contentScrollView setScrollsToTop:NO];

    for (int i = 0; i < nbDay; i++) {

        DataView *view = [[DataView alloc] init];
        [view setBackgroundColor:[baseView colorWithRGB:243 :243 :243 :1]];
        [view setFrame:CGRectMake((self.view.bounds.size.width + margin) * i, positionTop, self.view.bounds.size.width ,heigtViewDetail )];
        [view initView];
        [view drawData:i];
        [self.contentScrollView addSubview:view];
    }

    CGRect frame = self.contentScrollView.frame;
    frame.origin.x = (self.view.bounds.size.width + margin ) * indexDay;
    [self.contentScrollView scrollRectToVisible:frame animated:YES];

    [self.view sendSubviewToBack:self.contentScrollView];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];

    leftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    [leftGesture setDirection:(UISwipeGestureRecognizerDirectionRight)];

    rightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    [rightGesture setDirection:(UISwipeGestureRecognizerDirectionLeft)];

    upGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
    [upGesture setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [self.view addGestureRecognizer:upGesture];

    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];

}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];

}

-(void)swipeLeft:(UISwipeGestureRecognizer *)recognizer {

    if (indexDay > 0) {

        indexDay--;
        CGRect frame = self.contentScrollView.frame;
        frame.origin.x = (self.view.bounds.size.width + margin ) * secondScale * indexDay;

        [self.contentScrollView scrollRectToVisible:frame animated:YES];
        [self.timeLineView animatedTimeLine:indexDay];

    }
}

- (void)swipeRight:(UISwipeGestureRecognizer *)recognizer {

    if (indexDay < nbDay - 1) {

        indexDay++;
        CGRect frame = self.contentScrollView.frame;
        frame.origin.x = (self.view.bounds.size.width + margin) * secondScale * indexDay;
        [self.contentScrollView scrollRectToVisible:frame animated:YES];
        [self.timeLineView animatedTimeLine:indexDay];

    }

}

-(void)tapGesture:(UITapGestureRecognizer *)tapGestureRecognizer {

    [self.view removeGestureRecognizer:leftGesture];
    [self.view removeGestureRecognizer:rightGesture];
    [self.view removeGestureRecognizer:tapGesture];

    [UIView animateWithDuration:0.5  delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{

        int count = 0;

        for (UIView *view in self.contentScrollView.subviews) {

            CGRect frame;
            frame.origin.x = (self.view.bounds.size.width + margin) * count;
            frame.origin.y = positionTop;
            frame.size.height = heigtViewDetail;
            frame.size.width = self.view.bounds.size.width;
            view.frame = frame;

            for (CAShapeLayer *layer in view.layer.sublayers) {

                [self animateLayer:layer Start:[NSNumber numberWithFloat:secondScale] End:@1 Delay:0];

            }

            for (UIView *subView in view.subviews) {

                CGRect frame;
                frame.origin.x = subView.frame.origin.x / secondScale;
                frame.origin.y = subView.frame.origin.y / secondScale;
                frame.size.height = subView.frame.size.height / secondScale;
                frame.size.width = subView.frame.size.width / secondScale;
                subView.frame = frame;
                
            }

            count++;

        }

        CGRect frame = self.contentScrollView.frame;
        frame.origin.x = (self.view.bounds.size.width + margin) * indexDay;
        [self.contentScrollView scrollRectToVisible:frame animated:NO];

        self.timeLineView.alpha = 0;
        [self.timeLineView setHidden:YES];

    } completion:^(BOOL finished){

        [self.view addGestureRecognizer:upGesture];

    }];

}

- (void)swipeUp:(UISwipeGestureRecognizer *)recognizer {

    [self.view removeGestureRecognizer:upGesture];

    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{

        [self animateView:firstScale ScaleView:firstScale];

        CGRect frame = self.contentScrollView.frame;
        frame.origin.x = (self.view.bounds.size.width + margin) * firstScale * indexDay;
        [self.contentScrollView scrollRectToVisible:frame animated:NO];

    } completion:^(BOOL finished){

        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{

//            [self animateView:secondScale ScaleView:(firstScale * secondScale)];
            int count = 0;
            float base = (self.view.bounds.size.width / 2) - (self.view.bounds.size.width * secondScale / 2);

            for (UIView *view in self.contentScrollView.subviews) {
                CGRect frame;
                frame.origin.x = base + ((((self.view.bounds.size.width + margin) * secondScale)) * count);
                frame.origin.y = self.view.bounds.size.width / 2 ;
                frame.size.height = heigtViewDetail * secondScale;
                frame.size.width = self.view.bounds.size.width * secondScale;
                view.frame = frame;

                for (CAShapeLayer *layer in view.layer.sublayers) {

                    [self animateLayer:layer Start:[NSNumber numberWithFloat:firstScale] End:[NSNumber numberWithFloat:secondScale] Delay:0];

                }

                for (UIView *subView in view.subviews) {

                    CGRect frame;
                    frame.origin.x = subView.frame.origin.x / firstScale * secondScale;
                    frame.origin.y = subView.frame.origin.y / firstScale * secondScale;
                    frame.size.height = subView.frame.size.height / firstScale * secondScale;
                    frame.size.width = subView.frame.size.width / firstScale * secondScale;
                    subView.frame = frame;
                    
                }

                count++;
            }

            CGRect frame = self.contentScrollView.frame;
            frame.origin.x = (self.view.bounds.size.width + margin) * secondScale * indexDay;
            [self.contentScrollView scrollRectToVisible:frame animated:NO];

            [self.timeLineView setHidden:NO];
            self.timeLineView.alpha = 1;

        } completion:^(BOOL finished){

            [self.view addGestureRecognizer:leftGesture];
            [self.view addGestureRecognizer:rightGesture];
            [self.view addGestureRecognizer:tapGesture];

        }];

    }];
    
    
}

- (void)animateView:(float)scaleLayer ScaleView:(float)scaleView {

    int count = 0;
    float base = (self.view.bounds.size.width / 2) - (self.view.bounds.size.width * scaleLayer / 2);

    for (UIView *view in self.contentScrollView.subviews) {
        CGRect frame;
        frame.origin.x =  base + ((((self.view.bounds.size.width + margin) * scaleLayer)) * count);
        frame.origin.y = positionTop ;
        frame.size.height = heigtViewDetail * scaleLayer;
        frame.size.width = self.view.bounds.size.width * scaleLayer;
        view.frame = frame;

        for (CAShapeLayer *layer in view.layer.sublayers) {

            [self animateLayer:layer Start:@1 End:[NSNumber numberWithFloat:scaleLayer] Delay:0];

        }

        for (UIView *subView in view.subviews) {

            CGRect frame;
            frame.origin.x = subView.frame.origin.x * scaleView;
            frame.origin.y = subView.frame.origin.y * scaleView;
            frame.size.height = subView.frame.size.height * scaleView;
            frame.size.width = subView.frame.size.width * scaleView;
            subView.frame = frame;

        }

        count++;
    }


}

- (void)animateLayer:(CAShapeLayer *)layer Start:(NSNumber *)start End:(NSNumber *)end Delay:(float)delay {

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [animation setFromValue:start];
    [animation setToValue:end];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setDuration:0.5];
    [animation setBeginTime:CACurrentMediaTime() + delay];
    [animation setFillMode:kCAFillModeForwards];
    [animation setRemovedOnCompletion:NO];
    [layer addAnimation:animation forKey:@"scale"];

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
}

@end