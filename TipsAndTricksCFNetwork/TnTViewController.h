//
//  TnTViewController.h
//  TipsAndTricksCFNetwork
//
//  Created by Vivek Pandya on 5/3/14.
//  Copyright (c) 2014 Vivek Pandya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TnTViewController : UIViewController

@property (nonatomic,strong) NSDictionary *tip;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UIWebView *bodyWebView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *networkActivityIndicator;

@end
