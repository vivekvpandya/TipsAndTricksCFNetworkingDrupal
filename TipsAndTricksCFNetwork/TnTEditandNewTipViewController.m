//
//  TnTEditandNewTipViewController.m
//  TipsAndTricksCFNetwork
//
//  Created by Vivek Pandya on 6/2/14.
//  Copyright (c) 2014 Vivek Pandya. All rights reserved.
//

#import "TnTEditandNewTipViewController.h"
#import "User.h"

@interface TnTEditandNewTipViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tipTitle;
@property (weak, nonatomic) IBOutlet UISegmentedControl *editorSwitch;
@property (weak, nonatomic) IBOutlet UIWebView *bodyWebView;
@property (weak, nonatomic) IBOutlet UITextView *bodyTextView;
- (IBAction)switchEditor:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSDictionary *tag;

@end

@implementation TnTEditandNewTipViewController


#define TAG_SECTION 0


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSDictionary *)tip{

    if (!_tip) {
        _tip = [[NSDictionary alloc]init];
    
    }
    return _tip;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.bodyWebView.hidden = YES;
    self.bodyTextView.hidden = NO;
    [self.editorSwitch setSelectedSegmentIndex:1];
    self.bodyWebView.delegate = self;
    
    if (self.tip != nil) {
        
    
        NSLog(@"entered");
        NSLog(@"%@",self.tip);
           }
   
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    //NSLog(@"%@",self.tag);

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
return @"Tag";

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"tag" forIndexPath:indexPath];
    if (self.tag) {
        
        cell.detailTextLabel.text = [self.tag objectForKey:@"term"];
    }
    
    return cell;
    

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"selectTag"] ) {
        TnTSelectTagViewController *vc = (TnTSelectTagViewController *)segue.destinationViewController;
        vc.delegate = self;
      
        vc.selectedValue = self.tag;
        
        
    }
    
}


- (IBAction)cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(id)sender {
    
    
    
    

    // field_tag is NULL here please do something
    
    
    NSDictionary *tipDictionary = @{@"_links": @{@"type":@{@"href":@"http://tntfoss-vivekvpandya.rhcloud.com/rest/type/node/tip" }},@"field_tag":@[@{@"target_id":[self.tag objectForKey:@"termID"]}],@"body":@[@{@"value":[self.bodyTextView.textStorage mutableString],@"format":@"full_html"}],@"title":@[@{@"value":self.tipTitle.text}]};
   
 
                                        

    NSError *conversionerror;
    NSData *jsonData =  [NSJSONSerialization dataWithJSONObject:tipDictionary options:kNilOptions error:&conversionerror];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSMutableURLRequest *postRequestURL = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://tntfoss-vivekvpandya.rhcloud.com/entity/node"]];
    [postRequestURL setHTTPMethod:@"POST"];
    [postRequestURL setHTTPBody:jsonData];
    
    User *user = [User sharedInstance];
    
    [config setHTTPAdditionalHeaders:@{@"Authorization":user.basicAuthString,@"Content-Type":@"application/hal+json"}];
    NSURLSession *session  = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *postTask = [session dataTaskWithRequest:postRequestURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if(!error){
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 201) {
            NSLog(@"created");
             [self dismissViewControllerAnimated:YES completion:nil];
        }
        else{
        
            NSLog(@"%ld",(long)httpResponse.statusCode);
            NSDictionary *errorDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:NULL];
            NSLog(@"%@",errorDictionary);
             [self dismissViewControllerAnimated:YES completion:nil];
        }
        }
        else{
        
            NSLog(@"%@",error.localizedDescription);
        }
    }];
    
    
    
    
    
    [postTask resume];
    
    
   
}

- (IBAction)switchEditor:(id)sender {
    
    
    UISegmentedControl *segmentedController = (UISegmentedControl *)sender;
    
    NSInteger index  = segmentedController.selectedSegmentIndex;
    
    if (index == 0) {
        self.bodyWebView.hidden = NO;
        self.bodyTextView.hidden = YES;
       
        [self.bodyWebView loadHTMLString:self.bodyTextView.textStorage.mutableString baseURL:nil];
    }
    if (index == 1) {
        self.bodyWebView.hidden = YES;
        self.bodyTextView.hidden = NO;
        
    }
    
}



-(void)insertHtmlTag:(NSString *)tag sender:(UIButton *)sender{
    
    NSString *startTag = [NSString stringWithFormat:@"<%@>",tag];
    NSString *endTag = [NSString stringWithFormat:@"</%@>",tag];
    
    
    NSRange selectedRange = [_bodyTextView selectedRange];
    if (selectedRange.location != NSNotFound && selectedRange.length != 0) {
        
        [_bodyTextView.textStorage.mutableString insertString:startTag atIndex:selectedRange.location];
        [_bodyTextView.textStorage.mutableString insertString:endTag atIndex:(selectedRange.location + selectedRange.length + [startTag length])];
        _bodyTextView.selectedRange = NSMakeRange([_bodyTextView.textStorage.mutableString length], 0);
        
    }
    else{
        
        if (sender.selected) {
            
            [_bodyTextView.textStorage.mutableString insertString:endTag atIndex:selectedRange.location];
            _bodyTextView.selectedRange = NSMakeRange((selectedRange.location + [endTag length]), 0);
        }
        else
        {
            [_bodyTextView.textStorage.mutableString insertString:startTag atIndex:selectedRange.location];
            _bodyTextView.selectedRange = NSMakeRange((selectedRange.location + [startTag length]), 0);
        }
        sender.selected = !sender.selected;
        
        
    }
    
    
}

-(void)paragraphText:(UIButton *)sender{
    

    [self insertHtmlTag:@"p" sender:sender];
    
}
-(void)hideKeyBoard{

    [_bodyTextView resignFirstResponder];
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
            
            
            NSRange selectedRange = [_bodyTextView selectedRange];
            
            if (selectedRange.location != NSNotFound && selectedRange.length != 0) {
                
                NSString *linkString = [NSString stringWithFormat:@"<a href='%@'>",[alertView textFieldAtIndex:0].text];
                
                [_bodyTextView.textStorage.mutableString insertString:linkString atIndex:selectedRange.location];
                [_bodyTextView.textStorage.mutableString insertString:@"</a>" atIndex:(selectedRange.location + selectedRange.length + [linkString length])];
                _bodyTextView.selectedRange = NSMakeRange([_bodyTextView.textStorage.mutableString length], 0);
                
            }
            else{
                
                NSString *linkString = [NSString stringWithFormat:@"<a href='%@'>%@</a>",[alertView textFieldAtIndex:0].text ,[alertView textFieldAtIndex:0].text ];
                
                [_bodyTextView.textStorage.mutableString insertString:linkString atIndex:selectedRange.location];
                
                
            }
            
        }
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

#pragma mark UIWebView Delegate method 
// this method make links to be opened in Safari
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return YES;
    
}



-(void)uploadImage{

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

-(void)backButtonSelected:(id)object{
    NSLog(@"ok delegation");

    //[self.tip setObject:object forKey:@"tag"];
    self.tag = object;
}


@end
