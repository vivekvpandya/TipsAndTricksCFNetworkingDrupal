//
//  TnTViewController.m
//  TipsAndTricksCFNetwork
//
//  Created by Vivek Pandya on 5/3/14.
//  Copyright (c) 2014 Vivek Pandya. All rights reserved.
//

#import "TnTViewController.h"
#import "User.h"
#import "TipsandTricks.h"
#import "SGKeychain.h"
#import "TnTCustomTextViewController.h"

@interface TnTViewController ()

@property (nonatomic,strong) TnTCustomTextViewController *tipView;

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
    self.tipView = [[TnTCustomTextViewController alloc]init];
    [self.tipView addCustomViewinView:self.view];
    
    
    if (self.tip) {
   
        
        NSString *titleString = [[NSString alloc]initWithFormat:@"%@",[self.tip objectForKey:@"title"]];
        
        //as per my site configuration all fields are required but it may be the case that still we don't get title or body of tip than we should handle that
        
        // JSON object returns <null> string if any of the filed is empty.
        
        
        if (titleString != nil && ![titleString isEqualToString:@"<null>"]) {
            self.titleTextField.text = titleString;
            self.titleTextField.enabled = NO;
            [self.tipView setTipTitleWithString:titleString];
            
        }
        else{
            
            UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Cound not load tip title or It may be empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];

        
        }
        NSString *bodyHTML = [[NSString alloc]initWithFormat:@"%@",[self.tip objectForKey:@"body"]];
        if (bodyHTML != nil && ![bodyHTML isEqualToString:@"<null>"]) {
            
            //[self.bodyWebView loadHTMLString:bodyHTML baseURL:nil];
            [self.tipView loadHTMLString:bodyHTML];
            [self.tipView loadTextViewWithHTMLString:bodyHTML];

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


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSString *authorID = [self.tip objectForKey:@"uid"];
    User *user = [User sharedInstance];
    self.deleteButton.hidden = YES;
    
    BOOL editEnable = NO;
    
    
    if (user.name) {
        
        
        if ([authorID isEqualToString:user.uid] ) {
            
            editEnable = YES;
            
            
        }
        else{
            
            for (id role in user.roles) {
                
                if ([role isEqualToString:@"administrator"]) {
                    
                    editEnable = YES;
                    
                }
            }
            
            
        }
    }
    
    
    if (editEnable == YES) {
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem; // toggles between "Edit" and "Done" button item
        

}
    else{
        self.navigationItem.rightBarButtonItem = nil;
        [self.navigationItem setHidesBackButton:NO animated:YES];
        
    }
}


-(void)setEditing:(BOOL)editing animated:(BOOL)animated{


    [super setEditing:editing animated:animated];
    [self.navigationItem setHidesBackButton:editing animated:YES];
    self.titleTextField.enabled = editing;
    self.deleteButton.hidden = NO;
    self.tipView.segmentedSwitch.hidden = NO;
    self.tipView.tipTitle.enabled = YES;
    if (!editing) {
        self.deleteButton.hidden = YES;
        self.tipView.segmentedSwitch.hidden = YES;
     self.tipView.tipTitle.enabled = NO;
    }
    

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




- (IBAction)deleteNode:(id)sender {

    User *user = [User sharedInstance];
    
    NSMutableURLRequest *deleteRequest  = [[NSMutableURLRequest alloc]initWithURL:[TipsandTricks createURLForNodeID:[self.tip objectForKey:@"nid"]]];
    
    [deleteRequest setHTTPMethod:@"DELETE"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    [config setHTTPAdditionalHeaders:@{@"Authorization":user.basicAuthString}];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *deleteTask = [session dataTaskWithRequest:deleteRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        if (!error) {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            
            if (httpResponse.statusCode == 204) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
                
            }
            else if(httpResponse.statusCode == 403){
            
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    
                    [user clearUserDetails];
                    NSError *deleteCredError;
                    [SGKeychain deletePasswordandUserNameForServiceName:@"Drupal 8" accessGroup:nil error:&deleteCredError];
                
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error while deleting node" message:@"access forbidden" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    
                    self.navigationItem.rightBarButtonItem = nil;
                    [self.navigationItem setHidesBackButton:NO animated:YES];
                    self.deleteButton.hidden = YES;
                    
                    
                
                });
                
            }
            else{
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error while deleting node" message:[NSString stringWithFormat:@"%ld",(long)httpResponse.statusCode] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    
                });

                
                
            }
            
        }
        else {
            NSLog(@"delete failed due to %@ ",error.localizedDescription);
        
        }
        
        
    }];
   
    [deleteTask resume];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
                                                                                  
    
    
}
@end
