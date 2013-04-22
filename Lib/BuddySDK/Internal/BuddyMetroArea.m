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


@implementation BuddyMetroArea

@synthesize client;
@synthesize authUser;
@synthesize iconUrl;
@synthesize imageUrl;
@synthesize metroName;
@synthesize startupCount;

- (id) initMetroArea:(BuddyClient *)localClient
            authUser:(BuddyAuthenticatedUser *)localAuthUser
	metroAreaDetails:(NSDictionary *)data
{
	[BuddyUtility checkForNilClientAndUser:localClient user:localAuthUser name:@"BuddyMetroArea"];


	self = [super init];
	if (!self)
	{
		return nil;
	}

	client = localClient;
	authUser = localAuthUser;

	if (data == nil)
	{
		return self;
	}

	iconUrl  = [BuddyUtility stringFromString:[data objectForKey:@"iconURL"]];
	imageUrl  = [BuddyUtility stringFromString:[data objectForKey:@"imageURL"]];
	metroName = [BuddyUtility stringFromString:[data objectForKey:@"metroName"]];
	startupCount = [BuddyUtility NSNumberFromStringInt:[data objectForKey:@"startupCount"]];

	return self;
}

- (void)dealloc
{
	client = nil;
	authUser = nil;
}

-(NSString *)imageURL
{
    return self->imageUrl;
}

-(NSString *)iconURL
{
    return self->iconUrl;
}

@end
