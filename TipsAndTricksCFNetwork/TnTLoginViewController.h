//
//  TnTLoginViewController.h
//  TipsAndTricksCFNetwork
//
//  Created by Vivek Pandya on 5/15/14.
//  Copyright (c) 2014 Vivek Pandya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TnTLoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)performLogin:(id)sender;

- (IBAction)cancelLogin:(id)sender;
@end
