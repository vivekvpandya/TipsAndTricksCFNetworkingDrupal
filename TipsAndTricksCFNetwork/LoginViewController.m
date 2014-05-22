//
//  LoginViewController.m
//  LoginWithKeyChain
//
//  Created by Vivek Pandya on 5/20/14.
//  Copyright (c) 2014 Vivek Pandya. All rights reserved.
//

#import "LoginViewController.h"
#import "SGKeychain.h"
#import "User.h"
@interface LoginViewController ()

@property (nonatomic,strong) NSURLSession *session;


@end

@implementation LoginViewController 

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
    self.navigationItem.title = @"Login to tntfoss";
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
- (IBAction)login:(id)sender {
    
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    [self.activityIndicator startAnimating];
    
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *userpassString = [NSString stringWithFormat:@"%@:%@",username,password];
    NSData *userpassData = [userpassString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *base64CredString = [userpassData base64EncodedStringWithOptions:0];
    NSString *basicAuthString = [NSString stringWithFormat:@"Basic %@",base64CredString];
    
    __block NSMutableDictionary *userDictionary = nil;
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    [config setHTTPAdditionalHeaders:@{@"Authorization":basicAuthString}];
    
    self.session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://tntfoss-vivekvpandya.rhcloud.com/user/details"]];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
     
   dispatch_queue_t queue = dispatch_queue_create("queue", NULL);
        dispatch_async(queue, ^{
            
            
            if (!error) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                
                if (httpResponse.statusCode == 200) {
                    
                    NSDictionary *retrievedJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    dispatch_async(dispatch_get_main_queue(), ^{

                        userDictionary = [retrievedJSON mutableCopy];
                        [userDictionary addEntriesFromDictionary:@{@"basicAuthString": basicAuthString}];
                        NSError *setPasswordError = nil;
                        [SGKeychain setPassword:password username:username serviceName:@"Drupal 8" accessGroup:nil updateExisting:YES error:&setPasswordError];
                        
                        if (userDictionary != nil) {
                           // NSLog(@"userDictionary %@", userDictionary );
                            User *user = [User sharedInstance];
                            [user initializeUserWithUserJSONObject:userDictionary];
                            
                        }
                        
                        
                        [self.activityIndicator stopAnimating];
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
                        
                        // remove login view from stack and add userDetails view to stack
                        [self.navigationController setViewControllers:[NSArray arrayWithObject:[storyboard instantiateViewControllerWithIdentifier:@"userDetails"]] animated:YES];
                        

                        
                    });
                    
                }
                
                
                else{
                    [self.activityIndicator stopAnimating];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error while login" message:[NSString stringWithFormat:@"%ld",(long)httpResponse.statusCode] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
           
            }
            else{
            
                [self.activityIndicator stopAnimating];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error while login" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            
            }

        });
        
            }];
    
    [dataTask resume];
    
    
    
    
}

- (IBAction)hideKeyBoard:(UITapGestureRecognizer *)sender {
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}



@end
