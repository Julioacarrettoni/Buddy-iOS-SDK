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

#import "BuddyMessage.h"
#import "BuddyUtility.h"


/// <summary>
/// Represents a single message that one user sent to another.
/// </summary>

@implementation BuddyMessage

@synthesize dateSent;
@synthesize fromUserId;
@synthesize toUserId;
@synthesize text;

- (id)initFrom:(NSDictionary *)data
      toUserId:(NSNumber *)localToUserId
{
	self = [super init];
	if (!self)
	{
		return nil;
	}

	if (data)
	{
		[self setData:data];
		fromUserId = [BuddyUtility NSNumberFromStringInt:[data objectForKey:@"fromUserID"]];
		toUserId = localToUserId;
	}

	return self;
}

- (id)initTo:(NSDictionary *)data
  fromUserId:(NSNumber *)localFromUserId
{
	self = [super init];
	if (!self)
	{
		return nil;
	}

	if (data)
	{
		[self setData:data];
		fromUserId = localFromUserId;
		toUserId = [BuddyUtility NSNumberFromStringInt:[data objectForKey:@"toUserID"]];
	}

	return self;
}

- (void)setData:(NSDictionary *)data
{
	dateSent = [BuddyUtility dateFromString:[data objectForKey:@"dateSent"]];

	text = [BuddyUtility stringFromString:[data objectForKey:@"messageString"]];
}

@end