//
//  TnTCustomTextViewController.m
//  TipsAndTricksCFNetwork
//
//  Created by Vivek Pandya on 5/30/14.
//  Copyright (c) 2014 Vivek Pandya. All rights reserved.
//

#import "TnTCustomTextViewController.h"

@interface TnTCustomTextViewController ()

@property (nonatomic,strong) NSString *htmlString;
@end

@implementation TnTCustomTextViewController

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
    self.webView.delegate = self;
    self.segmentedSwitch.hidden = YES;
    self.tipTitle.enabled = NO;
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeView:(id)sender {
    
    
        UISegmentedControl *segmentedController = (UISegmentedControl *)sender;
        
        NSInteger index  = segmentedController.selectedSegmentIndex;
        
        if (index == 0) {
            self.webView.hidden = NO;
            self.textView.hidden = YES;
            self.htmlString = self.textView.textStorage.mutableString ;
            [self.webView loadHTMLString:self.htmlString baseURL:nil];
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
    doneButton.frame = CGRectMake(0.0,0.0,50.0,40.0);
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    // [doneButton addTarget:self action:@selector(hideKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [doneButton addTarget:self action:@selector(hideKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
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


-(void)hideKeyBoard:(UIButton *)sender{
    
    
    
    [self.textView resignFirstResponder];
    
    
    
}
-(void)boldText:(UIButton *)sender{
    
    
    
    NSRange selectedRange = [_textView selectedRange];
    if (selectedRange.location != NSNotFound && selectedRange.length != 0) {
        
        [_textView.textStorage.mutableString insertString:@"<strong>" atIndex:selectedRange.location];
        [_textView.textStorage.mutableString insertString:@"</strong>" atIndex:(selectedRange.location + selectedRange.length + [@"<strong>" length])];
        _textView.selectedRange = NSMakeRange([_textView.textStorage.mutableString length], 0);
        
    }
    else{
        
        if (sender.selected) {
            
            [_textView.textStorage.mutableString insertString:@"</strong>" atIndex:selectedRange.location];
            _textView.selectedRange = NSMakeRange((selectedRange.location + [@"</strong>" length]), 0);
        }
        else
        {
            [_textView.textStorage.mutableString insertString:@"<strong>" atIndex:selectedRange.location];
            _textView.selectedRange = NSMakeRange((selectedRange.location + [@"<strong>" length]), 0);
        }
        sender.selected = !sender.selected;
        
        
    }
    
    
}


-(void)italicText:(UIButton *)sender{
    
    NSRange selectedRange = [_textView selectedRange];
    if (selectedRange.location != NSNotFound && selectedRange.length != 0) {
        
        [_textView.textStorage.mutableString insertString:@"<em>" atIndex:selectedRange.location];
        [_textView.textStorage.mutableString insertString:@"</em>" atIndex:(selectedRange.location + selectedRange.length + [@"<em>" length])];
        _textView.selectedRange = NSMakeRange([_textView.textStorage.mutableString length], 0);
        
    }
    else{
        
        if (sender.selected) {
            
            [_textView.textStorage.mutableString insertString:@"</em>" atIndex:selectedRange.location];
            _textView.selectedRange = NSMakeRange((selectedRange.location + [@"</em>" length]), 0);
        }
        else
        {
            [_textView.textStorage.mutableString insertString:@"<em>" atIndex:selectedRange.location];
            _textView.selectedRange = NSMakeRange((selectedRange.location + [@"<em>" length]), 0);
        }
        sender.selected = !sender.selected;
        
        
    }
    
}

-(void)underLineText:(UIButton *)sender{
    
    NSRange selectedRange = [_textView selectedRange];
    if (selectedRange.location != NSNotFound && selectedRange.length != 0) {
        
        [_textView.textStorage.mutableString insertString:@"<u>" atIndex:selectedRange.location];
        [_textView.textStorage.mutableString insertString:@"</u>" atIndex:(selectedRange.location + selectedRange.length + [@"<u>" length])];
        _textView.selectedRange = NSMakeRange([_textView.textStorage.mutableString length], 0);
        
    }
    else{
        
        if (sender.selected) {
            
            [_textView.textStorage.mutableString insertString:@"</u>" atIndex:selectedRange.location];
            _textView.selectedRange = NSMakeRange((selectedRange.location + [@"</u>" length]), 0);
        }
        else
        {
            [_textView.textStorage.mutableString insertString:@"<u>" atIndex:selectedRange.location];
            _textView.selectedRange = NSMakeRange((selectedRange.location + [@"<u>" length]), 0);
        }
        sender.selected = !sender.selected;
        
        
    }
    
}
-(void)strikeText:(UIButton *)sender{
    
    NSRange selectedRange = [_textView selectedRange];
    if (selectedRange.location != NSNotFound && selectedRange.length != 0) {
        
        [_textView.textStorage.mutableString insertString:@"<strike>" atIndex:selectedRange.location];
        [_textView.textStorage.mutableString insertString:@"</strike>" atIndex:(selectedRange.location + selectedRange.length + [@"<strike>" length])];
        _textView.selectedRange = NSMakeRange([_textView.textStorage.mutableString length], 0);
        
    }
    else{
        
        if (sender.selected) {
            
            [_textView.textStorage.mutableString insertString:@"</strike>" atIndex:selectedRange.location];
            _textView.selectedRange = NSMakeRange((selectedRange.location + [@"</strike>" length]), 0);
        }
        else
        {
            [_textView.textStorage.mutableString insertString:@"<strike>" atIndex:selectedRange.location];
            _textView.selectedRange = NSMakeRange((selectedRange.location + [@"<strike>" length]), 0);
        }
        sender.selected = !sender.selected;
        
        
    }
}
-(void)blockquoteText:(UIButton *)sender{
    
    
    NSRange selectedRange = [_textView selectedRange];
    if (selectedRange.location != NSNotFound && selectedRange.length != 0) {
        
        [_textView.textStorage.mutableString insertString:@"<blockquote>" atIndex:selectedRange.location];
        [_textView.textStorage.mutableString insertString:@"</blockquote>" atIndex:(selectedRange.location + selectedRange.length + [@"<blockquote>" length])];
        _textView.selectedRange = NSMakeRange([_textView.textStorage.mutableString length], 0);
        
    }
    else{
        
        if (sender.selected) {
            
            [_textView.textStorage.mutableString insertString:@"</blockquote>" atIndex:selectedRange.location];
            _textView.selectedRange = NSMakeRange((selectedRange.location + [@"</blockquote>" length]), 0);
        }
        else
        {
            [_textView.textStorage.mutableString insertString:@"<blockquote>" atIndex:selectedRange.location];
            _textView.selectedRange = NSMakeRange((selectedRange.location + [@"<blockquote>" length]), 0);
        }
        sender.selected = !sender.selected;
        
        
    }
    
}

-(void)paragraphText:(UIButton *)sender{
    
    
    /*
    NSRange selectedRange = [_textView selectedRange];
    if (selectedRange.location != NSNotFound && selectedRange.length != 0) {
        
        [_textView.textStorage.mutableString insertString:@"<p>" atIndex:selectedRange.location];
        [_textView.textStorage.mutableString insertString:@"</p>" atIndex:(selectedRange.location + selectedRange.length + [@"<p>" length])];
        _textView.selectedRange = NSMakeRange([_textView.textStorage.mutableString length], 0);
        
    }
    else{
        
        if (sender.selected) {
            
            [_textView.textStorage.mutableString insertString:@"</p>" atIndex:selectedRange.location];
            _textView.selectedRange = NSMakeRange((selectedRange.location + [@"</p>" length]), 0);
        }
        else
        {
            [_textView.textStorage.mutableString insertString:@"<p>" atIndex:selectedRange.location];
            _textView.selectedRange = NSMakeRange((selectedRange.location + [@"<p>" length]), 0);
        }
        sender.selected = !sender.selected;
        
        
    }
    */
    [self insertHtmlTag:@"p" sender:sender];
    
}

-(void)addLink{
    
    UIAlertView *addLinkAlert = [[UIAlertView alloc]initWithTitle:@"Enter URL for link here" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    [addLinkAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [addLinkAlert show];
    addLinkAlert.tag = 1;
    
    
    
    
}


-(void)uploadImage{
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 1) {
        
        // cancel button will have index 0
        if (buttonIndex == 1) {
            
            
            NSRange selectedRange = [_textView selectedRange];
            
            if (selectedRange.location != NSNotFound && selectedRange.length != 0) {
                
                NSString *linkString = [NSString stringWithFormat:@"<a href='%@'>",[alertView textFieldAtIndex:0].text];
                
                [_textView.textStorage.mutableString insertString:linkString atIndex:selectedRange.location];
                [_textView.textStorage.mutableString insertString:@"</a>" atIndex:(selectedRange.location + selectedRange.length + [linkString length])];
                _textView.selectedRange = NSMakeRange([_textView.textStorage.mutableString length], 0);
                
            }
            else{
                
                NSString *linkString = [NSString stringWithFormat:@"<a href='%@'>%@</a>",[alertView textFieldAtIndex:0].text ,[alertView textFieldAtIndex:0].text ];
                
                [_textView.textStorage.mutableString insertString:linkString atIndex:selectedRange.location];
                
                
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

-(void)loadHTMLString:(NSString *)htmlString{

    [self.webView loadHTMLString:htmlString baseURL:nil];

}

-(void)addCustomViewinView:(UIView *)targetView{
self.view.frame = targetView.bounds;
[targetView addSubview:self.view];
    
}

-(void)loadTextViewWithHTMLString:(NSString *)htmlString{
    self.textView.text = htmlString;

}


// This UIWebView delegate method takes care of links to be opened with Safari
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
   
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return YES;

}

-(void)setTipTitleWithString:(NSString *)string{

    self.tipTitle.text = string;
    
}

-(void)insertHtmlTag:(NSString *)tag sender:(UIButton *)sender{

    NSString *startTag = [NSString stringWithFormat:@"<%@>",tag];
    NSString *endTag = [NSString stringWithFormat:@"</%@>",tag];
    

    NSRange selectedRange = [_textView selectedRange];
    if (selectedRange.location != NSNotFound && selectedRange.length != 0) {
        
        [_textView.textStorage.mutableString insertString:startTag atIndex:selectedRange.location];
        [_textView.textStorage.mutableString insertString:endTag atIndex:(selectedRange.location + selectedRange.length + [startTag length])];
        _textView.selectedRange = NSMakeRange([_textView.textStorage.mutableString length], 0);
        
    }
    else{
        
        if (sender.selected) {
            
            [_textView.textStorage.mutableString insertString:endTag atIndex:selectedRange.location];
            _textView.selectedRange = NSMakeRange((selectedRange.location + [endTag length]), 0);
        }
        else
        {
            [_textView.textStorage.mutableString insertString:startTag atIndex:selectedRange.location];
            _textView.selectedRange = NSMakeRange((selectedRange.location + [startTag length]), 0);
        }
        sender.selected = !sender.selected;
        
        
    }


}
@end
