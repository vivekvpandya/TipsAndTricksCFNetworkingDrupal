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

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@property (weak, nonatomic) IBOutlet UIWebView *bodyWebView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *networkActivityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)deleteNode:(id)sender;

@end
