//
//  DataInformationView.m
//  Data
//
//  Created by kevin Budain on 04/05/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "DataInformationView.h"

@implementation DataInformationView

BaseViewController *baseView;

- (void)init:(float)size {

    baseView = [[BaseViewController alloc] init];
    [baseView initView:baseView];


    UIFont *titleLabelFont = [UIFont fontWithName:@"MaisonNeue-Book" size:15];

    UILabel *photoLabel = [[UILabel alloc] init];
    [photoLabel setText:@"photos"];
    [photoLabel setFont:titleLabelFont];
    [photoLabel sizeToFit];
    [photoLabel setFrame:CGRectMake((self.bounds.size.width / 3 ) - (photoLabel.bounds.size.width / 2),
                                    self.bounds.size.height / 4,
                                    photoLabel.bounds.size.width,
                                    photoLabel.bounds.size.width)];
    [photoLabel setTextColor:[baseView colorWithRGB:29 :29 :27 :1]];
    [photoLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:photoLabel];

    self.photoInformationLabel = [[UILabel alloc] init];
    [self.photoInformationLabel setText:@"photos"];
    [self.photoInformationLabel setFont:titleLabelFont];
    [self.photoInformationLabel sizeToFit];
    [self.photoInformationLabel setFrame:CGRectMake((self.bounds.size.width / 3 ) + (photoLabel.bounds.size.width / 2) + 10,
                                    self.bounds.size.height / 4,
                                    photoLabel.bounds.size.width,
                                    photoLabel.bounds.size.width)];
    [self.photoInformationLabel setTextColor:[baseView colorWithRGB:29 :29 :27 :1]];
    [self.photoInformationLabel setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:self.photoInformationLabel];


}

@end
