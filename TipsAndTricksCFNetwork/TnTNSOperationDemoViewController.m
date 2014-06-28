//
//  TnTNSOperationDemoViewController.m
//  TipsAndTricksCFNetwork
//
//  Created by Vivek Pandya on 6/22/14.
//  Copyright (c) 2014 Vivek Pandya. All rights reserved.
//

#import "TnTNSOperationDemoViewController.h"
#import "RESTFulOperation.h"
#import "LoginOperation.h"

@interface TnTNSOperationDemoViewController ()

@end

@implementation TnTNSOperationDemoViewController

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
    NSOperationQueue *fetchQueue = [NSOperationQueue new];
    RESTFulOperation *fetchOperation = [[RESTFulOperation alloc]init];
    LoginOperation *loginOperation = [[LoginOperation alloc]init];
    [fetchOperation addDependency:loginOperation];
    
    
    [fetchQueue addOperation:fetchOperation];
    [fetchQueue addOperation:loginOperation];
    
    
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

@end
