//
//  UsersProfileViewController.m
//  AirAppStaff
//
//  Created by Daniel on 30/05/16.
//  Copyright © 2016 idesigndreams. All rights reserved.
//

#import "UsersProfileViewController.h"
#import "AppState.h"


@import Firebase;

@interface UsersProfileViewController ()


@end

@implementation UsersProfileViewController

@synthesize userLabel;
@synthesize emailLabel;
@synthesize passwordLabel;
@synthesize phoneLabel;
@synthesize imageBox;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
    //Get the currently signed-in user
    
    [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth,
                                                    FIRUser *_Nullable user) {
        if (user != nil) {
            // User is signed in.
            
            [self requestProfileInfo];
            
        } else {
            // No user is signed in.
        }
    }];
    
    [self requestProfileInfo];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) requestProfileInfo{

    
    FIRUser *user = [FIRAuth auth].currentUser;
    
    if (user != nil) {

        
        
//        NSURL *url = [NSURL URLWithString: user.photoURL];

//        NSString *filePath = [NSString stringWithFormat:user.photoURL];
//        UIImage *im = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:filePath]]];
        
        NSString *uid = user.uid;  // The user's ID, unique to the Firebase
        // project. Do NOT use this value to
        // authenticate with your backend server, if
        // you have one. Use
        // getTokenWithCompletion:completion: instead.
        
        
    
        NSURL *photosUrl = user.photoURL;
        NSData *imageData = [NSData dataWithContentsOfURL:photosUrl];
        self.imageBox.image = [UIImage imageWithData:imageData];
        
        
        
        self.emailLabel.text = user.email;
        
        NSString *userName = [[NSUserDefaults standardUserDefaults]
                                stringForKey:@"preferenceName"];
        
        self.userLabel.text = userName;
        
//        _ref = [[FIRDatabase database] reference];
//
//        
//        [[[_ref child:@"ProfileImages"] childByAutoId] setValue:mdata];
//
//        
        
        
//        self.imageBox.image = im;
    
        
    } else {
        // No user is signed in.
    }

}

-(void) imagePickerController:(UIImagePickerController *)UIPicker didFinishPickingMediaWithInfo:(NSDictionary *) info
{
    NSURL* localUrl = (NSURL *)[info valueForKey:UIImagePickerControllerReferenceURL];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)logOutButton:(id)sender {
    
    FIRAuth *firebaseAuth = [FIRAuth auth];
    NSError *signOutError;
    BOOL status = [firebaseAuth signOut:&signOutError];
    if (!status) {
        NSLog(@"Error signing out: %@", signOutError);
        return;
    }
    
    [AppState sharedInstance].signedIn = false;
    [self performSegueWithIdentifier:@"SeguesToSignIn" sender:nil];
}
@end
