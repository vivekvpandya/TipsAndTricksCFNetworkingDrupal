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

    NSString *baseURlString = [NSString stringWithFormat:@"http://tntfoss-vivekvpandya.rhcloud.com/"]; // You may replace this with base URL for your Drupal site.
    NSURL *baseURL = [NSURL URLWithString:baseURlString];
    
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


@end
