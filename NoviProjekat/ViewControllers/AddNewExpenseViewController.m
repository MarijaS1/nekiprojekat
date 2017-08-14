//
//  AddNewExpenseViewController.m
//  NoviProjekat
//
//  Created by Marija Sumakovic on 8/13/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "AddNewExpenseViewController.h"
#import "ActionSheetPicker.h"

@interface AddNewExpenseViewController ()

@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) UITapGestureRecognizer *tap;
@property (strong, nonatomic) NSArray *pickTypeOfExpenseArray;
@property (strong, nonatomic) NSArray *carArray;
@property (strong, nonatomic) NSMutableArray *carStringArray;
@property (strong, nonatomic) Car *selectedCar;

@end

@implementation AddNewExpenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initGui];
    [self getData];
    
    // Do any additional setup after loading the view.
}

-(void)initGui {
    self.pickTypeOfExpenseArray=[[NSArray alloc] initWithObjects:@"Gorivo", @"Pranje automobila", @"Popravka", @"Auto delovi", @"Registracija", @"Ostalo",  nil];
    
    
    self.selectedDate =nil;
    //self.title =@"Update Expense";
    
    self.amount.delegate = self;
    self.dateTextField.delegate = self;
    self.carTextField.delegate = self;
    self.typeOfExpenseTF.delegate = self;
    
    
    self.tap = [[UITapGestureRecognizer alloc]
                initWithTarget:self
                action:@selector(dismissKeyboard)];
    [self.tap setCancelsTouchesInView:NO];
    [self.tap setEnabled:NO];
    [self.view addGestureRecognizer:self.tap];
}


-(void)getData {
    self.carStringArray = [[NSMutableArray alloc] init];
    self.carArray = [[NSArray alloc] init];
    User *user = [DataController sharedInstance].userInfo;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Car"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"brandName" ascending:NO]];
    [request setReturnsObjectsAsFaults:NO];
    request.predicate = [NSPredicate predicateWithFormat:@"hasOwnerRelationship = %@", user.objectID];
    NSError *error = nil;
    NSArray *matches = [self.appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    if (!matches || error ) {
        NSLog(@"Error while getting car");
    }else if ([matches count]){
        self.carArray = [matches mutableCopy];
        for (Car *car in matches) {
            [self.carStringArray addObject:[NSString stringWithFormat:@"%@ %@", car.brandName, car.type]];
        }
//        [self.tableView reloadData];
    }

}

-(void)addExpense{
    Expenses *ex = [Expenses ]
    
    Expenses *car = [NSEntityDescription insertNewObjectForEntityForName:@"Expenses" inManagedObjectContext:self.appDelegate.managedObjectContext];
    car.type = self.carTypeTextField.text;
    car.brandName = self.carBrandtextField.text;
    car.registration = self.carPlateTextField.text;
    if (self.carImage) {
        car.image = self.carImage;
    }
    car.hasOwnerRelationship = [DataController sharedInstance].userInfo;
    //     [[DataController sharedInstance].userInfo addHasCarRelationshipObject:car];
    
    
    if (![self.appDelegate.managedObjectContext save:&error]) {
        NSLog(@"Great, error while fixing error; couldn't save: %@", [error localizedDescription]);
    } else {
        NSLog(@"Car saved");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Uspesno ste dodali automobil!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }

}


#pragma mark -Keybord

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [UIView beginAnimations:@"textFieldShouldBeginEditing:" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView commitAnimations];
    [self.tap setEnabled:YES];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}



-(void) dismissKeyboard {
    [self.amount resignFirstResponder];
    [self.typeOfExpenseTF resignFirstResponder];
    [self.dateTextField resignFirstResponder];
    [self.carTextField resignFirstResponder];
    [self.tap setEnabled:NO];
}

#pragma mark -Actions

- (IBAction)addExpense:(UIButton *)sender {
    if (self.selectedCar != nil && self.selectedDate != nil && ![self.typeOfExpenseTF.text  isEqual: @""] && ![self.amount.text  isEqual: @""]) {
        // dodaj trosak
        
        [self addExpense];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Unesite sve potrebne podatke kako biste sacuvali trosak!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
}
- (IBAction)typeOfExpensebuttonPressed:(UIButton *)sender {
    [ActionSheetStringPicker showPickerWithTitle:@""
                                            rows:self.pickTypeOfExpenseArray
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           self.typeOfExpenseTF.text = (NSString*)selectedValue;
                                           //                                               self.addReminder.enabled = YES;
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:sender];

}

- (IBAction)dateButtonPressed:(UIButton *)sender {
    NSDate *minDate = [NSDate date];
    
    ActionSheetDatePicker* actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:minDate
                                                                                minimumDate:nil
                                                                                maximumDate:minDate
                                                                                     target:self action:@selector(dateWasSelected:element:) origin:sender];
    
    actionSheetPicker.hideCancel = NO;
    [actionSheetPicker showActionSheetPicker];
}
- (IBAction)carButtonPressed:(UIButton *)sender {
    
    [ActionSheetStringPicker showPickerWithTitle:@""
                                            rows:self.carStringArray
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           self.carTextField.text = (NSString*)selectedValue;
                                           self.selectedCar = self.carArray[selectedIndex];
                                           //                                               self.addReminder.enabled = YES;
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:sender];
    
}




- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    //    self.addReminder.enabled = YES;
    self.selectedDate = selectedDate;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:self.selectedDate];
    [self.dateTextField setText:dateString];
    //    [self.dateOfBirthButton setTitle:dateString forState:UIControlStateNormal];
    //    [self.dateOfBirthButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
