//
//  TnTTableViewController.m
//  TipsAndTricksCFNetwork
//
//  Created by Vivek Pandya on 4/30/14.
//  Copyright (c) 2014 Vivek Pandya. All rights reserved.
//

#import "TnTTableViewController.h"

@interface TnTTableViewController ()

@property (nonatomic,strong) NSURLSession *session;
@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,strong) NSArray *creationDateTime;



@end

@implementation TnTTableViewController

-(IBAction)getData{
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost/drupal8/rest/drupalTips"]];
    
    if (self.session){
        
        
        dispatch_queue_t fatchQ = dispatch_queue_create("fetch queue", NULL);
        dispatch_async(fatchQ, ^{
            
            NSURLSessionDataTask *getRequestTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:NULL];
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.titles = [dataDic valueForKey:@"title"];
                    self.creationDateTime = [dataDic valueForKey:@"created"];
                    
                    [self.refreshControl endRefreshing];
                });
                
            }];
            
            [getRequestTask resume];
            
        });
        
        
      
        
        
    }
    else{
        NSLog(@"I'm not getting Session object");
        
    }
    

}

-(void)setTitles:(NSArray *)titles{

    _titles = titles;
    [self.tableView reloadData];
}



-(NSURLSession *)session{
    if (!_session) {
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
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
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(self.tabBarController.tabBar.frame), 0.0f);
    
    [self getData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
   
    return [self.titles count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Drupal List Cell" forIndexPath:indexPath];
    
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
