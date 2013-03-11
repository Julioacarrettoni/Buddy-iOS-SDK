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
/// Represents a single picture on the Buddy Platform. This is a public view of a picture, can be retrieved either by getting a user's profile picture or
/// by searching for albums.
/// </summary>

@implementation BuddyPicturePublic

@synthesize fullUrl = _fullUrl;
@synthesize thumbnailUrl = _thumbnailUrl;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize comment = _comment;
@synthesize appTag = _appTag;
@synthesize addedOn = _addedOn;
@synthesize photoId = _photoId;
@synthesize distanceInKilometers = _distanceInKilometers;
@synthesize distanceInMeters = _distanceInMeters;
@synthesize distanceInMiles = _distanceInMiles;
@synthesize distanceInYards = _distanceInYards;
@synthesize client = _client;
@synthesize user = _user;
@synthesize owner = _owner;
@synthesize userId = _userId;

- (id)initPicturePublic:(BuddyClient *)client
		publicPhotoData:(NSDictionary *)photoData
				   user:(BuddyUser *)user;
{
	[BuddyUtility checkForNilClientAndUser:client user:user name:@"BuddyPicturePublic"];

	self = [super init];
	if (!self)
	{
		return nil;
	}

	_client = client;
	_user = user;

	if (photoData != nil && [photoData count] > 0)
	{
		[self fillParams:photoData];
		_addedOn = [BuddyUtility dateFromString:[photoData objectForKey:@"addedDateTime"]];
	}

	return self;
}

- (id)initPicturePublic:(BuddyClient *)client
				fullUrl:(NSString *)fullUrl
		   thumbnailUrl:(NSString *)thumbUrl
			   latitude:(double)latitude
			  longitude:(double)longitude
				comment:(NSString *)comment
				 appTag:(NSString *)appTag
				addedOn:(NSDate *)addedOn
				photoID:(NSNumber *)photoID
				   user:(BuddyUser *)user
{
	[BuddyUtility checkForNilClientAndUser:client user:user name:@"BuddyPicturePublic"];

	self = [super init];
	if (!self)
	{
		return nil;
	}

	_client = client;
	_user = user;
	_fullUrl = (fullUrl == nil) ? @"" : fullUrl;
	_thumbnailUrl = (thumbUrl == nil) ? @"" : thumbUrl;
	_comment = (comment == nil) ? @"" : comment;
	_appTag = (appTag == nil) ? @"" : appTag;
	_latitude = latitude;
	_longitude = longitude;
	_photoId = photoID;
	_addedOn = (addedOn == nil) ? [[NSDate alloc] init] : addedOn;

	return self;
}

- (id)initPicturePublic:(BuddyClient *)client
                   user:(BuddyUser *)user
  publicPhotoSearchData:(NSDictionary *)photoSearchData
                 userId:(NSNumber *)userId
               authUser:(BuddyAuthenticatedUser *)searchOwner
{
	[BuddyUtility checkForNilClient:client name:@"BuddyPicturePublic"];

	if (photoSearchData == nil)
	{
		[BuddyUtility throwNilArgException:@"BuddyPicturePublic" reason:@"PublicPhotoSearchData"];
	}

	self = [super init];
	if (!self)
	{
		return nil;
	}

	_client = client;
	_user = user;
	_userId = userId;
	_owner = searchOwner;

	[self fillParams:photoSearchData];
	_addedOn = [BuddyUtility dateFromString:[photoSearchData objectForKey:@"photoAdded"]];

	return self;
}

- (void)dealloc
{
	_client = nil;
	_user = nil;
}

- (id)initPicturePublic:(BuddyClient *)client
	   virtualPhotoList:(NSDictionary *)virtualPhotoSearchData
{
	[BuddyUtility checkForNilClient:client name:@"BuddyPicturePublic"];

	if (virtualPhotoSearchData == nil)
	{
		[BuddyUtility throwNilArgException:@"BuddyPicturePublic" reason:@"VirtualPhotoList"];
	}

	self = [super init];
	if (!self)
	{
		return nil;
	}

	_client = client;

	[self fillParams:virtualPhotoSearchData];

	_addedOn = [BuddyUtility dateFromString:[virtualPhotoSearchData objectForKey:@"addedDateTime"]];
	_userId = [BuddyUtility NSNumberFromStringInt:[virtualPhotoSearchData objectForKey:@"userID"]];

	return self;
}

- (void)fillParams:(NSDictionary *)data
{
	_fullUrl = [BuddyUtility stringFromString:[data objectForKey:@"fullPhotoURL"]];
	_thumbnailUrl = [BuddyUtility stringFromString:[data objectForKey:@"thumbnailPhotoURL"]];
	_appTag = [BuddyUtility stringFromString:[data objectForKey:@"applicationTag"]];
	_latitude = [BuddyUtility doubleFromString:[data objectForKey:@"latitude"]];
	_longitude = [BuddyUtility doubleFromString:[data objectForKey:@"longitude"]];
	_photoId = [BuddyUtility NSNumberFromStringInt:[data objectForKey:@"photoID"]];
	_distanceInMiles = [BuddyUtility doubleFromString:[data objectForKey:@"distanceInMiles"]];
	_distanceInMeters = [BuddyUtility doubleFromString:[data objectForKey:@"distanceInMeters"]];
	_distanceInYards = [BuddyUtility doubleFromString:[data objectForKey:@"distanceInYards"]];
	_distanceInKilometers = [BuddyUtility doubleFromString:[data objectForKey:@"distanceInKilometers"]];
	_comment = [BuddyUtility stringFromString:[data objectForKey:@"photoComment"]];
}

@end