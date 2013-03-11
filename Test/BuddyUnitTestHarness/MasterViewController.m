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

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "BuddyCallbackParams.h"
#import "BuddyDataResponses.h"
#import "BuddyClient.h"


@interface MasterViewController ()
{
	NSMutableArray *_objects;
}
@end

@implementation MasterViewController

static NSString *AppName = @"Buddy iOS SDK test app";
static NSString *AppPassword = @"8C9E044D-7DB7-42DE-A376-16460B58008E";

@synthesize detailViewController = _detailViewController;
@synthesize tbx;
@synthesize user;
@synthesize buddyClient;
@synthesize userNameField;
@synthesize userPasswordField;

- (void)awakeFromNib
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
	{
		self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
	}
	[super awakeFromNib];
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	userNameField.delegate = self;
	userPasswordField.delegate = self;
}

- (void)viewDidUnload
{
	[super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
	{
		return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	}
	else
	{
		return YES;
	}
}

- (void)insertNewObject:(id)sender
{
	if (!_objects)
	{
		_objects = [[NSMutableArray alloc] init];
	}
	[_objects insertObject:[NSDate date] atIndex:0];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if ([string isEqualToString:@"\n"])
	{
		[textField resignFirstResponder];
	}
	return YES;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

	NSDate *object = [_objects objectAtIndex:indexPath.row];

	cell.textLabel.text = [object description];

	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		[_objects removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
	else if (editingStyle == UITableViewCellEditingStyleInsert)
	{
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
	{
		NSDate *object = [_objects objectAtIndex:indexPath.row];
		self.detailViewController.detailItem = object;
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}

- (void)setText:(NSString *)text
{
	tbx.text = text;
}

- (IBAction)login:(id)sender
{
	if (buddyClient == nil)
	{
		buddyClient = [[BuddyClient alloc] initClient:AppName
										  appPassword:AppPassword];
	}

	self.user = nil;

	__block BuddyAuthenticatedUser *_user;

	NSString *userName = [userNameField text];
	NSString *password = [userPasswordField text];

	[buddyClient login:userName
			  password:password
				 state:nil callback:[^(BuddyAuthenticatedUserResponse *response)
									 {
										 if (response.isCompleted)
										 {
											 _user = response.result;
											 dispatch_async(dispatch_get_main_queue(), ^
															{
																[self saveUser:_user];
															});
										 }
										 else
										 {
											 [self setText:@"Login failed."];
											 NSLog(@"login failed");
										 }
									 } copy]];
}

- (void)saveUser:(BuddyAuthenticatedUser *)buser
{
	[self setText:@"Login ok."];
	self.user = buser;
}

@end