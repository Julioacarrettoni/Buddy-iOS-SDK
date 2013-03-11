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
/// Returns a collection of high level statistics showing the current usage levels of the application. The data returned includes items such as total users, photos, etc.
/// </summary>

@implementation BuddyApplicationStatistics

@synthesize totalUsers;
@synthesize totalPhotos;
@synthesize totalUserCheckins;
@synthesize totalUserMetadata;
@synthesize totalAppMetadata;
@synthesize totalFriends;
@synthesize totalAlbums;
@synthesize totalCrashes;
@synthesize totalMessages;
@synthesize totalPushMessages;
@synthesize totalGamePlayers;
@synthesize totalGameScores;
@synthesize totalDeviceInformation;

@synthesize client;

- (id)initAppData:(BuddyClient *)localClient statsData:(NSDictionary *)data
{
    [BuddyUtility checkForNilClient:localClient name:@"BuddyApplicationStatistics"];

	self = [super init];
	if (!self)
	{
		return nil;
	}

	client = localClient;
    
	if (data)
	{
		totalUsers = [BuddyUtility stringFromString:[data objectForKey:@"totalUsers"]];
		totalPhotos = [BuddyUtility stringFromString:[data objectForKey:@"totalPhotos"]];
		totalUserCheckins = [BuddyUtility stringFromString:[data objectForKey:@"totalUserCheckins"]];
		totalUserMetadata = [BuddyUtility stringFromString:[data objectForKey:@"totalUserMetadata"]];
		totalAppMetadata = [BuddyUtility stringFromString:[data objectForKey:@"totalAppMetadata"]];
		totalFriends = [BuddyUtility stringFromString:[data objectForKey:@"totalFriends"]];
		totalAlbums = [BuddyUtility stringFromString:[data objectForKey:@"totalAlbums"]];
		totalCrashes = [BuddyUtility stringFromString:[data objectForKey:@"totalCrashes"]];
		totalMessages = [BuddyUtility stringFromString:[data objectForKey:@"totalMessages"]];
		totalPushMessages = [BuddyUtility stringFromString:[data objectForKey:@"totalPushMessages"]];
		totalGamePlayers = [BuddyUtility stringFromString:[data objectForKey:@"totalGamePlayers"]];
		totalGameScores = [BuddyUtility stringFromString:[data objectForKey:@"totalGameScores"]];
		totalDeviceInformation = [BuddyUtility stringFromString:[data objectForKey:@"totalDeviceInformation"]];
	}

	return self;
}

- (void)dealloc
{
	client = nil;
}

@end
