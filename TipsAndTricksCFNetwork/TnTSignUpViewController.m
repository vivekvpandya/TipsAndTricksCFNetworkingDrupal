//
//  TnTSignUpViewController.m
//  TipsAndTricksCFNetwork
//
//  Created by Vivek Pandya on 6/15/14.
//  Copyright (c) 2014 Vivek Pandya. All rights reserved.
//

#import "TnTSignUpViewController.h"
#import "TipsandTricks.h"

@interface TnTSignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation TnTSignUpViewController

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
- (IBAction)signup:(id)sender {
    
    NSString *username = [self.usernameField text];
    NSString *email = [self.emailField text];
  
    NSURL *userRESTEndPoint = [TipsandTricks createURLForPath:@"/entity/user"];
    
    
    NSMutableURLRequest *userCreationRequest = [[NSMutableURLRequest alloc]initWithURL:userRESTEndPoint];
    
    [userCreationRequest setHTTPMethod:@"POST"];
   
    
    NSDictionary *requestBodyDictionary = @{
        @"_links":@{
            @"type":@{
                @"href":@"http://tntfoss-vivekvpandya.rhcloud.com/rest/type/user/user"
    		}
        },
        @"name":@[@{@"value":username}],
        @"mail":@[@{@"value":email}]
        
        };
    NSData *requestBodyData  = [NSJSONSerialization dataWithJSONObject:requestBodyDictionary options:kNilOptions error:NULL];
    
    [userCreationRequest setHTTPBody:requestBodyData];
    
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    [config setHTTPAdditionalHeaders:@{@"Content-Type":@"application/hal+json"}];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *POSTUserTask = [session dataTaskWithRequest:userCreationRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        if (!error){
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:NULL];
        NSString *responseString = [NSString stringWithFormat:@"%@",responseData];
        
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (httpResponse.statusCode == 201) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.activityIndicator stopAnimating];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sign Successful" message:@"A mail with further details has been sent to your mail id" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];

            });
            
            
        }
        else if(httpResponse.statusCode == 422) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.activityIndicator stopAnimating];
                
                UIAlertView *alertForUnprocessable = [[UIAlertView alloc]initWithTitle:@"Can not create user" message:responseString delegate:self
                                                                     cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertForUnprocessable show];
            });
            
            
        }
        else{
        
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.activityIndicator stopAnimating];
                
                NSLog(@"%lu",(long)httpResponse.statusCode);
                
                UIAlertView *alertForFaliure = [[UIAlertView alloc]initWithTitle:@"Can not create user" message:responseString delegate:self
                                                               cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                
                [alertForFaliure show];
            });
            
        }
            
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.activityIndicator stopAnimating];
                
                NSLog(@"error");
                UIAlertView *alertForError = [[UIAlertView alloc]initWithTitle:@"Can not create user" message:error.localizedDescription delegate:self
                                                             cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                
                [alertForError show];

                
            });

            
            
        
            
        }
        
        
    }];
    
    [POSTUserTask resume];
    [self.activityIndicator startAnimating];
    
    
    
    
    
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
