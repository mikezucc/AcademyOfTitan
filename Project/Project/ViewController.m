//
//  ViewController.m
//  Project
//
//  Created by ASCI-Red on 11/10/14.
//  Copyright (c) 2014 Earth. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    IBOutlet UIButton *startButton;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImage *btnImage = [UIImage imageNamed:@"burg_eltz_deviantart_by_gingado-d83yi7h.jpg"];
    [startButton setImage:btnImage forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
