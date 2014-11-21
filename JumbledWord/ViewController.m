//
//  ViewController.m
//  JumbledWord
//
//  Created by Naveen Kumar Dungarwal on 01/11/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//


#import "ViewController.h"

#define kDictionaryFileName @"dictionary"
#define kInvalidJumbledWordMessage @"Special characters and number not allow."
#define kEmptyJumbledWordMessage @"Please enter a Jumbled Word then search."
#define kNoSearchResultMessage @"No word found in dictionary."

@interface ViewController ()
{
    NSArray *dictionary;
    NSMutableArray *matchWordList;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    matchWordList = [[NSMutableArray alloc]init];
    
    //Fetching all dictionary words from file
    NSString* path = [[NSBundle mainBundle] pathForResource:kDictionaryFileName ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    
    dictionary = [content componentsSeparatedByString:@"\n"];
    NSLog(@"file content....%@...Count...%d",content,dictionary.count);
}

//Validate jumbled word and perform search
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *errorMessage;
    if(textField.text.length>0)
    {
        NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ"] invertedSet];
        
        if ([textField.text rangeOfCharacterFromSet:set].location != NSNotFound) {
            errorMessage = kInvalidJumbledWordMessage;
        }
    }
    else
    {
        errorMessage = kEmptyJumbledWordMessage;
    }
    
    if(errorMessage.length>0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops...!" message:errorMessage delegate:nil cancelButtonTitle:@"Accept" otherButtonTitles:nil,nil];
        [alert show];
    }
    else
    {
        [textField resignFirstResponder];
        [self searchMatchList:textField.text];
    }
    return YES;
}

//Sort String Alphbetically
- (NSString *)sortedString:(NSString*)string
{
    // init
    NSUInteger length = [string length];
    unichar *chars = (unichar *)malloc(sizeof(unichar) * length);
    
    // extract
    [string getCharacters:chars range:NSMakeRange(0, length)];
    
    // sort (for western alphabets only)
    qsort_b(chars, length, sizeof(unichar), ^(const void *l, const void *r) {
        unichar left = *(unichar *)l;
        unichar right = *(unichar *)r;
        return (int)(left - right);
    });
    
    // recreate
    NSString *sorted = [NSString stringWithCharacters:chars length:length];
    
    // clean-up
    free(chars);
    
    return sorted;
}

//Search matching word in dictionary
-(void)searchMatchList:(NSString*)jumbledWord
{
    [matchWordList removeAllObjects];
    
    NSString *sortedString = [self sortedString:jumbledWord];
    NSLog(@"Sorted String... %@",sortedString);
    
    for(NSString *string in dictionary)
    {
        NSString *unsortedString = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        unsortedString = [self sortedString:[unsortedString lowercaseString]];
        
        if([unsortedString isEqualToString:sortedString])
        {
            [matchWordList addObject:[string stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
        }
    }
    [self.searchTableView reloadData];
    NSLog(@"Matching String....%@....%d",[matchWordList description],matchWordList.count);
}

//Table View delegate methonds
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(matchWordList.count>0)
    return matchWordList.count;
    else
        return 1;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if(matchWordList.count>0)
    {
    cell.textLabel.text = [matchWordList objectAtIndex:indexPath.row];
    }
    else if(self.searchTextField.text.length>0){
        cell.textLabel.text = kNoSearchResultMessage;
    }
    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
