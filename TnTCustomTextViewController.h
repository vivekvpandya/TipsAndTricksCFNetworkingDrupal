//
//  TnTCustomTextViewController.h
//  TipsAndTricksCFNetwork
//
//  Created by Vivek Pandya on 5/30/14.
//  Copyright (c) 2014 Vivek Pandya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TnTCustomTextViewController : UIViewController <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedSwitch;
- (IBAction)changeView:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *tipTitle;

-(void)loadHTMLString:(NSString *)htmlString;
-(void)loadTextViewWithHTMLString:(NSString *)htmlString;

-(void)addCustomViewinView:(UIView *)targetView;
@end
