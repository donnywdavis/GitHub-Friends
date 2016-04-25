//
//  MasterViewController.m
//  GitHubFriends
//
//  Created by Donny Davis on 4/25/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Friend.h"

@interface MasterViewController () <NSURLSessionDelegate>

@property NSMutableArray *friends;
@property NSMutableData *receivedData;

- (IBAction)goToNewItemViewController:(id)sender;
- (void)displayError:(NSString *)error;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.friends = [[NSMutableArray alloc] init];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(goToNewItemViewController:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        // Get the index for the selected cell
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        // Get the friend object from the array
        Friend *friend = self.friends[indexPath.row];
        // Create a controller based on DetailViewController
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        // Pass our selected friend object to the DetailViewController
        [controller setFriendRepos:friend.reposURL];
        // Set the left bar button item in the navigation controller to be a back button if necessary
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

- (IBAction)goToNewItemViewController:(id)sender {
    // Create a UIAlertController to display a popup window to gather input
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add a friend"
                                                                             message:@"Enter a valid github username"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    // Add a text field property to the alert controller
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Username";
    }];
    
    // Add a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"User cancelled");
        
    }];
    
    // Add an action to handle user input when pressing OK
    UIAlertAction *okAlert = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // Get the username from the text field on the alert controller
        UITextField *textField = alertController.textFields.firstObject;
        
        BOOL alreadyFriends = NO;
        for (Friend *friend in self.friends) {
            if ([friend.login isEqualToString:textField.text]) {
                alreadyFriends = YES;
            }
        }
        
        if (!alreadyFriends) {
            // Build our api string with the specified username
            NSString *urlString = [NSString stringWithFormat:@"https://api.github.com/users/%@", textField.text];
        
            // Create a URL object from our string
            NSURL *url = [NSURL URLWithString:urlString];
        
            // Set up a configuration for the session
            // defaultSessionConfiguration will use the current session configuration from the device
            NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
            // Create the session
            // mainQueue uses the main thread of the app. All UI work needs to happen on the main thread
            // This session will exist for the life of the app
            NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
            // The data task will get the data from the url
            NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url];
        
            // Start the data task to start fetching data from the URL
            [dataTask resume];
        } else {
            [self displayError:[NSString stringWithFormat:@"Already friends with %@", textField.text]];
        }
    }];
    
    // Add the action(s) to the alertaViewController
    [alertController addAction:okAlert];
    [alertController addAction:cancelAction];
    
    
    // Present the modal view controller
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell" forIndexPath:indexPath];

    // Grab the friend object from the array to populate the cell data with
    Friend *friend = self.friends[indexPath.row];
    
    // Use the url for the avatar from Github to dislpay a thumbnail image
    NSURL *avatar = [NSURL URLWithString:friend.avatarURL];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:avatar];
    cell.imageView.image = [UIImage imageWithData:imageData];
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = 20.0;
    // Populate the friends name
    cell.textLabel.text = friend.name;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.friends removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    if (!self.receivedData) {
        self.receivedData = [[NSMutableData alloc] initWithData:data];
    } else {
        [self.receivedData appendData:data];
    }
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    if (!error) {
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:self.receivedData options:NSJSONReadingMutableContainers error:nil];
        if (jsonResponse) {
            if (jsonResponse[@"message"]) {
                [self displayError:jsonResponse[@"message"]];
            } else {
                [self.friends addObject:[Friend createFriendWithDictionary:jsonResponse]];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_friends.count - 1 inSection:0];
                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        } else {
            [self displayError:@"User not found"];
        }
        self.receivedData = nil;
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    completionHandler(NSURLSessionResponseAllow);
}

#pragma mark - Error handling

- (void)displayError:(NSString *)error {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Danger Will Robinson" message:error preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
