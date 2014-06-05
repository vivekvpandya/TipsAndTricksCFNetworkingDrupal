//
//  TnTTipViewController.h
//  TipsAndTricksCFNetwork
//
//  Created by Vivek Pandya on 6/1/14.
//  Copyright (c) 2014 Vivek Pandya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TnTTipViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSDictionary *tip;
@end
