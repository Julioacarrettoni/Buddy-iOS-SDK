/*
 * Copyright (C) 2012 Buddy Platform, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */

#import <UIKit/UIKit.h>


@class DetailViewController;
@class BuddyPicture;
@class BuddyAuthenticatedUser;
@class BuddyPhotoAlbum;
@class BuddyClient;


@interface MasterViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (nonatomic, strong) BuddyAuthenticatedUser *user;

@property (nonatomic, strong) BuddyClient *buddyClient;

@property (retain) IBOutlet UILabel *tbx;

@property (retain) IBOutlet UITextField *userNameField;

@property (retain) IBOutlet UITextField *userPasswordField;

- (void)saveUser:(BuddyAuthenticatedUser *)buser;

- (IBAction)login:(id)sender;

@end