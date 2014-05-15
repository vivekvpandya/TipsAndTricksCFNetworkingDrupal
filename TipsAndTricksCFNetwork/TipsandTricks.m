//
//  TipsandTricks.m
//  TipsAndTricksCFNetwork
//
//  Created by Vivek Pandya on 5/3/14.
//  Copyright (c) 2014 Vivek Pandya. All rights reserved.
//

#import "TipsandTricks.h"

@implementation TipsandTricks

+(NSURL *)baseURL{

    NSString *baseURLString = [NSString stringWithFormat:@"http://tntfoss-vivekvpandya.rhcloud.com/"]; // You may replace this with base URL for your Drupal site. */
    /*NSString *baseURLString = [NSString stringWithFormat:@"http://localhost/dr8a11/"]; */
    
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    
    return baseURL;
}

+(NSURL *)createURLForPath:(NSString *)path{

    NSURL *baseURL = [self baseURL];
    NSURL *urlForPath = [baseURL URLByAppendingPathComponent:path]; // here base URL needs trailing slash
    return urlForPath;

}

+(NSURL *)createURLForNodeID:(NSInteger)nid{

    NSURL *baseURL = [self baseURL];
    NSString *stringForNid = [NSString stringWithFormat:@"node/%zd",nid]; // as REST service on Drupal 8 alpha 10 requires "entity" word in the URL
    NSURL *urlForNodeID = [baseURL URLByAppendingPathComponent:stringForNid];
    
    return urlForNodeID;
    
    

}

+(NSString *)basicAuthStringforUsername:(NSString *)username Password:(NSString *)password{
    
    NSString * userNamePasswordString = [NSString stringWithFormat:@"%@:%@",username,password]; // "username:password"
    NSData *userNamePasswordData = [userNamePasswordString dataUsingEncoding:NSUTF8StringEncoding]; // NSData object for base64encoding
    NSString *base64encodedDataString = [userNamePasswordData base64EncodedStringWithOptions:0]; // this will be something like "3n42hbwer34+="
    
    
    NSString * basicAuthString = [NSString stringWithFormat:@"Basic %@",base64encodedDataString]; // example set "Authorization header "Basic 3cv%54F0-34="
    
    return  basicAuthString;

}

@end
