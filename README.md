# Homework 08

## GitHub-Friends

### Normal Mode
* [x] Create an app that works very similarly to the GitHubFriends app we build today in class.
* [x] Create a class named Friend and add all of the properties that were received from the github user call. Use the following line to create a URL object for the GitHub API: NSSTring* urlString = [NSString stringWithFormat:@"https://api.github.com/users/%@" , username] // replace username with the user you want to search for.
* [x] Display the name of the GitHub user(s) in a tableview.
* [x] Create another UIAlertController for letting the user know an error occurred
* [x] Use the "repos_url" object to get the list of repos the selected user has.
* [x] Add a tableView to the DetailViewController that contains a cell for every repo that user has in their account.

### Hard Mode
Create a detail View Controller called FriendDetailViewController:

* [ ] Remove the "name" label and move the friend's name into the title of the view.
* [ ] Add an UIImageView property to the view controller and configure it to show the user's avatar. Place it on the screen somewhere. The upper right corner might be a good place, or perhaps below the other labels?