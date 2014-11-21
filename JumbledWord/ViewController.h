//
//  ViewController.h
//  JumbledWord
//
//  Created by Naveen Kumar Dungarwal on 01/11/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@end
