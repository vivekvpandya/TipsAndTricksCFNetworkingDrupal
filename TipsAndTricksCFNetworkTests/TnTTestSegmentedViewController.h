//
//  TnTTestSegmentedViewController.h
//  TipsAndTricksCFNetwork
//
//  Created by Vivek Pandya on 5/26/14.
//  Copyright (c) 2014 Vivek Pandya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TnTTestSegmentedViewController : UIViewController <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
- (IBAction)changeView:(id)sender;

@end
