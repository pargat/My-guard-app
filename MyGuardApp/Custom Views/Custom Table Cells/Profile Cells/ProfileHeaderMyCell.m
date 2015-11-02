//
//  ProfileHeaderMyCell.m
//  MyGuardApp
//
//  Created by vishnu on 23/09/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "ProfileHeaderMyCell.h"

@implementation ProfileHeaderMyCell

- (void)awakeFromNib {
    // Initialization code
    self.imageViewDp.layer.cornerRadius = self.imageViewDp.frame.size.width/2;
    self.imageViewDp.clipsToBounds = YES;
    
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.viewBottomLine.bounds];
    self.viewBottomLine.layer.masksToBounds = NO;
    self.viewBottomLine.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.viewBottomLine.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.viewBottomLine.layer.shadowOpacity = 0.3f;
    self.viewBottomLine.layer.shadowPath = shadowPath.CGPath;
}




- (IBAction)actionEditProfile:(id)sender
{
    
}

- (IBAction)actionSettings:(id)sender
{
    
}
- (IBAction)actionDpFull:(id)sender {
    
    Profile *modal = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"profile"];
    ImageBigView *img = [[ImageBigView alloc] init];
    [img setFrame:[[UIScreen mainScreen] bounds]];
    [img setImage:[NSURL URLWithString:modal.profileImageFullLink]];
    [[[UIApplication sharedApplication] keyWindow] addSubview:img];
}
@end
