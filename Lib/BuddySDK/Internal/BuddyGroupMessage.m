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

#import "BuddyGroupMessage.h"
#import "BuddyUtility.h"


/// <summary>
/// Represents a message that was sent to a group of users through AuthenticatedUser.messages.groups.SendMessage.
/// </summary>

@implementation BuddyGroupMessage

@synthesize text;
@synthesize latitude;
@synthesize longitude;
@synthesize fromUserID;
@synthesize dateSent;
@synthesize group;

- (id)initWithData:(NSDictionary *)data
			 group:(BuddyMessageGroup *)localGroup
{
	self = [super init];
	if (!self)
	{
		return nil;
	}

	group = localGroup;

	if (data != nil)
	{
		dateSent = [BuddyUtility buddyDate:[data objectForKey:@"sentDateTime"]];
		latitude = [BuddyUtility doubleFromString:[data objectForKey:@"latitude"]];
		longitude = [BuddyUtility doubleFromString:[data objectForKey:@"longitude"]];
		text = [BuddyUtility stringFromString:[data objectForKey:@"messageText"]];
		fromUserID = [BuddyUtility NSNumberFromStringInt:[data objectForKey:@"fromUserID"]];
	}

	return self;
}

@end