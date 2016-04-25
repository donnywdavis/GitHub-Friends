//
//  Friend.h
//  GitHubFriends
//
//  Created by Donny Davis on 4/25/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Friend : NSObject

@property (nonatomic) NSString *avatarURL;
@property (nonatomic) NSString *bio;
@property (nonatomic) NSString *blog;
@property (nonatomic) NSString *company;
@property (nonatomic) NSString *createdAt;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *eventsURL;
@property (nonatomic) NSString *followers;
@property (nonatomic) NSString *followersURL;
@property (nonatomic) NSString *following;
@property (nonatomic) NSString *followingURL;
@property (nonatomic) NSString *gistsURL;
@property (nonatomic) NSString *gravatarID;
@property (nonatomic) NSString *hireable;
@property (nonatomic) NSString *htmlURL;
@property (nonatomic) NSString *userID;
@property (nonatomic) NSString *location;
@property (nonatomic) NSString *login;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *organizationURL;
@property (nonatomic) NSString *publicGists;
@property (nonatomic) NSString *publicRepos;
@property (nonatomic) NSString *receivedEventsURL;
@property (nonatomic) NSString *reposURL;
@property (nonatomic) NSString *siteAdmin;
@property (nonatomic) NSString *starredURL;
@property (nonatomic) NSString *subscriptionURL;
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *updatedAt;
@property (nonatomic) NSString *url;

+ (Friend *)createFriendWithDictionary:(NSDictionary *)friendDictionary;

@end
