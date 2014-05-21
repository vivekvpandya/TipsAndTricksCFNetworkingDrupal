//
//  TnTTableViewController.m
//  TipsAndTricksCFNetwork
//
//  Created by Vivek Pandya on 4/30/14.
//  Copyright (c) 2014 Vivek Pandya. All rights reserved.
// This is a TableViewController Class for Drupal Tips.

#import "TnTTableViewController.h"
#import "TnTViewController.h"
#import "TipsandTricks.h"

@interface TnTTableViewController ()

@property (nonatomic,strong) NSURLSession *session; // to hold NSURLSession object
@property (nonatomic,strong) NSArray *tipList; // to hold NSDictionaries that are created with JSON Response and each NSDictionary represent tip object i.e it will contain all the fields which you have enabled from RESTExport for the view



@end

@implementation TnTTableViewController

-(IBAction)getData{
    
    
    // this method creates NSURLRequest for appropriate URL and than create NSURLSessionData task to GET data.
        NSMutableURLRequest *request =  [[NSMutableURLRequest alloc]initWithURL:[TipsandTricks createURLForPath:@"fossTips/rest"]];
    [request setHTTPMethod:@"GET"];
    
    if (self.session){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        // use of GCD and Multithreading so Main Queue will not block untill data is retrieved.
        
        dispatch_queue_t fatchQ = dispatch_queue_create("fetch queue", NULL);
        dispatch_async(fatchQ, ^{
            
            NSURLSessionDataTask *getRequestTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
           
                if (!error && httpResponse.statusCode == 200 ) {
                    
                  
               NSLog(@"%d",httpResponse.statusCode);
                    
                    //Once data is retrieved dispatch back to main queue to adjust UI

            
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSError *JSONError  = [[NSError alloc]init];
                    NSArray *retrivedJSONObjectArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&JSONError];
                    
                    if (retrivedJSONObjectArray == nil) {
                        
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                                       message:@" Unable to download, Try checking network connection "
                                                                      delegate:nil
                                                             cancelButtonTitle:nil
                                                             otherButtonTitles:@"OK", nil];
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                        [alert show];
                    }
                    else{
                    
                        self.tipList = retrivedJSONObjectArray;
                    }
                    
                    // stop UITableViewController's refreshControl animation
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    [self.refreshControl endRefreshing];
                });
                
                }
                else {
                     // dataTask is not complited due to error
                    
                    NSString *errorDescription = [[NSString alloc]init];
                    
                    switch (httpResponse.statusCode) {
                        case 404:
                          errorDescription = @" The requested URL was not found on this server. ";
                            break;
                        case 0:
                            errorDescription = @"Could not get any response, It seems could not connect to the sever. ";
                            break;
                        default:
                            break;
                    }
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                    
                        // provide user a alert about error
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                        [self.refreshControl endRefreshing];
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                                       message:errorDescription
                                                                      delegate:nil
                                                             cancelButtonTitle:nil
                                                             otherButtonTitles:@"OK", nil];
                        [alert show];
                    
                    });
                   
                
            }
                
            }];
            
            // Very Very important to resume NSURLSessionTask because by defalut it is suspended.

            [getRequestTask resume];
            
        });
        
        
      
        
        
    }
    else{
        NSLog(@"I'm not getting Session object");
        
    }
    

}

-(void)setTipList:(NSArray *)tipList{

    _tipList = tipList;
    [self.tableView reloadData];


}

-(NSURLSession *)session{
    if (!_session) {
        //creating session object if not exist.
        // To configure session object use NSURLSessionConfiguration , ephemeralSessionConfiguration is very basic configuration object.

        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        [config setHTTPAdditionalHeaders:@{@"Accept":@"application/json"}];
        _session = [NSURLSession sessionWithConfiguration:config];
        
    
        
    }

    return _session;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
       // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
  
    [self getData];

    
   }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
   
    return [self.tipList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"push" forIndexPath:indexPath];
    
    cell.textLabel.text = [[self.tipList objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.detailTextLabel.text = [[self.tipList objectAtIndex:indexPath.row] objectForKey:@"created"];
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"basicAuthString"] != nil ) {
        
        return YES;
        
    }
    else{
        return NO;
    }
    
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
 */
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        
        if ([segue.destinationViewController isKindOfClass:[TnTViewController class]]) {
            
            if ([segue.identifier isEqualToString:@"push"]) {
                
                TnTViewController *newVC = (TnTViewController *)segue.destinationViewController;
                newVC.tip = [self.tipList objectAtIndex:[self.tableView indexPathForCell:sender].row];
                
            }
        }
    }
    
    
}


@end
