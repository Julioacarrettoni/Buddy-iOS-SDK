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
#import "BuddyWebWrapper.h"


/// <summary>
/// Represents a single, named location in the Buddy system that's not a user. Locations are related to stores, hotels, parks, etc.
/// </summary>

@implementation BuddyPlace

@synthesize client;
@synthesize authUser;
@synthesize address;
@synthesize appTagData;
@synthesize categoryId;
@synthesize categoryName;
@synthesize city;
@synthesize createdDate;
@synthesize distanceInKiloMeters;
@synthesize distanceInMeters;
@synthesize distanceInMiles;
@synthesize distanceInYards;
@synthesize fax;
@synthesize placeId;
@synthesize latitude;
@synthesize longitude;
@synthesize name;
@synthesize postalState;
@synthesize postalZip;
@synthesize region;
@synthesize shortId;
@synthesize telephone;
@synthesize touchedDate;
@synthesize userTagData;
@synthesize website;

- (id)initPlace:(BuddyClient *)localClient
	   authUser:(BuddyAuthenticatedUser *)localAuthUser
   placeDetails:(NSDictionary *)data;
{
	[BuddyUtility checkForNilClientAndUser:localClient user:localAuthUser name:@"BuddyPlace"];

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

	address = [BuddyUtility stringFromString:[data objectForKey:@"address"]];
	appTagData = [BuddyUtility stringFromString:[data objectForKey:@"appTagData"]];
	categoryId = [BuddyUtility NSNumberFromStringInt:[data objectForKey:@"categoryID"]];
	categoryName = [BuddyUtility stringFromString:[data objectForKey:@"categoryName"]];
	city = [BuddyUtility stringFromString:[data objectForKey:@"city"]];
	createdDate = [BuddyUtility dateFromString:[data objectForKey:@"createdDate"]];
	distanceInKiloMeters = [BuddyUtility doubleFromString:[data objectForKey:@"distanceInKiloMeters"]];
	distanceInMeters = [BuddyUtility doubleFromString:[data objectForKey:@"distanceInMeters"]];
	distanceInMiles = [BuddyUtility doubleFromString:[data objectForKey:@"distanceInMiles"]];
	distanceInYards = [BuddyUtility doubleFromString:[data objectForKey:@"distanceInYards"]];
	fax = [BuddyUtility stringFromString:[data objectForKey:@"fax"]];
	placeId = [BuddyUtility NSNumberFromStringInt:[data objectForKey:@"geoID"]];
	latitude = [BuddyUtility doubleFromString:[data objectForKey:@"latitude"]];
	longitude = [BuddyUtility doubleFromString:[data objectForKey:@"longitude"]];
	name = [BuddyUtility stringFromString:[data objectForKey:@"name"]];
	postalState = [BuddyUtility stringFromString:[data objectForKey:@"postalState"]];
	postalZip = [BuddyUtility stringFromString:[data objectForKey:@"postalZip"]];
	region = [BuddyUtility stringFromString:[data objectForKey:@"region"]];
	shortId = [BuddyUtility stringFromString:[data objectForKey:@"shortID"]];
	telephone = [BuddyUtility stringFromString:[data objectForKey:@"telephone"]];
	touchedDate = [BuddyUtility dateFromString:[data objectForKey:@"touchedDate"]];
	userTagData = [BuddyUtility stringFromString:[data objectForKey:@"userTagData"]];
	website = [BuddyUtility stringFromString:[data objectForKey:@"website"]];

	return self;
}

- (void)dealloc
{
	client = nil;
	authUser = nil;
}

- (void)setTag:(NSString *)appTag
       userTag:(NSString *)userTag
         
      callback:(BuddyPlaceSetTagCallback)callback
{
    [[client webService] GeoLocation_Location_SetTag:authUser.token ExistingGeoID:placeId ApplicationTag:appTag UserTag:userTag RESERVED:@""  callback:[^(BuddyCallbackParams *callbackParams, id jsonArray) {
        if (callback) {
            callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
        }
    } copy]];
}

@end