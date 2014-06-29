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
#import "TnTEditandNewTipViewController.h"

@interface TnTTipViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tipTitle;
@property (weak, nonatomic) IBOutlet UITextField *tipLastUpdate;
@property (weak, nonatomic) IBOutlet UIWebView *tipBody;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *editorSwitch;
@property (weak, nonatomic) IBOutlet UITextView *tipTextView;
@property (strong,nonatomic) NSDictionary *tagValueToUpdate;

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

        self.tipTitle.text = [self.tip valueForKeyPath:@"title"];
        self.tipLastUpdate.text = [self.tip valueForKeyPath:@"changed"];
        [self.tipBody loadHTMLString:[self.tip valueForKeyPath:@"body"] baseURL:nil];
        self.editorSwitch.hidden = YES;
        self.tipTextView.hidden = YES;
        self.tipTextView.text = [self.tip valueForKeyPath:@"body"];
        
        
        
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{

    User *user = [User sharedInstance];
    BOOL isAdmin = NO;
    if (user.roles) {
        for( id role in user.roles)
        {
            if ([role isEqualToString:@"administrator"]) {
             
                isAdmin = YES;
            }
            
            
        }
    }
    
    
    if (isAdmin) {
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }
    else{
        self.navigationItem.rightBarButtonItem = nil;
        //self.editing = NO;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"editModal"]) {
     
        TnTEditandNewTipViewController *editVc = (TnTEditandNewTipViewController *)segue.destinationViewController;
        editVc.tip = [self.tip  mutableCopy];
        
      
        
        
    }
    if ([segue.identifier isEqualToString:@"editTag"]) {
        TnTSelectTagViewController *tagVC = (TnTSelectTagViewController *)segue.destinationViewController;
        tagVC.delegate = self;
        
          //  tagVC.selectedValue = [self.tagValueToUpdate objectForKey:@"term"];

        NSString *tagID = [NSString string];
        
        NSString *tagString = [self.tip valueForKeyPath:@"tag"];
        
        if ([tagString isEqualToString:@"Linux"]) {
            tagID = @"1";
        }
        else{
            tagID = @"2";
        }
        
        tagVC.selectedValue = @{@"name":[self.tip valueForKeyPath:@"tag"],@"tid":tagID};
        
        
        
    }
    
}


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
            cell.detailTextLabel.text = [self.tip valueForKeyPath:@"tag"];
            if (self.editing) {
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
               
            }
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
    self.editorSwitch.hidden = NO;
     [self.editorSwitch setSelectedSegmentIndex:1];
    self.tipTextView.hidden = NO;
    self.tipTitle.enabled = YES;
    
    [self.tableView reloadData];
    
    if (!self.editing) {
        
        [self.editorSwitch setSelectedSegmentIndex:2];
        self.editorSwitch.hidden = YES;
        self.tipTextView.hidden = YES;
        self.tipTitle.enabled = NO;
        
        [self.tableView reloadData];
      
        
        // PATCH tip code  will go here
        NSString *tagID = [NSString string];
        
        
            NSString *tagString = [self.tip valueForKeyPath:@"tag"];
            if ([tagString isEqualToString:@"Linux"]) {
                tagID = @"1";
            }
            else if ([tagString isEqualToString:@"Drupal"])
            {
            tagID = @"2";
            }
            else{
                tagID =@"1"; // Default tag is "Linux" as we can not leave this field empty
            }
            
        
        
        NSDictionary *tipDictionary = @{@"_links": @{@"type":@{@"href":@"http://tntfoss-vivekvpandya.rhcloud.com/rest/type/node/tip" }},@"field_tag":@[@{@"target_id":tagID}],@"body":@[@{@"value":[self.tipTextView.textStorage mutableString],@"format":@"full_html"}],@"title":@[@{@"value":self.tipTitle.text}]};
        
        
        
        
        NSError *conversionerror;
        NSData *jsonData =  [NSJSONSerialization dataWithJSONObject:tipDictionary options:kNilOptions error:&conversionerror];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSMutableURLRequest *postRequestURL = [NSMutableURLRequest requestWithURL:[TipsandTricks createURLForNodeID:[self.tip valueForKeyPath:@"nid"]]];
        [postRequestURL setHTTPMethod:@"PATCH"];
        [postRequestURL setHTTPBody:jsonData];
        
        User *user = [User sharedInstance];
        
        if (user.basicAuthString) {
            [config setHTTPAdditionalHeaders:@{@"Authorization":user.basicAuthString,@"Content-Type":@"application/hal+json"}];
        }
        
        NSURLSession *session  = [NSURLSession sessionWithConfiguration:config];
        
        NSURLSessionDataTask *patchTask = [session dataTaskWithRequest:postRequestURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if(!error){
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                if (httpResponse.statusCode == 204) {
                    NSLog(@"Updated");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    });
                    
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                       
                        NSLog(@"%ld",(long)httpResponse.statusCode);
                        NSDictionary *errorDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:NULL];
                        NSLog(@"%@",errorDictionary);
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error While Update" message:[NSString stringWithFormat:@"%ld",(long)httpResponse.statusCode ]delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                        alert.tag = 2;
                        [alert show];
                        
                        
                    });
                    
                }
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error While Update" message:error.localizedDescription delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                    [alertView show];
                    alertView.tag = 3;
                  
                    
                });
                
            
            }
        }];
        
        
        
        
        
        [patchTask resume];
        

        

        
    }
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{

    if (self.editing) {
        return YES;
    }
    else{
    
        return NO;
    }
}
- (IBAction)changeEditMode:(id)sender {
    
    
    UISegmentedControl *segmentedController = (UISegmentedControl *)sender;
    
    NSInteger index  = segmentedController.selectedSegmentIndex;
    
    if (index == 0) {
       
        self.tipTextView.hidden = YES;
        
        [self.tipBody loadHTMLString:self.tipTextView.textStorage.mutableString baseURL:nil];
    }
    if (index == 1) {
        self.tipTextView.hidden = NO;
        
    }
    
}

