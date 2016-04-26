//
//  DetailViewController.m
//  GitHubFriends
//
//  Created by Donny Davis on 4/25/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

#import "DetailViewController.h"
#import "RepoTableViewCell.h"

@interface DetailViewController () <NSURLSessionDelegate>

@property NSMutableData *receivedData;
@property NSMutableArray *repos;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setFriendRepos:(NSString *)newFriendRepos {
    if (_friendRepos != newFriendRepos) {
        _friendRepos = newFriendRepos;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.friendRepos) {
        // Create a URL object from our string
        NSURL *url = [NSURL URLWithString:self.friendRepos];
        
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
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Repos: 0";
    self.repos = [[NSMutableArray alloc] init];
    [self.tableView registerClass:[RepoTableViewCell class] forCellReuseIdentifier:@"RepoCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.repos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RepoCell" forIndexPath:indexPath];
    
    // Grab the friend object from the array to populate the cell data with
    NSString *repo = self.repos[indexPath.row][@"name"];
    
    // Populate the friends name
    cell.textLabel.text = repo;
    
    return cell;
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
        NSArray *jsonResponse = [NSJSONSerialization JSONObjectWithData:self.receivedData options:NSJSONReadingMutableContainers error:nil];
        if (jsonResponse) {
            self.repos = [jsonResponse mutableCopy];
            self.title = [NSString stringWithFormat:@"%@ Repos: %lu", self.repos[0][@"owner"][@"login"], (unsigned long)self.repos.count];
            [self.tableView reloadData];
        }
    }
    self.receivedData = nil;
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    completionHandler(NSURLSessionResponseAllow);
}

@end
