//
//  DataViewController.h
//  Data
//
//  Created by kevin Budain on 30/04/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeLineView.h"
#import "DataView.h"
#import "BaseViewController.h"

@interface DataViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet TimeLineView *timeLineView;

@end
