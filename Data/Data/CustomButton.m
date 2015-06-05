//
//  CustomButton.m
//  Data
//
//  Created by kevin Budain on 05/06/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "CustomButton.h"
#import "BaseViewController.h"

@implementation CustomButton

BaseViewController *baseView;

- (void)initButton {
    [[self layer] setBorderWidth:1.0f];
    [[self layer] setBorderColor:[baseView colorWithRGB:157 :157 :157 :1].CGColor];
    [[self layer] setCornerRadius:25];
    [self addTarget:self action:@selector(unhighlightBorder) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(highlightBorder) forControlEvents:UIControlEventTouchDown];
    [self setClipsToBounds:YES];
}

- (void)highlightBorder {

    [[self layer] setBorderColor:[[baseView colorWithRGB:26 :26 :26 :1] CGColor]];

}

- (void)unhighlightBorder {

    [[self layer] setBorderColor:[[baseView colorWithRGB:157 :157 :157 :1] CGColor]];
    
}

@end
