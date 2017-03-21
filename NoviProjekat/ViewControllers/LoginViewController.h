//
//  LoginViewController.h
//  NoviProjekat
//
//  Created by Marija Sumakovic on 3/21/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "BasicViewController.h"

@interface LoginViewController : BasicViewController
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end
