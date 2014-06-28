//
//  TnTAppDelegate.m
//  TipsAndTricksCFNetwork
//
//  Created by Vivek Pandya on 4/30/14.
//  Copyright (c) 2014 Vivek Pandya. All rights reserved.
//

#import "TnTAppDelegate.h"
#import "User.h"
#import "SGKeychain.h"
#import "TipsandTricks.h"

@implementation TnTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
  
    
    
    
    
    
    // Fetch the credentials if already there in keychain with service name "Drupal 8"
    
    
    NSError *fetchPasswordError = nil;
    
    NSArray *credentials = [SGKeychain usernamePasswordForServiceName:@"Drupal 8" accessGroup:nil error:&fetchPasswordError];
    if (credentials != nil ) {
        
        dispatch_semaphore_t  semaphore = dispatch_semaphore_create(0);
        
        
        NSString *basicAuthString = [TipsandTricks basicAuthStringforUsername:credentials[0] Password:credentials[1]];
        
        NSURL *loginRequestURL = [TipsandTricks createURLForPath:@"user/details"];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        [config setHTTPAdditionalHeaders:@{@"Authorization": basicAuthString}];
        
        NSMutableURLRequest *loginRequest = [NSMutableURLRequest requestWithURL:loginRequestURL];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        
        NSURLSessionDataTask *loginTask = [session dataTaskWithRequest:loginRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            
            if (!error) {
                
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                
                if(httpResponse.statusCode == 200) {
                    
                    
                    NSDictionary *retrievedJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    NSMutableDictionary *userDictionary = [retrievedJSON mutableCopy];
                    [userDictionary setObject:basicAuthString forKey:@"basicAuthString"];
                    User *user = [User sharedInstance];
                    [user fillUserWithUserJSONObject:userDictionary];
                    
                    
                    
                    
                }
                else if(httpResponse.statusCode == 403 ){
                    
                    // this is the case when user has changed credential details form the iste it self
                    NSError *deleteError;
                    [SGKeychain deletePasswordandUserNameForServiceName:@"Drupal 8" accessGroup:nil error:&deleteError];
                    
                    
                    
                    
                }
                
                
            }
            else{
                
                
                NSLog(@"error -> %@",error.localizedDescription);
                
                
            }
            
            
            dispatch_semaphore_signal(semaphore);
            
        }];
        
        [loginTask resume];
        

        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        
        
    }
    
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
