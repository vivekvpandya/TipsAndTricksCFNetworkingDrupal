//
//  TnTUserDetailsViewController.m
//  TipsAndTricksCFNetwork
//
//  Created by Vivek Pandya on 5/15/14.
//  Copyright (c) 2014 Vivek Pandya. All rights reserved.
//

#import "TnTUserDetailsViewController.h"

@interface TnTUserDetailsViewController ()

@end

@implementation TnTUserDetailsViewController

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



- (IBAction)logout:(id)sender {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:@"basicAuthString"];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
