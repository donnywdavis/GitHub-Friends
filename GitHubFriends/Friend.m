//
//  Friend.m
//  GitHubFriends
//
//  Created by Donny Davis on 4/25/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

#import "Friend.h"

@implementation Friend

+ (Friend *)createFriendWithDictionary:(NSDictionary *)friendDictionary {
    Friend *newFriend = nil;
    if (friendDictionary) {
        newFriend = [[Friend alloc] init];
        newFriend.avatarURL = friendDictionary[@"avatar_url"];
        newFriend.bio = friendDictionary[@"bio"];
        newFriend.blog = friendDictionary[@"blog"];
        newFriend.company = friendDictionary[@"company"];
        newFriend.createdAt = friendDictionary[@"created_at"];
        newFriend.email = friendDictionary[@"email"];
        newFriend.eventsURL = friendDictionary[@"events_url"];
        newFriend.followers = friendDictionary[@"followers"];
        newFriend.followersURL = friendDictionary[@"followers_url"];
        newFriend.following = friendDictionary[@"following"];
        newFriend.followingURL = friendDictionary[@"following_url"];
        newFriend.gistsURL = friendDictionary[@"gists_url"];
        newFriend.gravatarID = friendDictionary[@"gravatar_id"];
        newFriend.hireable = friendDictionary[@"hireable"];
        newFriend.htmlURL = friendDictionary[@"html_url"];
        newFriend.userID = friendDictionary[@"id"];
        newFriend.location = friendDictionary[@"location"];
        newFriend.login = friendDictionary[@"login"];
        newFriend.name = friendDictionary[@"name"];
        newFriend.organizationURL = friendDictionary[@"organization_url"];
        newFriend.publicGists = friendDictionary[@"public_gists"];
        newFriend.publicRepos = friendDictionary[@"public_repos"];
        newFriend.receivedEventsURL = friendDictionary[@"received_events_url"];
        newFriend.reposURL = friendDictionary[@"repos_url"];
        newFriend.siteAdmin = friendDictionary[@"site_admin"];
        newFriend.starredURL = friendDictionary[@"starred_url"];
        newFriend.subscriptionURL = friendDictionary[@"subscription_url"];
        newFriend.type = friendDictionary[@"type"];
        newFriend.url = friendDictionary[@"url"];
    }
    
    return newFriend;
}

@end
