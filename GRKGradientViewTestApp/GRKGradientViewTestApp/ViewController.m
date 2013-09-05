//
//  ViewController.m
//  GRKGradientViewTestApp
//
//  Created by Levi Brown on 9/5/13.
//  Copyright (c) 2013 Levi Brown. All rights reserved.
//

#import "ViewController.h"
#import "GRKGradientView.h"

@interface ViewController ()

@property (nonatomic,weak) IBOutlet GRKGradientView *upGradient;
@property (nonatomic,weak) IBOutlet GRKGradientView *downGradient;
@property (nonatomic,weak) IBOutlet GRKGradientView *leftGradient;
@property (nonatomic,weak) IBOutlet GRKGradientView *rightGradient;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.upGradient.gradientOrientation = GRKGradientOrientationUp;
    self.upGradient.gradientColors = [NSArray arrayWithObjects:[UIColor whiteColor], [UIColor blackColor], nil];

    self.downGradient.gradientOrientation = GRKGradientOrientationDown;
    self.downGradient.gradientColors = [NSArray arrayWithObjects:[UIColor lightGrayColor], [UIColor darkGrayColor], nil];
    
    self.leftGradient.gradientOrientation = GRKGradientOrientationLeft;
    self.leftGradient.gradientColors = [NSArray arrayWithObjects:[UIColor orangeColor], [UIColor redColor], nil];
    
    self.rightGradient.gradientOrientation = GRKGradientOrientationRight;
    self.rightGradient.gradientColors = [NSArray arrayWithObjects:[UIColor purpleColor], [UIColor blueColor], nil];
}

@end
