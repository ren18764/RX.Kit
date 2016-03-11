//
//  RXBackSpaceTextFiledDemoVC.m
//  RX.Kit
//
//  Created by 任玺 on 16/3/10.
//  Copyright © 2016年 Constantine. All rights reserved.
//

#import "RXBackSpaceTextFiledDemoVC.h"
#import "RXBackSpaceTextField.h"

@interface RXBackSpaceTextFiledDemoVC () <UITextFieldDelegate>

@end

@implementation RXBackSpaceTextFiledDemoVC
{
    RXBackSpaceTextField *_toTextField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    _toTextField = [[RXBackSpaceTextField alloc] initWithFrame:CGRectMake(10, 104, SCREEN_WIDTH-20, 40)];
    _toTextField.delegate = self;
    _toTextField.borderStyle = UITextBorderStyleNone;
    _toTextField.textColor = UIColorFromRGB(0x333333);
    _toTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _toTextField.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_toTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0
        && textField.text.length == 0){
        
        NSLog(@"用于邮箱地址栏，删除TAG操作");
        return NO;
    }
    return YES;
}

@end
