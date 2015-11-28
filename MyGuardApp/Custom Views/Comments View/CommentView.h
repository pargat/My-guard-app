//
//  CommentView.h
//  FushApp
//
//  Created by CB Labs_1 on 06/04/15.
//  Copyright (c) 2015 CB Labs_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentCell.h"
#import "CommentModal.h"
#import <UIImageView+WebCache.h>
#import "ApiConstants.h"
#import "iOSRequest.h"
#import <JTMaterialSpinner.h>

@protocol CommentDelegate <NSObject>

-(void)delCommentPosted;
-(void)delChange;
@end

@interface CommentView : UIView <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong) JTMaterialSpinner *loaderObj ;
@property (nonatomic,assign) id<CommentDelegate> delegate;
@property CGRect rectToDisappear;
@property (nonatomic,strong) NSString *image_id;
@property (nonatomic,strong) NSString *feed_id;
@property (weak, nonatomic) IBOutlet UITableView *tableViewComments;
@property (strong,nonatomic)NSMutableArray *arrayComments;
@property (strong,nonatomic) NSString *postId;
@property (weak, nonatomic) IBOutlet UILabel *labelNoComments;
@property (weak, nonatomic) IBOutlet UITextField *textFieldComment;
@property (weak, nonatomic) IBOutlet UIView *viewCommentHolde;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutBottomSpace;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property CGRect rect;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLeft;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewRight;

-(void)setter;
-(void)removeKeyboardObservers;
-(void)registerForKeyboardNotifications;
-(void)setDelegateTable;
- (IBAction)actionSend:(id)sender;
- (IBAction)actionBAck:(id)sender;
@end
