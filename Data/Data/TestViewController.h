//
//  TestViewController.h
//  Data
//
//  Created by kevin Budain on 11/06/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoaderView.h"
#import "LoaderImageView.h"

@interface TestViewController : UIViewController

@property (weak, nonatomic) IBOutlet LoaderView *loaderView;
@property (weak, nonatomic) IBOutlet LoaderImageView *loaderImageView;

@end
