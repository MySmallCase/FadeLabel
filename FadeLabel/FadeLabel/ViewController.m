//
//  ViewController.m
//  FadeLabel
//
//  Created by MyMac on 15/11/11.
//  Copyright © 2015年 MyMac. All rights reserved.
//

#import "ViewController.h"
#import "FadeLabel.h"

@interface ViewController ()

@property (nonatomic,strong) FadeLabel *fadeLabel;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addSubview:self.fadeLabel];
    self.fadeLabel.text = @"代颜网代颜网代颜网代颜网代颜网代颜网代颜网";
    [self.fadeLabel sizeToFit];
    [self.fadeLabel fade];
    
    
}

- (FadeLabel *)fadeLabel{
    if (!_fadeLabel) {
        _fadeLabel = [[FadeLabel alloc] init];
        _fadeLabel.font = [UIFont systemFontOfSize:24.0f];
        _fadeLabel.textColor = [UIColor blueColor];
        _fadeLabel.numberOfLines = 0;
    }
    return _fadeLabel;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.fadeLabel.frame = CGRectMake(16, 16, self.view.frame.size.width - 32, self.view.frame.size.height - 32 - 20);
    
}

@end
