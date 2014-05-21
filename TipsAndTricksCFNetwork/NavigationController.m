//
//  NavigationController.m
//  LoginWithKeyChain
//
//  Created by Vivek Pandya on 5/20/14.
//  Copyright (c) 2014 Vivek Pandya. All rights reserved.
//

#import "NavigationController.h"
#import "SGKeychain.h"
#import "User.h"
#import "TipsandTricks.h"

@interface NavigationController ()

@end

@implementation NavigationController

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
    NSLog(@"inside of viewdidLoad");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    

    
 /*
    NSError *storePasswordError = nil;
    BOOL passwordSuccessfullyCreated = [SGKeychain setPassword:@"Vivek" username:@"justin" serviceName:@"Twitter" updateExisting:NO error:&storePasswordError];
    
    if (passwordSuccessfullyCreated == YES)
    {
        NSLog(@"Password successfully created");
        [self pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"login"] animated:YES];
    }
    else
    {
        NSLog(@"Password failed to be created with error: %@", storePasswordError);
    }
  */
    
 
    // Fetch the password
 
    
    NSError *fetchPasswordError = nil;
  //  NSError *removeuserpassError = nil;
    NSArray *credentials = [SGKeychain usernamePasswordForServiceName:@"Drupal 8" accessGroup:nil error:&fetchPasswordError];
    if (credentials != nil)
    {
      // NSString *basicAuth = [TipsandTricks basicAuthStringforUsername:[credentials objectAtIndex:0] Password:[credentials objectAtIndex:1]];
       // User *user = [User sharedInstance];
      //BOOL flag =  [user performLoginWithBasicAuthString:basicAuth];
       // if (flag) {
            [self pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"userDetails"] animated:YES];
      /*  }
        else {NSLog(@"credential does not worked");
            [SGKeychain deletePasswordandUserNameForServiceName:@"Drupal 8" accessGroup:nil error:&removeuserpassError];
        }
       */
    }
    
    
    else
    {
        
        [self pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"login"]animated:YES];

        
    }
    
  
    // Delete the password
/*
  NSError *deletePasswordError = nil;
    BOOL passwordSuccessfullyDeleted = [SGKeychain deletePasswordForUsername:@"vivek" serviceName:@"Drupal 8" error:&deletePasswordError];
    if (passwordSuccessfullyDeleted == YES)
    {
        NSLog(@"Password successfully deleted");
    }
    else
    {
        NSLog(@"Failed to delete password: %@", deletePasswordError);
    }

    */
    
 
    
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
