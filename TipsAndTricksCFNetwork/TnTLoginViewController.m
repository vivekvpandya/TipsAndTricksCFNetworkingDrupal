//
//  TnTLoginViewController.m
//  TipsAndTricksCFNetwork
//
//  Created by Vivek Pandya on 5/15/14.
//  Copyright (c) 2014 Vivek Pandya. All rights reserved.
//

#import "TnTLoginViewController.h"
#import "TipsandTricks.h"
@interface TnTLoginViewController ()

@property (weak,nonatomic) NSURL * loginServiceURL;
@property (weak,nonatomic) NSURLSessionDataTask *validateUserTask;
@property (weak,nonatomic) NSURLSession *session;
@end

@implementation TnTLoginViewController

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

-(NSURL *)loginServiceURL{

    if (!_loginServiceURL) {
        _loginServiceURL = [TipsandTricks createURLForPath:@"uauth/login"]; // "uauth/login" is custom route created on my site which has access to authenticated user only.
    }
    
    return _loginServiceURL;
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

- (IBAction)performLogin:(id)sender {
    
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    
    if (![self.userName.text isEqualToString:@""]   && ![self.password.text isEqualToString:@""] ) {
        
        
    
    
    NSString *basicAuthString = [TipsandTricks basicAuthStringforUsername:self.userName.text Password:self.password.text];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    [config setHTTPAdditionalHeaders:@{@"Authorization":basicAuthString}]; // set Authorization header for session object
    
  self.session = [NSURLSession sessionWithConfiguration:config];
    
    
    NSMutableURLRequest *validateUserRequest = [NSMutableURLRequest requestWithURL:self.loginServiceURL];
        
    self.validateUserTask = [self.session dataTaskWithRequest:validateUserRequest
                                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                                            if (!error) {
                                                                if (httpResponse.statusCode == 200) {
                                                                    NSLog(@"ok logged in");
                                                                    [[NSUserDefaults standardUserDefaults] setObject:basicAuthString forKey:@"basicAuthString"];
                                                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                                                    [self dismissViewControllerAnimated:YES completion:nil];
                                                                }
                                                                else if (httpResponse.statusCode == 403)
                                                                {
                                                                    UIAlertView *loginAlert = [[UIAlertView alloc]initWithTitle:@"Login Error"
                                                                                                                        message:@"Sorry unrecognized username or password"
                                                                                                                       delegate:nil
                                                                                                              cancelButtonTitle:@"OK"
                                                                                                              otherButtonTitles:nil];
                                                                    [loginAlert show];
                                                                
                                                                }
                                                                else{
                                                                
                                                                    NSLog(@"Status code %d",httpResponse.statusCode);
                                                                
                                                                }
                                                            }
        
    }];
    
    [self.validateUserTask resume];

    }


}

- (IBAction)cancelLogin:(id)sender {
    
    if (self.validateUserTask.state == NSURLSessionTaskStateRunning) {
        [self.validateUserTask cancel];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}


@end
