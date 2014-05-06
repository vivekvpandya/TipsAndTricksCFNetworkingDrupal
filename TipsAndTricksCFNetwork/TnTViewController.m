//
//  TnTViewController.m
//  TipsAndTricksCFNetwork
//
//  Created by Vivek Pandya on 5/3/14.
//  Copyright (c) 2014 Vivek Pandya. All rights reserved.
//

#import "TnTViewController.h"

@interface TnTViewController ()

@end

@implementation TnTViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.tip) {
   
        NSString *titleString = [[NSString alloc]initWithFormat:@"%@",[self.tip objectForKey:@"title"]];
        
        //as per my site configuration all fields are required but it may be the case that still we don't get title or body of tip than we should handle that
        
        // JSON object returns <null> string if any of the filed is empty.
        
        
        if (titleString != nil && ![titleString isEqualToString:@"<null>"]) {
            self.titleLable.text = titleString;
        }
        else{
            
            UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Cound not load tip title or It may be empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];

        
        }
        NSString *bodyHTML = [[NSString alloc]initWithFormat:@"%@",[self.tip objectForKey:@"body"]];
        if (bodyHTML != nil && ![bodyHTML isEqualToString:@"<null>"]) {
            
            [self.bodyWebView loadHTMLString:bodyHTML baseURL:nil];
                    }
        else {
        
            UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Cound not load tip content or It is empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
        }
    }
    else{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Cound not load tip data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
