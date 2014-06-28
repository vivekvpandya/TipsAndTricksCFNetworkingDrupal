//
//  LoginOperation.m
//  TipsAndTricksCFNetwork
//
//  Created by Vivek Pandya on 6/22/14.
//  Copyright (c) 2014 Vivek Pandya. All rights reserved.
//

#import "LoginOperation.h"
#import "TipsandTricks.h"

@implementation LoginOperation

-(void)main{


    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc]initWithURL:[TipsandTricks createURLForPath:@"fossTips/rest"]];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *fetchData = [session dataTaskWithRequest:URLRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        
        
        NSError *JSONError  = [[NSError alloc]init];
        NSArray *retrivedJSONObjectArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&JSONError];
        
        NSLog(@"%@",retrivedJSONObjectArray[1]);
        
        
    }];
    
    NSLog(@"Login First");
    
    [fetchData resume];

}

@end
