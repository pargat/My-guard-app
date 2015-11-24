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
     
    }
    
    return self;
    
}
-(void)setter
{
    [self.btnSend setEnabled:NO];
    [self.textFieldComment setDelegate:self];
    [self.tableViewComments setDelegate:self];
    [self.tableViewComments setDataSource:self];
    [self fetchComments];
    [self registerForKeyboardNotifications];
    [self tapAdder];

}
- (void)scrollToBottom
{
    CGPoint bottomOffset = CGPointMake(0, self.tableViewComments.contentSize.height - self.tableViewComments.bounds.size.height);
    if ( bottomOffset.y > 0 ) {
        [self.tableViewComments setContentOffset:bottomOffset animated:NO];
    }
}

#pragma mark - 
#pragma mark - Api related functions
-(void)fetchComments
{
    [CommentModal callAPIForComments:[NSString stringWithFormat:KGetCommentApi,KbaseUrl,[Profile getCurrentProfileUserId],self.image_id,self.feed_id] Params:nil success:^(NSMutableArray *commentsArr) {
        self.arrayComments = [commentsArr mutableCopy];
        [self.tableViewComments reloadData];;
    } failure:^(NSString *errorStr) {
        
    }];
}

#pragma mark -
#pragma mark - Text Field Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@""])
    {
        if (textField.text.length==1) {
            [self.btnSend setEnabled:NO];
        }
        else if (textField.text.length>1&&[[textField.text substringToIndex:textField.text.length-1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length>0)
        {
            [self.btnSend setEnabled:YES];
        }
        else
        {
            [self.btnSend setEnabled:NO];
        }
    }
    else
    {
        NSString *str = [NSString stringWithFormat:@"%@%@",textField.text,string];
        if([str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length>0)
        {
            [self.btnSend setEnabled:YES];
        }
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textFieldComment resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark - KeyBoard Handling
-(void)tapAdder
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler)];
    [tapGesture setCancelsTouchesInView:YES];
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
    
    self.layoutBottomSpace.constant = 54;
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static CommentCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell =[[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:kNilOptions] lastObject];
    });
    
    [self configureCell:sizingCell atIndexPath:indexPath];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;

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
    
    cell.labelComment.preferredMaxLayoutWidth = self.frame.size.width - 120;
    [cell.labelComment setText:commentM.commentContent];
    [cell.labelName setText:commentM.commentName];
    [cell.labelTimePassed setText:commentM.commentTimePassed];
    [cell.imageViewDp sd_setImageWithURL:[NSURL URLWithString:commentM.commentDp]];
    
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
        [iOSRequest getJsonResponse:[NSString stringWithFormat:KAddComment,KbaseUrl,[Profile getCurrentProfileUserId],self.image_id,self.feed_id,self.textFieldComment.text] success:^(NSDictionary *responseDict) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.arrayComments = [CommentModal parseDictToModal:[responseDict valueForKey:@"comments"]];
                [self.btnSend setEnabled:YES];
                [self.textFieldComment setEnabled:YES];
                [self.textFieldComment setText:@""];
                [self.labelNoComments setHidden:YES];
                [self.tableViewComments setHidden:NO];

                [self.tableViewComments reloadData];
                [self scrollToBottom];
                [self.textFieldComment setTextColor:[UIColor blackColor]];
                [self.delegate delCommentPosted];
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
    
    
    [UIView animateWithDuration:0.25 animations:^{
        [self setFrame:self.rectToDisappear];

    } completion:^(BOOL finished) {
        [self removeKeyboardObservers];
        [self.textFieldComment setDelegate:nil];
        [self removeFromSuperview];
 
    }];

}
@end
