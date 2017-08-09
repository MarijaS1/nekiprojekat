//
//  AddNewCarViewController.m
//  NoviProjekat
//
//  Created by Marija Sumakovic on 7/22/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "AddNewCarViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "AppDelegate.h"

@interface AddNewCarViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
@property (weak, nonatomic) IBOutlet UITextField *carPlateTextField;
@property (weak, nonatomic) IBOutlet UITextField *carBrandtextField;
@property (weak, nonatomic) IBOutlet UITextField *carTypeTextField;
@property (weak, nonatomic) IBOutlet UIButton *addCarButton;
@property (weak, nonatomic) IBOutlet UIButton *addCarImage;

@property (strong, nonatomic) NSData *carImage;

@end

@implementation AddNewCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initGui];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initGui {
    CALayer *borderLayer = [CALayer layer];
    CGRect borderFrame = CGRectMake(0, 0, (self.carImageView.frame.size.width), (self.carImageView.frame.size.height));
    [borderLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
    [borderLayer setFrame:borderFrame];
    [borderLayer setBorderWidth:1.0f];
    [borderLayer setBorderColor:[[UIColor getGreyColor] CGColor]];
    [self.carImageView.layer addSublayer:borderLayer];
    if (self.car) {
        [self setupTextFields];
    }
}


-(void)setupTextFields {
    self.carTypeTextField.text = self.car.type;
    self.carBrandtextField.text = self.car.brandName;
    self.carPlateTextField.text = self.car.registration;
    self.carImageView.image = [UIImage imageWithData:self.car.image];
    [self.addCarButton setTitle:@"Izmeni Automobil" forState:UIControlStateNormal];
}


-(void)updateCar {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Car"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"brandName" ascending:NO]];
    [request setReturnsObjectsAsFaults:NO];
    request.predicate = [NSPredicate predicateWithFormat:@"registration = %@", self.car.registration];
    NSError *error = nil;
    NSArray *matches = [self.appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    Car *car = [matches objectAtIndex:0];
    car.registration = self.carPlateTextField.text;
    car.brandName = self.carBrandtextField.text;
    car.type = self.carTypeTextField.text;
    
    if (car.image!=self.car.image) {
        car.image = self.carImage;
    }
    if (![self.appDelegate.managedObjectContext save:&error]) {
        NSLog(@"Great, error while fixing error; couldn't save: %@", [error localizedDescription]);
    } else {
        NSLog(@"Car saved");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Uspesno ste izmenili automobil!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
             [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
    }

}


- (IBAction)addCarButtonPressed:(UIButton *)sender {
    NSError *error = nil;
    
    if (self.car) {
        if ([self validateTFs]) {
            [self updateCar];
        }
        
    }else{
        Car *car = [NSEntityDescription insertNewObjectForEntityForName:@"Car" inManagedObjectContext:self.appDelegate.managedObjectContext];
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
   
}

- (IBAction)addCarImagePressed:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //Permetto la modifica delle foto
    picker.allowsEditing = YES;
    //Imposto il delegato
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *pickedImage = info[UIImagePickerControllerOriginalImage];
    self.carImage = UIImageJPEGRepresentation(pickedImage, 0.0);
    self.carImageView.image = pickedImage;
    [self dismissModalViewControllerAnimated:YES];
}



-(BOOL)validateTFs {
    if (self.carPlateTextField.text != self.car.registration || self.carBrandtextField.text != self.car.brandName || self.carTypeTextField.text != self.car.type || self.carImage) {
        return YES;
    }
    return NO;
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
