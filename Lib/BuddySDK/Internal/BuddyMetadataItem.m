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
#import "BuddyDataResponses_Exn.h"
#import "BuddyUtility.h"


/// <summary>
/// Represents a single item of metadata. Metadata is used to store custom key/value pairs at the application or user level.
/// </summary>

@implementation BuddyMetadataItem

@synthesize key;
@synthesize value;
@synthesize latitude;
@synthesize longitude;
@synthesize lastUpdateOn;
@synthesize applicationTag;
@synthesize distanceOriginLatitude;
@synthesize distanceOriginLongitude;
@synthesize distanceInKilometers;
@synthesize distanceInMeters;
@synthesize distanceInMiles;
@synthesize distanceInYards;
@synthesize client;
@synthesize owner;
@synthesize ownerApp;
@synthesize token;

- (id)initUserMetaItem:(BuddyClient *)localClient
			  userMeta:(BuddyUserMetadata *)localOwner
		   appMetadata:(BuddyAppMetadata *)localOwnerApp
				 token:(NSString *)localToken
	searchUserMetadata:(NSDictionary *)data
		  origLatitude:(double)localLatitude
		 origLongitude:(double)localLongitude
{
	self = [super init];
	if (!self)
	{
		return nil;
	}

	client = localClient;
	owner = localOwner;
	ownerApp = localOwnerApp;
	token = localToken;

	distanceOriginLatitude = localLatitude;
	distanceOriginLongitude = localLongitude;

	if (data)
	{
		[self setUp:data];
	}

	return self;
}

- (void)dealloc
{
	client = nil;
	owner = nil;
	ownerApp = nil;
	token = nil;
}

- (id)initAppMetaItem:(BuddyClient *)localClient
			 userMeta:(BuddyUserMetadata *)localOwner
		  appMetadata:(BuddyAppMetadata *)localOwnerApp
				token:(NSString *)localToken
	searchAppMetadata:(NSDictionary *)data
		 origLatitude:(double)localLatitude
		origLongitude:(double)localLongitude
{
	self = [super init];
	if (!self)
	{
		return nil;
	}

	client = localClient;
	owner = localOwner;
	ownerApp = localOwnerApp;
	token = localToken;

	distanceOriginLatitude = localLatitude;
	distanceOriginLongitude = localLongitude;

	if (data)
	{
		[self setUp:data];
	}

	return self;
}

- (void)setUp:(NSDictionary *)dict
{
	key = [BuddyUtility stringFromString:[dict objectForKey:@"metaKey"]];
	value = [BuddyUtility stringFromString:[dict objectForKey:@"metaValue"]];
	latitude = [BuddyUtility doubleFromString:[dict objectForKey:@"metaLatitude"]];
	longitude = [BuddyUtility doubleFromString:[dict objectForKey:@"metaLongitude"]];
	lastUpdateOn = [BuddyUtility dateFromString:[dict objectForKey:@"lastUpdateDate"]];
	distanceInKilometers = [BuddyUtility doubleFromString:[dict objectForKey:@"distanceInKilometers"]];
	distanceInMeters = [BuddyUtility doubleFromString:[dict objectForKey:@"distanceInMeters"]];
	distanceInMiles = [BuddyUtility doubleFromString:[dict objectForKey:@"distanceInMiles"]];
	distanceInYards = [BuddyUtility doubleFromString:[dict objectForKey:@"distanceInYards"]];
}

- (int)compareTo:(BuddyMetadataItem *)other
{
	if ([other.key isEqualToString:self.key] && [other.value isEqualToString:self.value])
	{
		return 0;
	}

	if ([self.key isEqualToString:other.key])
	{
		return 0;
	}

	return 1;
}

- (void) set:(NSString *)localValue
	callback:(BuddyMetadataItemSetCallback)callback
{
	[self set:localValue latitude:0.0 longitude:0.0 appTag:nil state:nil callback:callback];
}

- (void)  set:(NSString *)localValue
	 latitude:(double)localLatitude
	longitude:(double)localLongitude
	   appTag:(NSString *)appTag
		state:(NSObject *)state
	 callback:(BuddyMetadataItemSetCallback)callback
{
	if (owner)
	{
		[self.owner set:self.key value:localValue latitude:localLatitude longitude:localLongitude appTag:appTag state:state callback:callback];
	}
	else
	{
		[self.ownerApp set:self.key value:localValue latitude:localLatitude longitude:localLongitude appTag:appTag state:state callback:callback];
	}
}

- (void)delete:(NSObject *)state
	  callback:(BuddyMetadataItemDeleteCallback)callback
{
	if (owner)
	{
		[self.owner delete:self.key state:state callback:callback];
	}
	else
	{
		[self.ownerApp delete:self.key state:state callback:callback];
	}
}

@end