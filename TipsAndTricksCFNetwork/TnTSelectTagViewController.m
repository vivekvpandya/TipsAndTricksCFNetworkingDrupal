//
//  TnTSelectTagViewController.m
//  TipsAndTricksCFNetwork
//
//  Created by Vivek Pandya on 6/3/14.
//  Copyright (c) 2014 Vivek Pandya. All rights reserved.
//

#import "TnTSelectTagViewController.h"


@interface TnTSelectTagViewController ()

@property (nonatomic,strong) NSArray *tags; // Actually you should load all related taxonomy terms here from your site but currently Drupal 8 has no REST api for that
@property (strong, nonatomic) IBOutlet UITableView *tableView;



@end

@implementation TnTSelectTagViewController

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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];

    NSLog(@"%@ --- ",self.selectedValue);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)tags{

    if(!_tags){
        _tags = @[@"Drupal",@"Linux"];
    
    }

    return _tags;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tags count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"tagValue" forIndexPath:indexPath];
    cell.textLabel.text = [self.tags objectAtIndex:indexPath.row];
    
    if (self.selectedValue) {
        if ([cell.textLabel.text isEqualToString:self.selectedValue]) {
            [cell
             setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
    }
    return cell;

}


#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.selectedValue != nil) {
        NSInteger index = [self.tags indexOfObject:self.selectedValue];
        NSIndexPath *selecationIndexPath = [NSIndexPath indexPathForRow:index
                                                              inSection:0];
        [[tableView cellForRowAtIndexPath:selecationIndexPath]setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedValue = [self.tags objectAtIndex:indexPath.row];
    [self.delegate backButtonSelected:self.selectedValue];
    

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
