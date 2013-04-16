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

@implementation BuddyStartup

@synthesize client;
@synthesize authUser;
@synthesize centerLat;
@synthesize centerLong;
@synthesize city;
@synthesize crunchBaseUrl;
@synthesize customData;
@synthesize distanceInKilometers;
@synthesize distanceInMeters;
@synthesize distanceInMiles;
@synthesize distanceInYards;
@synthesize employeeCount;
@synthesize fundingSource;
@synthesize facebookUrl;
@synthesize homePageUrl;
@synthesize industry;
@synthesize linkedinUrl;
@synthesize logoUrl;
@synthesize metroLocation;
@synthesize phoneNumber;
@synthesize startupName;
@synthesize state;
@synthesize streetAddress;
@synthesize startupId;
@synthesize totalFundingRaised;
@synthesize twitterUrl;
@synthesize zipPostal;


- (id)initStartup:(BuddyClient *)localClient 
         authUser:(BuddyAuthenticatedUser *)localAuthUser
   startupDetails:(NSDictionary*)data
{
    [BuddyUtility checkForNilClientAndUser:localClient user:localAuthUser name:@"BuddyStartup"];
    
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

    city = [BuddyUtility stringFromString:[data objectForKey:@"city"]];
    crunchBaseUrl = [BuddyUtility stringFromString:[data objectForKey:@"crunchBaseUrl"]];
    customData = [BuddyUtility stringFromString:[data objectForKey:@"customData"]];
    centerLat = [BuddyUtility doubleFromString:[data objectForKey:@"centerLat"]];
    centerLong = [BuddyUtility doubleFromString:[data objectForKey:@"centerLong"]];    
    distanceInKilometers = [BuddyUtility doubleFromString:[data objectForKey:@"distanceInKiloMeters"]];
	distanceInMeters = [BuddyUtility doubleFromString:[data objectForKey:@"distanceInMeters"]];
	distanceInMiles = [BuddyUtility doubleFromString:[data objectForKey:@"distanceInMiles"]];
	distanceInYards = [BuddyUtility doubleFromString:[data objectForKey:@"distanceInYards"]];
    employeeCount = [BuddyUtility  intFromString:[data objectForKey:@"employeeCount"]];      
    fundingSource = [BuddyUtility stringFromString:[data objectForKey:@"fundingSource"]];
    homePageUrl = [BuddyUtility stringFromString:[data objectForKey:@"homePageURL"]];
    industry = [BuddyUtility stringFromString:[data objectForKey:@"Industry"]];
    linkedinUrl = [BuddyUtility stringFromString:[data objectForKey:@"linkedinURL"]];
    logoUrl = [BuddyUtility stringFromString:[data objectForKey:@"LogoURL"]];
    metroLocation = [BuddyUtility stringFromString:[data objectForKey:@"metroLocation"]];
    phoneNumber = [BuddyUtility stringFromString:[data objectForKey:@"phoneNumber"]];
    startupName = [BuddyUtility stringFromString:[data objectForKey:@"startupName"]];
    state = [BuddyUtility stringFromString:[data objectForKey:@"state"]];
    streetAddress = [BuddyUtility stringFromString:[data objectForKey:@"streetAddress"]];
    startupId = [BuddyUtility NSNumberFromStringLong:[data objectForKey:@"startupID"]];
    totalFundingRaised = [BuddyUtility NSNumberFromStringInt:[data objectForKey:@"totalFundingRaised"]];
    twitterUrl = [BuddyUtility stringFromString:[data objectForKey:@"twitterURL"]];
    zipPostal  = [BuddyUtility doubleFromString:[data objectForKey:@"zipPostal"]];    
    
    return self;
}


- (void)dealloc
{
    client = nil;
    authUser = nil;
}

@end
