//
//  AddPlaceViewController.m
//  DogHub
//
//  Created by Emil Iliev on 2/4/16.
//  Copyright © 2016 Marina Georgieva. All rights reserved.
//

#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import "AddPlaceViewController.h"
#import "PlacesTableViewController.h"
#import "Place.h"

@interface AddPlaceViewController()
{
    UIAlertController *_alertController;
    UIAlertAction *_alertAction;
    NSArray *_categories;
    CGFloat _longitude;
    CGFloat _latitude;
}

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *categoryPicker;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation AddPlaceViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"Add New Place";
    
    _categories = @[@"Pet Store", @"Veterinary Clinic", @"Park", @"Hotel", @"Restaurant"];
    self.categoryPicker.dataSource = self;
    self.categoryPicker.delegate = self;
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 100);
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(setLocation:)];
    [self.mapView addGestureRecognizer:longPress];
}

- (IBAction)add:(id)sender {
   
    NSInteger row = [self.categoryPicker selectedRowInComponent:0];
    
    NSString *name = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *desc = [self.descriptionTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *category = [_categories objectAtIndex:row];
    
    if ([name isEqualToString:@""] || [desc isEqualToString:@""]) {
        _alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Place name or description cannot be empty" preferredStyle:UIAlertControllerStyleAlert];
        _alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [_alertController addAction:_alertAction];
        
        [self presentViewController:_alertController animated:YES completion:nil];
        return;
    }
    
    UIImage *image = self.imageView.image;
    if (image == nil) {
        image = [UIImage imageNamed:@"defaultImage"];
    }
    NSData *imageData = UIImagePNGRepresentation(image);
    PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"%@.png", name] data:imageData];
    
    PFGeoPoint *location = nil;
    if (_latitude == 0 && _longitude == 0) {
        location = [PFGeoPoint geoPointWithLatitude:42.703870 longitude:23.377731];
    }
    else {
        location = [PFGeoPoint geoPointWithLatitude:_latitude longitude:_longitude];
    }
    
    Place *place = [Place placeWithName:name description:desc category:category location:location andImage: imageFile];
    [place saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSString *storyboardId = @"allPlacesScene";
            PlacesTableViewController *placesViewController = [self.storyboard instantiateViewControllerWithIdentifier:storyboardId];
            [self.navigationController pushViewController:placesViewController animated:YES];
        }
        else {
            _alertController = [UIAlertController alertControllerWithTitle:@"Error" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            _alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [_alertController addAction:_alertAction];
            [self presentViewController:_alertController animated:YES completion:nil];
            return;
        }
    }];
}

- (IBAction)takePhoto:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Device has no camera" preferredStyle:UIAlertControllerStyleAlert];
        _alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [_alertController addAction:_alertAction];
        
        [self presentViewController:_alertController animated:YES completion:nil];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (IBAction)selectPhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _categories.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _categories[row];
}

- (void)setLocation:(UIGestureRecognizer *)gesture{
    if (gesture.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    CGPoint touchedPoint = [gesture locationInView:self.mapView];
    CLLocationCoordinate2D touchedLocation = [self.mapView convertPoint:touchedPoint toCoordinateFromView:self.mapView];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = touchedLocation;
    [self.mapView addAnnotation:annotation];
    
    NSLog(@"Location found from Map: %f %f", touchedLocation.latitude, touchedLocation.longitude);
    _latitude = touchedLocation.latitude;
    _longitude = touchedLocation.longitude;
}

@end
