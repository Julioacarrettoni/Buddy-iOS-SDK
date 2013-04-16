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
/// Represents a game player object.
/// </summary>

@implementation BuddyGamePlayer

@synthesize name;
@synthesize createdOn;
@synthesize boardName;
@synthesize applicationTag;
@synthesize latitude;
@synthesize longitude;
@synthesize userId;
@synthesize distanceInKilometers;
@synthesize distanceInMeters;
@synthesize distanceInMiles;
@synthesize distanceInYards;
@synthesize rank;

- (id)initWithUser:(BuddyAuthenticatedUser *)authUser
	gamePlayerInfo:(NSDictionary *)data
{
	[BuddyUtility checkForNilUser:authUser name:@"BuddyGamePlayer"];

	self = [super init];
	if (!self)
	{
		return nil;
	}

	userId = authUser.userId;

	if (data)
	{
		name = [BuddyUtility stringFromString:[data objectForKey:@"playerName"]];
		createdOn = [BuddyUtility dateFromString:[data objectForKey:@"playerDate"]];
		boardName = [BuddyUtility stringFromString:[data objectForKey:@"playerBoardName"]];
		userId = [BuddyUtility NSNumberFromStringInt:[data objectForKey:@"userID"]];
		latitude = [BuddyUtility doubleFromString:[data objectForKey:@"playerLatitude"]];
		longitude = [BuddyUtility doubleFromString:[data objectForKey:@"playerLongitude"]];
		applicationTag = [BuddyUtility stringFromString:[data objectForKey:@"applicationTag"]];
		rank = [BuddyUtility stringFromString:[data objectForKey:@"playerRank"]];
	}

	return self;
}

- (id)             initWithUser:(BuddyAuthenticatedUser *)authUser
	gamePlayerInfoSearchResults:(NSDictionary *)data
{
	[BuddyUtility checkForNilUser:authUser name:@"BuddyGamePlayer"];

	self = [super init];
	if (!self)
	{
		return nil;
	}

	if (data)
	{
		userId = [BuddyUtility NSNumberFromStringInt:[data objectForKey:@"userID"]];
		createdOn = [BuddyUtility dateFromString:[data objectForKey:@"playerDate"]];
		boardName = [BuddyUtility stringFromString:[data objectForKey:@"playerBoardName"]];
		name = [BuddyUtility stringFromString:[data objectForKey:@"playerName"]];
		applicationTag = [BuddyUtility stringFromString:[data objectForKey:@"applicationTag"]];
		latitude = [BuddyUtility doubleFromString:[data objectForKey:@"playerLatitude"]];
		longitude = [BuddyUtility doubleFromString:[data objectForKey:@"playerLongitude"]];
		distanceInKilometers = [BuddyUtility doubleFromString:[data objectForKey:@"distanceInKiloMeters"]];
		distanceInMeters = [BuddyUtility doubleFromString:[data objectForKey:@"distanceInMeters"]];
		distanceInMiles = [BuddyUtility doubleFromString:[data objectForKey:@"distanceInMiles"]];
		distanceInYards = [BuddyUtility doubleFromString:[data objectForKey:@"distanceInYards"]];
		rank = [BuddyUtility stringFromString:[data objectForKey:@"playerRank"]];
	}

	return self;
}

@end