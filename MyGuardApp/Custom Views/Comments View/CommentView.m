//
//  CommentView.m
//  FushApp
//
//  Created by CB Labs_1 on 06/04/15.
//  Copyright (c) 2015 CB Labs_1. All rights reserved.
//

#import "CommentView.h"

@implementation CommentView

-(instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CommentView" owner:self options:nil] lastObject];
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;
     
        //[self tapAdder];
    }
    
    return self;
    
}
-(void)setter
{
    [self.textFieldComment setDelegate:self];
}
- (void)scrollToBottom
{
    CGPoint bottomOffset = CGPointMake(0, self.tableViewComments.contentSize.height - self.tableViewComments.bounds.size.height);
    if ( bottomOffset.y > 0 ) {
        [self.tableViewComments setContentOffset:bottomOffset animated:NO];
    }
}
#pragma mark -
#pragma mark - KeyBoard Handling
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textFieldComment resignFirstResponder];
    return YES;
}
-(void)tapAdder
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler)];
    [tapGesture setCancelsTouchesInView:NO];
    [self addGestureRecognizer:tapGesture];
    
}
-(void)tapHandler
{
    [self endEditing:YES];
}
-(void)removeKeyboardObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

}
- (void)registerForKeyboardNotifications

{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
    
}





- (void)keyboardWasShown:(NSNotification*)aNotification

{
    
    NSDictionary* info = [aNotification userInfo];
    
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.layoutBottomSpace.constant = kbRect.size.height;
    [UIView animateWithDuration:0.5 animations:^{
        [self layoutIfNeeded];
    }
                     completion:^(BOOL finished) {
                         
                     }
     ];
    
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification

{
    
    self.layoutBottomSpace.constant = 0;
    [UIView animateWithDuration:0.5 animations:^{
        [self layoutIfNeeded];
    }];
}


#pragma mark -
#pragma mark - Table View Datasource and delegate functions
-(void)setDelegateTable
{
    [self.tableViewComments setDelegate:self];
    [self.tableViewComments setDataSource:self];
    [self.tableViewComments reloadData];
    if([self.arrayComments count]==0)
    {
        [self.tableViewComments setHidden:YES];
        [self.labelNoComments setHidden:NO];
        self.labelNoComments.text = @"No comments";
    }
    else
    {
        [self.tableViewComments setHidden:NO];
        [self.labelNoComments setHidden:YES];
    }
    

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayComments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:kNilOptions] lastObject];
    }
    [self configureCell:cell atIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)configureCell:(CommentCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    CommentModal *commentM = [self.arrayComments objectAtIndex:indexPath.row];
    
    cell.labelComment.preferredMaxLayoutWidth = self.frame.size.width - 80;
    [cell.labelComment setText:commentM.commentContent];
    [cell.labelName setText:commentM.commentName];
    [cell.labelTimePassed setText:commentM.commentTimePassed];
    [cell.imageViewDp sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:KBaseTimbthumbUrl,commentM.commentDp,cell.imageViewDp.frame.size.width,cell.imageViewDp.frame.size.height]]];
    

    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
#pragma mark -
#pragma mark - Alert View Related Functions
-(void)showAlert:(NSString *)stringTitle message:(NSString *)stringMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:stringTitle message:stringMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}
#pragma mark - 
#pragma mark - Button Actions
- (IBAction)actionSend:(id)sender {
    
    if([[self.textFieldComment.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]!=0)
    {
        [self.btnSend setEnabled:NO];
        [self.textFieldComment setTextColor:[UIColor lightGrayColor]];
        [self.textFieldComment setEnabled:NO];
        [iOSRequest getJsonResponse:[NSString stringWithFormat:KAddComment,KbaseUrl,[Profile getCurrentProfileUserId],self.feed_id,self.textFieldComment.text] success:^(NSDictionary *responseDict) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                

                
                
                [self.btnSend setEnabled:YES];
                [self.textFieldComment setEnabled:YES];
                [self.textFieldComment setText:@""];
                [self.labelNoComments setHidden:YES];
                [self.tableViewComments setHidden:NO];

                [self.tableViewComments reloadData];
                [self scrollToBottom];
                [self.textFieldComment setTextColor:[UIColor blackColor]];
            });
        } failure:^(NSString *stringError) {
            [self.btnSend setEnabled:YES];
            [self.textFieldComment setEnabled:YES];
            [self.textFieldComment setTextColor:[UIColor blackColor]];
        }];
    }
}

- (IBAction)actionBAck:(id)sender {
    [self.textFieldComment resignFirstResponder];
    [self removeKeyboardObservers];
    [self.textFieldComment setDelegate:nil];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self setFrame:CGRectMake(self.rect.origin.x+self.rect.size.width/2, self.rect.origin.y+self.rect.size.height/2, 0, 0)];

    } completion:^(BOOL finished) {
        [self removeFromSuperview];
 
    }];

}
@end
