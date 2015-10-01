//
//  LoaderView.h
//  PokerGameApp
//
//  Created by HeLLs GAtE on 12/09/14.
//  Copyright (c) 2014 CodeBrew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JTMaterialSpinner.h>

@interface LoaderView : UIView

-(void)startAnimating : (NSString *)imgName  viewBackgroundColor:(UIColor *)backgroundColor viewBackgroundAlpha: (float) alpha;
-(void)stopAnimating ;



@property (strong, nonatomic) IBOutlet UIImageView *loaderImgView;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundView;

@end
