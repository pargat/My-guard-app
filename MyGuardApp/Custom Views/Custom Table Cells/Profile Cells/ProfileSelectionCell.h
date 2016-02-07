//
//  ProfileSelectionCell.h
//  MyGuardApp
//
//  Created by vishnu on 25/01/16.
//  Copyright © 2016 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProfileSelectionDelegate <NSObject>

-(void)delSelected:(BOOL)showSafety;

@end

@interface ProfileSelectionCell : UITableViewCell

@property (nonatomic,assign) id<ProfileSelectionDelegate> delegate;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)actionSegmented:(id)sender;

@end
