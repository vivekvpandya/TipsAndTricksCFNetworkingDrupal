//
//  TnTTestSegmentedViewController.m
//  TipsAndTricksCFNetwork
//
//  Created by Vivek Pandya on 5/26/14.
//  Copyright (c) 2014 Vivek Pandya. All rights reserved.
//

#import "TnTTestSegmentedViewController.h"

@interface TnTTestSegmentedViewController ()

@property (strong,nonatomic) NSMutableString *htmlString; // string that will be rendered in webView
@property (strong,nonatomic) UIButton *boldButton;
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
   
    [doneButton addTarget:self action:@selector(hideKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [inputAccessoryView addSubview:doneButton];
    self.boldButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.boldButton.frame = CGRectMake(50.0, 0.0,30.0, 40.0);
    
    [self.boldButton setTitle:@"B" forState:UIControlStateNormal];
    [self.boldButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.boldButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [self.boldButton addTarget:self action:@selector(boldText) forControlEvents:UIControlEventTouchUpInside];
    [inputAccessoryView addSubview:self.boldButton];
    
    UIButton *italicButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    italicButton.frame = CGRectMake(80.0, 0.0, 30.0, 40.0);
    [italicButton setTitle:@"I" forState:UIControlStateNormal];
    [italicButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [italicButton addTarget:self action:@selector(italicText) forControlEvents:UIControlEventTouchUpInside];
    [inputAccessoryView addSubview:italicButton];
    
    UIButton *underlineButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    underlineButton.frame = CGRectMake(110.0, 0.0, 30.0, 40.0);
    [underlineButton setTitle:@"U" forState:UIControlStateNormal];
    [underlineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [underlineButton addTarget:self action:@selector(underLineText) forControlEvents:UIControlEventTouchUpInside];
    [inputAccessoryView addSubview:underlineButton];

    UIButton *strikeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    strikeButton.frame = CGRectMake(140.0, 0.0, 30.0, 40.0);
    [strikeButton setTitle:@"≁" forState:UIControlStateNormal];
    [strikeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [strikeButton addTarget:self action:@selector(strikeText) forControlEvents:UIControlEventTouchUpInside];
    [inputAccessoryView addSubview:strikeButton];
   
    UIButton *blockquoteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    blockquoteButton.frame = CGRectMake(170.0, 0.0, 30.0, 40.0);
    [blockquoteButton setTitle:@"❝" forState:UIControlStateNormal];
    [blockquoteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [blockquoteButton addTarget:self action:@selector(blockquoteText) forControlEvents:UIControlEventTouchUpInside];
    [inputAccessoryView addSubview:blockquoteButton];


    UIButton *paragraphButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    paragraphButton.frame = CGRectMake(200.0, 0.0, 30.0, 40.0);
    [paragraphButton setTitle:@"¶" forState:UIControlStateNormal];
    [paragraphButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [paragraphButton addTarget:self action:@selector(paragraphText) forControlEvents:UIControlEventTouchUpInside];
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


-(void)hideKeyBoard{


    [self.textView resignFirstResponder];
    self.htmlString = self.textView.textStorage.mutableString ;

}
-(void)boldText{
    
    
    
    NSRange selectedRange = [_textView selectedRange];
    if (selectedRange.location != NSNotFound && selectedRange.length != 0) {
        
        [_textView.textStorage.mutableString insertString:@"<strong>" atIndex:selectedRange.location];
        [_textView.textStorage.mutableString insertString:@"</strong>" atIndex:(selectedRange.location + selectedRange.length + [@"<strong>" length])];
        _textView.selectedRange = NSMakeRange([_textView.textStorage.mutableString length], 0);
        
    }
    else{
        
        NSLog(@"%u",self.boldButton.state);
    
    }

    
}


-(void)italicText{
    
    NSRange selectedRange = [_textView selectedRange];
    if (selectedRange.location != NSNotFound && selectedRange.length != 0) {
        
        [_textView.textStorage.mutableString insertString:@"<em>" atIndex:selectedRange.location];
        [_textView.textStorage.mutableString insertString:@"</em>" atIndex:(selectedRange.location + selectedRange.length + [@"<em>" length])];
        _textView.selectedRange = NSMakeRange([_textView.textStorage.mutableString length], 0);
        
    }

}

-(void)underLineText{

    NSRange selectedRange = [_textView selectedRange];
    if (selectedRange.location != NSNotFound && selectedRange.length != 0) {
        
        [_textView.textStorage.mutableString insertString:@"<u>" atIndex:selectedRange.location];
        [_textView.textStorage.mutableString insertString:@"</u>" atIndex:(selectedRange.location + selectedRange.length + [@"<u>" length])];
        _textView.selectedRange = NSMakeRange([_textView.textStorage.mutableString length], 0);
        
    }

}
-(void)strikeText{

    NSRange selectedRange = [_textView selectedRange];
    if (selectedRange.location != NSNotFound && selectedRange.length != 0) {
        
        [_textView.textStorage.mutableString insertString:@"<strike>" atIndex:selectedRange.location];
        [_textView.textStorage.mutableString insertString:@"</strike>" atIndex:(selectedRange.location + selectedRange.length + [@"<strike>" length])];
        _textView.selectedRange = NSMakeRange([_textView.textStorage.mutableString length], 0);
        
    }
}
-(void)blockquoteText{


    NSRange selectedRange = [_textView selectedRange];
    if (selectedRange.location != NSNotFound && selectedRange.length != 0) {
        
        [_textView.textStorage.mutableString insertString:@"<blockquote>" atIndex:selectedRange.location];
        [_textView.textStorage.mutableString insertString:@"</blockquote>" atIndex:(selectedRange.location + selectedRange.length + [@"<blockquote>" length])];
        _textView.selectedRange = NSMakeRange([_textView.textStorage.mutableString length], 0);
        
    }
    
}

-(void)paragraphText{


    
    NSRange selectedRange = [_textView selectedRange];
    if (selectedRange.location != NSNotFound && selectedRange.length != 0) {
        
        [_textView.textStorage.mutableString insertString:@"<p>" atIndex:selectedRange.location];
        [_textView.textStorage.mutableString insertString:@"</p>" atIndex:(selectedRange.location + selectedRange.length + [@"<p>" length])];
        _textView.selectedRange = NSMakeRange([_textView.textStorage.mutableString length], 0);
        
    }

    
    
}

-(void)addLink{
    
    UIAlertView *addLinkAlert = [[UIAlertView alloc]initWithTitle:@"Enter URL for link here" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    [addLinkAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [addLinkAlert show];
    addLinkAlert.tag = 1;
    
    
    

}


-(void)uploadImage{


}

-(void)addOrRemoveFontTraitWithName:(NSString *)traitName AndValue:(uint32_t)traitValue{
    
        
        
    NSRange selectedRange = [_textView selectedRange];
    if (selectedRange.location != NSNotFound && selectedRange.length != 0) {
        
    
    NSDictionary *currentAttributesDict = [_textView.textStorage attributesAtIndex:selectedRange.location
                                                                    effectiveRange:nil];
    
    UIFont *currentFont = [currentAttributesDict objectForKey:NSFontAttributeName];
    
    UIFontDescriptor *fontDescriptor = [currentFont fontDescriptor];
    
    NSString *fontNameAttribute = [fontDescriptor  objectForKey:UIFontDescriptorNameAttribute];
    UIFontDescriptor *changedFontDescriptor;
    NSLog(@"%@",currentAttributesDict);
    
    if ([fontNameAttribute rangeOfString:traitName].location == NSNotFound) {
        
        uint32_t existingTraitsWithNewTrait = [fontDescriptor symbolicTraits] | traitValue;
        changedFontDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:existingTraitsWithNewTrait];
        UIFont *updatedFont = [UIFont fontWithDescriptor:changedFontDescriptor size:0.0];
        
        NSDictionary *dict = @{NSFontAttributeName: updatedFont};
        
        [_textView.textStorage beginEditing];
        [_textView.textStorage setAttributes:dict range:selectedRange];
        [_textView.textStorage endEditing];

        [_textView.textStorage.mutableString insertString:@"<strong>" atIndex:selectedRange.location];
        [_textView.textStorage.mutableString insertString:@"</strong>" atIndex:(selectedRange.location + selectedRange.length + [@"<strong>" length])];

            }
    else{
        
        
        uint32_t existingTraitsWithoutTrait = [fontDescriptor symbolicTraits] & ~traitValue;
        changedFontDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:existingTraitsWithoutTrait];
        UIFont *updatedFont = [UIFont fontWithDescriptor:changedFontDescriptor size:0.0];
        
        NSDictionary *dict = @{NSFontAttributeName: updatedFont};
        
        [_textView.textStorage beginEditing];
        [_textView.textStorage setAttributes:dict range:selectedRange];
        [_textView.textStorage endEditing];

        
        NSRange range = {(selectedRange.location - [@"<strong>" length]),[@"<strong>" length]};
        
        
        
       NSRange range2 = { (selectedRange.location + selectedRange.length) ,[@"</strong>" length]};
        [_textView.textStorage.mutableString deleteCharactersInRange:range ];
        [_textView.textStorage.mutableString deleteCharactersInRange:range2 ];

        
    }
    
    
    
    
    }
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
@end
