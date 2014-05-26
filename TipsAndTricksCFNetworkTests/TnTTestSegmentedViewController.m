//
//  TnTTestSegmentedViewController.m
//  TipsAndTricksCFNetwork
//
//  Created by Vivek Pandya on 5/26/14.
//  Copyright (c) 2014 Vivek Pandya. All rights reserved.
//

#import "TnTTestSegmentedViewController.h"

@interface TnTTestSegmentedViewController ()

@property (strong,nonatomic) NSMutableAttributedString *htmlString; // string that will be rendered in webView

@end

@implementation TnTTestSegmentedViewController

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
    self.webView.hidden = NO;
    self.textView.hidden = YES;
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

- (IBAction)changeView:(id)sender {
    
    UISegmentedControl *segmentedController = (UISegmentedControl *)sender;
    
    NSInteger index  = segmentedController.selectedSegmentIndex;
    
    if (index == 0) {
        self.webView.hidden = NO;
        self.textView.hidden = YES;
        [self.webView loadHTMLString:[self.htmlString string] baseURL:nil];
    }
    if (index == 1) {
        self.webView.hidden = YES;
        self.textView.hidden = NO;
        
    }

}

-(UIView *)inputAccessoryView{

    CGRect accessFrame = CGRectMake(0.0,0.0,100.0,40.0);
    UIView *inputAccessoryView = [[UIView alloc]initWithFrame:accessFrame];
    inputAccessoryView.backgroundColor = [UIColor blackColor];
  
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    doneButton.frame = CGRectMake(0.0,0.0,50.0, 37.0);
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(hideKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [inputAccessoryView addSubview:doneButton];
    
    UIButton *boldButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    boldButton.frame = CGRectMake(55.0, 0.0, 50.0, 40.0);
    [boldButton setTitle:@"B" forState:UIControlStateNormal];
    [boldButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [boldButton addTarget:self action:@selector(boldText) forControlEvents:UIControlEventTouchUpInside];
    [inputAccessoryView addSubview:boldButton];
    
    return inputAccessoryView;
    
    
}


-(void)hideKeyBoard{


    [self.textView resignFirstResponder];
    self.htmlString = [self.textView.text mutableCopy];

}
-(void)boldText{

    

}
@end
