//
//  DetailViewController.m
//  GitHubFriends
//
//  Created by Donny Davis on 4/25/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController () <NSURLSessionDelegate>

@property NSMutableData *receivedData;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
        
        // Create a string for the URL that we want to access data from
        NSString *userName = [self.detailItem description];
        NSString *urlString = [NSString stringWithFormat:@"https://api.github.com/users/%@", userName];
        
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
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        NSLog(@"%@", [jsonResponse description]);
    } else {
        NSLog(@"Error url: %@", error);
        
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    completionHandler(NSURLSessionResponseAllow);
}

@end
