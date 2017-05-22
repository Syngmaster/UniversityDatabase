//
//  AddStudentViewCell.m
//  GuruCrafterHomeWork
//
//  Created by Syngmaster on 21/05/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import "AddStudentViewCell.h"

@implementation AddStudentViewCell 

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
