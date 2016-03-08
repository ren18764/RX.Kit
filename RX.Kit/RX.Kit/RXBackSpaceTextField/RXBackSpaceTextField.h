//
//  EQBackSpaceTextField.h
//  RX-KIT
//
//  Created by 任玺 on 15/6/5.
//  Copyright (c) 2015年 Constantine. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  让UITextField 在没有数据时，通过重写deleteBackward，让删除键也可以触发shouldChangeCharactersInRange。
 *  当时使用在邮箱地址栏编辑时，输入框没有数据，按下删除键，应当删除前面输入好的地址标签。
 */
@interface RXBackSpaceTextField : UITextField  <UIKeyInput>

@end
