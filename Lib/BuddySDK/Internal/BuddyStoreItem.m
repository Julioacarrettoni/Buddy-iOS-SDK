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
/// Represents a single, named store item in the Buddy system.
/// </summary>

@implementation BuddyStoreItem

@synthesize client;
@synthesize authUser;
@synthesize appData;
@synthesize customItemId;
@synthesize itemAvailableFlag;
@synthesize itemCost;
@synthesize itemDateTime;
@synthesize itemDescription;
@synthesize itemDownloadUri;
@synthesize itemFreeFlag;
@synthesize itemIconUri;
@synthesize itemName;
@synthesize itemPreviewUri;
@synthesize storeItemId;

- (id)initWithAuthUser:(BuddyClient *)localClient
			  authUser:(BuddyAuthenticatedUser *)localAuthUser
	  storeItemDetails:(NSDictionary *)data
{
	[BuddyUtility checkForNilClientAndUser:localClient user:localAuthUser name:@"BuddyStoreItem"];

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

	appData = [BuddyUtility stringFromString:[data objectForKey:@"appData"]];
	customItemId = [BuddyUtility stringFromString:[data objectForKey:@"customItemID"]];
	itemAvailableFlag = [BuddyUtility boolFromString:[data objectForKey:@"itemAvailableFlag"]];
	itemCost = [BuddyUtility stringFromString:[data objectForKey:@"itemCost"]];
	itemDateTime = [BuddyUtility dateFromString:[data objectForKey:@"itemDateTime"]];
	itemDescription = [BuddyUtility stringFromString:[data objectForKey:@"itemDescription"]];
	itemDownloadUri = [BuddyUtility stringFromString:[data objectForKey:@"itemDownloadUri"]];
	itemFreeFlag = [BuddyUtility boolFromString:[data objectForKey:@"itemFreeFlag"]];
	itemIconUri = [BuddyUtility stringFromString:[data objectForKey:@"itemIconUri"]];
	itemName = [BuddyUtility stringFromString:[data objectForKey:@"itemName"]];
	itemPreviewUri = [BuddyUtility stringFromString:[data objectForKey:@"itemPreviewUri"]];
	storeItemId = [BuddyUtility NSNumberFromStringLong:[data objectForKey:@"storeItemID"]];

	return self;
}

- (void)dealloc
{
	client = nil;
	authUser = nil;
}

-(NSString *)customItemID
{
    return self->customItemId;
}

-(NSNumber *)storeItemID
{
    return self->storeItemId;
}

@end
