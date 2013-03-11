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

#import "BuddyClient_Exn.h"
#import "BuddyUtility.h"


/// <summary>
/// Represents an object that describes a single game score entry.
/// </summary>

@implementation BuddyGameScore

@synthesize boardName;
@synthesize addedOn;
@synthesize latitude;
@synthesize longitude;
@synthesize rank;
@synthesize score;
@synthesize userId;
@synthesize userName;
@synthesize appTag;

- (id)initGameScore:(NSDictionary *)gameList;
{
	self = [super init];
	if (!self)
	{
		return nil;
	}

	if (gameList == nil || [gameList count] == 0)
	{
		return self;
	}

	userName = [BuddyUtility stringFromString:[gameList objectForKey:@"userName"]];
	boardName = [BuddyUtility stringFromString:[gameList objectForKey:@"scoreBoardName"]];
	appTag = [BuddyUtility stringFromString:[gameList objectForKey:@"applicationTag"]];
	rank = [BuddyUtility stringFromString:[gameList objectForKey:@"scoreRank"]];
	userId = [BuddyUtility NSNumberFromStringInt:[gameList objectForKey:@"userID"]];
	latitude = [BuddyUtility doubleFromString:[gameList objectForKey:@"scoreLatitude"]];
	longitude = [BuddyUtility doubleFromString:[gameList objectForKey:@"scoreLongitude"]];
	score = [BuddyUtility doubleFromString:[gameList objectForKey:@"scoreValue"]];
	addedOn = [BuddyUtility dateFromString:[gameList objectForKey:@"scoreDate"]];

	return self;
}

@end