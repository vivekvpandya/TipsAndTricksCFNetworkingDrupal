//
//  UserDetailsViewController.m
//  LoginWithKeyChain
//
//  Created by Vivek Pandya on 5/20/14.
//  Copyright (c) 2014 Vivek Pandya. All rights reserved.
//

#import "UserDetailsViewController.h"
#import "SGKeychain.h"
#import "User.h"
#import "TipsandTricks.h"

@interface UserDetailsViewController ()

@end

@implementation UserDetailsViewController

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
    self.navigationItem.title = @"User Details";
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{

    User *user = [User sharedInstance];
    
    if (user.userName == nil) {
        [self.activityIndicator startAnimating];
        
        // app has directly used previous credential from keychain , so check validity of that credential and initialize user
        NSError *fetchCredError = nil;
        
        NSArray *creds = [SGKeychain usernamePasswordForServiceName:@"Drupal 8" accessGroup:nil error:&fetchCredError]; // array with username at 0 and password at 1
        
        NSString *basicAuthString = [TipsandTricks basicAuthStringforUsername:[creds objectAtIndex:0] Password:[creds objectAtIndex:1]];
        NSURL *loginURL = [TipsandTricks createURLForPath:@"user/details"];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:loginURL];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        [config setHTTPAdditionalHeaders:@{@"Authorization": basicAuthString}];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        
        NSURLSessionDataTask *loginTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            
            if (!error) {
                
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                
                if(httpResponse.statusCode == 200) {
                    
                    
                    NSDictionary *retrievedJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    NSMutableDictionary *userDictionary = [retrievedJSON mutableCopy];
                    [userDictionary setObject:basicAuthString forKey:@"basicAuthString"];
                    [user initializeUserWithUserJSONObject:userDictionary];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self setUIwithUserDetails];
                        [self.activityIndicator stopAnimating];
                    });
                    
                    
                }
                else if(httpResponse.statusCode == 403 ){
                    
                   
                    NSError *deleteError;
                    [SGKeychain deletePasswordandUserNameForServiceName:@"Drupal 8" accessGroup:nil error:&deleteError];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error While Login" message:@" 403 access forbidden" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.activityIndicator stopAnimating];
                        [alert show];
                        
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
                        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"login"];
                        
                
                            
                            
                            [self.navigationController setViewControllers:[NSArray arrayWithObject:vc] animated:YES];
                        

                        
                    });

                
                
                }
                
                
            }
            else{
                
                [self.activityIndicator stopAnimating];
                NSLog(@"error -> %@",error.localizedDescription);
                
            
            }
            

            
            
        }];
        
        [loginTask resume];
        
        
        
    }
    else{
    
        //user is already logged in just set UI to display user information.
    
        [self setUIwithUserDetails];
    
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
- (IBAction)logout:(id)sender {
    

    NSError *deleteError = nil;
    

    

    
    BOOL deleteItemFlag = [SGKeychain deletePasswordandUserNameForServiceName:@"Drupal 8" accessGroup:nil error:&deleteError];
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"login"];

    
    if (deleteItemFlag == YES) {
        
        
        [self.navigationController setViewControllers:[NSArray arrayWithObject:vc] animated:YES];
    }
    
}

-(void)setUIwithUserDetails{


    User *user = [User sharedInstance];
    if (user.userName != nil) {
        
        
        self.usernameLabel.text = user.userName;
        
        NSMutableString *roleString = [[NSMutableString alloc]init];
        
        for (id value in user.roles ) {
            [roleString appendString:[NSString stringWithFormat:@"%@ \n",value]];
            
        }
        self.rolesLabel.text = roleString;
    }
    else{
        NSLog(@"can't set UI as user is empty");
    
    }
    

}

@end
