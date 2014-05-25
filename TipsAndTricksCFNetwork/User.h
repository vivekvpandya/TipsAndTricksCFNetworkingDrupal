//
//  User.h
//  LoginWithKeyChain
//
//  Created by Vivek Pandya on 5/20/14.
//  Copyright (c) 2014 Vivek Pandya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject 
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSArray *roles;
@property (nonatomic,strong) NSString *basicAuthString;
@property (nonatomic,strong) NSString *uid;


-(void)initializeUserWithUserJSONObject:(NSDictionary *)UserJSONObject;
-(void)clearUserDetails;
//-(BOOL)performLoginWithBasicAuthString:(NSString *)basicAuthString;


+(User *)sharedInstance;


@end
