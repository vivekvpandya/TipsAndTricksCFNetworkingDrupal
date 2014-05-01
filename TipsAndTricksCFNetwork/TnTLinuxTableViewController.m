//
//  TnTLinuxTableViewController.m
//  TipsAndTricksCFNetwork
//
//  Created by Vivek Pandya on 5/1/14.
//  Copyright (c) 2014 Vivek Pandya. All rights reserved.
//  TableViewController Class for Linux Tab


//

#import "TnTLinuxTableViewController.h"

@interface TnTLinuxTableViewController ()

@property (nonatomic,strong) NSURLSession *session; // to hold NSURLSession object
@property (nonatomic,strong) NSArray *titles;  // Titles retrieved form Drupal site
@property (nonatomic,strong) NSArray *creationDateTime; // Creation time retrieved from Drupal site



@end

@implementation TnTLinuxTableViewController

-(IBAction)getData{
    
    
    // this method creates NSURLRequest for appropriate URL and than create NSURLSessionData task to GET data.
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost/drupal8/rest/linuxTips"]];
    
    if (self.session){
        
        
        // use of GCD and Multithreading so Main Queue will not block untill data is retrieved.
        
        dispatch_queue_t fatchQ = dispatch_queue_create("fetch queue", NULL);
        
        dispatch_async(fatchQ, ^{
            
            NSURLSessionDataTask *getRequestTask = [self.session dataTaskWithRequest:request
                                                                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (!error) {
                    
                    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:NULL];
                    
                  //Once data is retrieved dispatch back to main queue to adjust UI
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        self.titles = [dataDic valueForKey:@"title"];
                        self.creationDateTime = [dataDic valueForKey:@"created"];
                        
                       // stop UITableViewController's refreshControl animation
                        [self.refreshControl endRefreshing];
                    });

                }
                
                else {
                    // dataTask is not complited due to error
                
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        // provide user a alert about error
                        
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                                       message:error.localizedDescription
                                                                      delegate:nil
                                                             cancelButtonTitle:@"OK"
                                                             otherButtonTitles: nil];
                        [alert show];
                        
                        [self.refreshControl endRefreshing];
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

-(void)setTitles:(NSArray *)titles{
    
    // self.titles lazy instantiating
    _titles = titles;
    [self.tableView reloadData]; // whenever self.titles is got set than relode the tableview.
}



-(NSURLSession *)session{
    if (!_session) {
        
        //creating session object if not exist.
        // To configure session object use NSURLSessionConfiguration , ephemeralSessionConfiguration is very basic configuration object.
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config];
        
        
        
    }
    
    return _session;
}



-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self getData]; // call to getData 
    
    
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
    
    return [self.titles count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Linux List Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [self.titles objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [self.creationDateTime objectAtIndex:indexPath.row];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
