//
//  TnTTipViewController.m
//  TipsAndTricksCFNetwork
//
//  Created by Vivek Pandya on 6/1/14.
//  Copyright (c) 2014 Vivek Pandya. All rights reserved.
//

#import "TnTTipViewController.h"
#import "SGKeychain.h"
#import "User.h"
#import "TipsandTricks.h"

@interface TnTTipViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tipTitle;
@property (weak, nonatomic) IBOutlet UITextField *tipLastUpdate;
@property (weak, nonatomic) IBOutlet UIWebView *tipBody;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TnTTipViewController

//table view section index
#define TAG_SECTION 0
#define DELTE_SECTION 1



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
  
    if (self.tip) {
        self.tipTitle.text = [self.tip objectForKey:@"title"];
        self.tipLastUpdate.text = [self.tip objectForKey:@"changed"];
        [self.tipBody loadHTMLString:[self.tip objectForKey:@"body"] baseURL:nil];
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        
    }
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

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;

}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *title;
    
    switch (section) {
        case TAG_SECTION:
            title = @"Tag";
            break;
        case DELTE_SECTION:{
            if (self.editing) {
                title = @"Delte Tip";
            }
            
            break;
        }
        default:
            break;
    }

    return title;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    
    switch (section) {
        case TAG_SECTION:
            row = 1;
            break;
       case DELTE_SECTION:
        {
            if (self.editing) {
                row =1;
            }
            break;
        }
         
        
        default:
            break;
    }

    return row;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case TAG_SECTION:
            cell = [tableView dequeueReusableCellWithIdentifier:@"tag" forIndexPath:indexPath];
            cell.textLabel.text = [self.tip objectForKey:@"tag"];
            break;
        case DELTE_SECTION:
        {
            if (self.editing) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"delete" forIndexPath:indexPath];
                UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                deleteButton.frame = CGRectMake(0.0, 0.0, 100.0, 40.0);
                [deleteButton setTitle:@"Delete Tip" forState:UIControlStateNormal];
                [deleteButton addTarget:self action:@selector(deleteNode:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:deleteButton];
            }
            break;
        }
       
            default:
            break;
    
    }
    
    return cell;

}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{

    [super setEditing:editing animated:animated];
    [self.tableView reloadData];
    
}


- (IBAction)deleteNode:(id)sender {
    
    User *user = [User sharedInstance];
    
    NSMutableURLRequest *deleteRequest  = [[NSMutableURLRequest alloc]initWithURL:[TipsandTricks createURLForNodeID:[self.tip objectForKey:@"nid"]]];
    
    [deleteRequest setHTTPMethod:@"DELETE"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    [config setHTTPAdditionalHeaders:@{@"Authorization":user.basicAuthString}];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *deleteTask = [session dataTaskWithRequest:deleteRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        if (!error) {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            
            if (httpResponse.statusCode == 204) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
                
            }
            else if(httpResponse.statusCode == 403){
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    
                    [user clearUserDetails];
                    NSError *deleteCredError;
                    [SGKeychain deletePasswordandUserNameForServiceName:@"Drupal 8" accessGroup:nil error:&deleteCredError];
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error while deleting node" message:@"access forbidden" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    
                    self.navigationItem.rightBarButtonItem = nil;
                    [self.navigationItem setHidesBackButton:NO animated:YES];
                   
                    
                    
                    
                });
                
            }
            else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error while deleting node" message:[NSString stringWithFormat:@"%ld",(long)httpResponse.statusCode] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    
                });
                
                
                
            }
            
        }
        else {
            NSLog(@"delete failed due to %@ ",error.localizedDescription);
            
        }
        
        
    }];
    
    [deleteTask resume];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
    
    
}

@end