-(UIView *)inputAccessoryView{
    
    CGRect accessFrame = CGRectMake(0.0,0.0,100.0,40.0);
    UIView *inputAccessoryView = [[UIView alloc]initWithFrame:accessFrame];
    inputAccessoryView.backgroundColor = [UIColor blackColor];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    doneButton.frame = CGRectMake(0.0,0.0,50.0,40.0);
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    // [doneButton addTarget:self action:@selector(hideKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [doneButton addTarget:self action:@selector(hideKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [inputAccessoryView addSubview:doneButton];
    UIButton *boldButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    boldButton.frame = CGRectMake(50.0, 0.0,30.0, 40.0);
    
    [boldButton setTitle:@"B" forState:UIControlStateNormal];
    [boldButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [boldButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [boldButton addTarget:self action:@selector(boldText:) forControlEvents:UIControlEventTouchUpInside];
    [inputAccessoryView addSubview:boldButton];
    
    UIButton *italicButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    italicButton.frame = CGRectMake(80.0, 0.0, 30.0, 40.0);
    [italicButton setTitle:@"I" forState:UIControlStateNormal];
    [italicButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [italicButton addTarget:self action:@selector(italicText:) forControlEvents:UIControlEventTouchUpInside];
    [inputAccessoryView addSubview:italicButton];
    
    UIButton *underlineButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    underlineButton.frame = CGRectMake(110.0, 0.0, 30.0, 40.0);
    [underlineButton setTitle:@"U" forState:UIControlStateNormal];
    [underlineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [underlineButton addTarget:self action:@selector(underLineText:) forControlEvents:UIControlEventTouchUpInside];
    [inputAccessoryView addSubview:underlineButton];
    
    UIButton *strikeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    strikeButton.frame = CGRectMake(140.0, 0.0, 30.0, 40.0);
    [strikeButton setTitle:@"≁" forState:UIControlStateNormal];
    [strikeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [strikeButton addTarget:self action:@selector(strikeText:) forControlEvents:UIControlEventTouchUpInside];
    [inputAccessoryView addSubview:strikeButton];
    
    UIButton *blockquoteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    blockquoteButton.frame = CGRectMake(170.0, 0.0, 30.0, 40.0);
    [blockquoteButton setTitle:@"❝" forState:UIControlStateNormal];
    [blockquoteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [blockquoteButton addTarget:self action:@selector(blockquoteText:) forControlEvents:UIControlEventTouchUpInside];
    [inputAccessoryView addSubview:blockquoteButton];
    
    
    UIButton *paragraphButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    paragraphButton.frame = CGRectMake(200.0, 0.0, 30.0, 40.0);
    [paragraphButton setTitle:@"¶" forState:UIControlStateNormal];
    [paragraphButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [paragraphButton addTarget:self action:@selector(paragraphText:) forControlEvents:UIControlEventTouchUpInside];
    [inputAccessoryView addSubview:paragraphButton];
    
    UIButton *linkButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    linkButton.frame = CGRectMake(230.0, 0.0, 30.0, 40.0);
    [linkButton setTitle:@"🔗" forState:UIControlStateNormal];
    [linkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [linkButton addTarget:self action:@selector(addLink) forControlEvents:UIControlEventTouchUpInside];
    [inputAccessoryView addSubview:linkButton];
    
    UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    imageButton.frame = CGRectMake(260.0, 0.0, 30.0, 40.0);
    [imageButton setTitle:@"🌈" forState:UIControlStateNormal];
    [imageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [imageButton addTarget:self action:@selector(uploadImage) forControlEvents:UIControlEventTouchUpInside];
    [inputAccessoryView addSubview:imageButton];
    
    
    return inputAccessoryView;
    
    
}
-(void)insertHtmlTag:(NSString *)tag sender:(UIButton *)sender{
    
    NSString *startTag = [NSString stringWithFormat:@"<%@>",tag];
    NSString *endTag = [NSString stringWithFormat:@"</%@>",tag];
    
    
    NSRange selectedRange = [_tipTextView selectedRange];
    if (selectedRange.location != NSNotFound && selectedRange.length != 0) {
        
        [_tipTextView.textStorage.mutableString insertString:startTag atIndex:selectedRange.location];
        [_tipTextView.textStorage.mutableString insertString:endTag atIndex:(selectedRange.location + selectedRange.length + [startTag length])];
        _tipTextView.selectedRange = NSMakeRange([_tipTextView.textStorage.mutableString length], 0);
        
    }
    else{
        
        if (sender.selected) {
            
            [_tipTextView.textStorage.mutableString insertString:endTag atIndex:selectedRange.location];
            _tipTextView.selectedRange = NSMakeRange((selectedRange.location + [endTag length]), 0);
        }
        else
        {
            [_tipTextView.textStorage.mutableString insertString:startTag atIndex:selectedRange.location];
            _tipTextView.selectedRange = NSMakeRange((selectedRange.location + [startTag length]), 0);
        }
        sender.selected = !sender.selected;
        
        
    }
    
    
}

-(void)paragraphText:(UIButton *)sender{
    
    
    [self insertHtmlTag:@"p" sender:sender];
    
}
-(void)hideKeyBoard{
    
    [_tipTextView resignFirstResponder];
    [_tipTitle resignFirstResponder];
}

-(void)boldText:(UIButton *)sender{
    [self insertHtmlTag:@"b" sender:sender];
    
}

-(void)italicText:(UIButton *)sender{
    [self insertHtmlTag:@"em" sender:sender];
    
}

-(void)underLineText:(UIButton *)sender{
    [self insertHtmlTag:@"u" sender:sender];
    
}
-(void)strikeText:(UIButton *)sender{
    [self insertHtmlTag:@"strike" sender:sender];
}
-(void)blockquoteText:(UIButton *)sender{
    
    [self insertHtmlTag:@"blockquote" sender:sender];
}

-(void)addLink{
    
    UIAlertView *addLinkAlert = [[UIAlertView alloc]initWithTitle:@"Enter URL for link here" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    [addLinkAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [addLinkAlert show];
    addLinkAlert.tag = 1;
    
    
}

#pragma mark UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 1) {
        
        // cancel button will have index 0
        if (buttonIndex == 1) {
            
            
            NSRange selectedRange = [_tipTextView selectedRange];
            
            if (selectedRange.location != NSNotFound && selectedRange.length != 0) {
                
                NSString *linkString = [NSString stringWithFormat:@"<a href='%@'>",[alertView textFieldAtIndex:0].text];
                
                [_tipTextView.textStorage.mutableString insertString:linkString atIndex:selectedRange.location];
                [_tipTextView.textStorage.mutableString insertString:@"</a>" atIndex:(selectedRange.location + selectedRange.length + [linkString length])];
                _tipTextView.selectedRange = NSMakeRange([_tipTextView.textStorage.mutableString length], 0);
                
            }
            else{
                
                NSString *linkString = [NSString stringWithFormat:@"<a href='%@'>%@</a>",[alertView textFieldAtIndex:0].text ,[alertView textFieldAtIndex:0].text ];
                
                [_tipTextView.textStorage.mutableString insertString:linkString atIndex:selectedRange.location];
                
                
            }
            
        }
    }
    
    switch (alertView.tag) {
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        {
            NSLog(@"alert");
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
    
    
}

-(BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView{
    
    if ([alertView textFieldAtIndex:0]) {
        if ([alertView textFieldAtIndex:0].text.length > 0) {
            return YES;
            
        }
        else
            return  NO;
    }
    else{
        return NO;
    }
    
}


- (IBAction)deleteNode:(id)sender {
    
    User *user = [User sharedInstance];
    
    if (user.basicAuthString) {
       
        NSMutableURLRequest *deleteRequest  = [[NSMutableURLRequest alloc]initWithURL:[TipsandTricks createURLForNodeID:[self.tip valueForKeyPath:@"nid"]]];
        
        [deleteRequest setHTTPMethod:@"DELETE"];
        [deleteRequest setValue:user.basicAuthString forHTTPHeaderField:@"Authorization"];
      

        
        NSURLSession *session = [NSURLSession sharedSession];
        
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
                        
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error while deleting node" message:@"access forbidden" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                        alert.tag =5;
                        [alert show];
                        
                        self.navigationItem.rightBarButtonItem = nil;
                        [self.navigationItem setHidesBackButton:NO animated:YES];
                        
                        
                        
                        
                    });
                    
                }
                else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error while deleting node" message:[NSString stringWithFormat:@"%ld",(long)httpResponse.statusCode] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                        alert.tag = 6;
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
    
    else
    {
    
        UIAlertView *loginAlert = [[UIAlertView alloc]initWithTitle:@"Please Login" message:@"No credential provided" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        loginAlert.tag = 4;
        [loginAlert show];
    }
    
    
}

#pragma mark - TnTSelectTagViewController delegate

-(void)backButtonSelected:(id)object{

    NSDictionary *tag = (NSDictionary *)object;
    
    if (self.editing) {
        
        [self.tip setValue:[tag objectForKey:@"name"] forKeyPath:@"tag"];
        
        [self.tableView reloadData];
        
    }

}

@end
