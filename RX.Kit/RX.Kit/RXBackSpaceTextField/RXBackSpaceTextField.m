//
//  EQBackSpaceTextField.m
//  RX-KIT
//
//  Created by 任玺 on 15/6/5.
//  Copyright (c) 2015年 Constantine. All rights reserved.
//

#import "RXBackSpaceTextField.h"

@implementation RXBackSpaceTextField

#pragma mark UIKeyInput

- (void)deleteBackward
{
    if (self.text.length == 0) {
        //输入框有数据时
        if (self.delegate
            && [self.delegate conformsToProtocol:@protocol(UITextFieldDelegate)]
            && [self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
            [self.delegate textField:self shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@""];
        }
        
    }else{
        //输入框没有数据时，调用super函数
        [super deleteBackward];
    }
}

@end
