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

#import "TestBuddySDK.h"
#import "TestLocationsAndPlaces.h"
#import "BuddyDataResponses.h"
#import "BuddyBoolResponse.h"
#import "BuddyClient.h"
#import "BuddyPhotoAlbum.h"
#import "BuddyPlace.h"


@implementation TestLocationsAndPlaces

@synthesize places;
@synthesize user;
@synthesize categoryDict;
@synthesize flagId;
@synthesize buddyClient;

static NSString *AppName = @"Buddy iOS SDK test app";
static NSString *AppPassword = @"8C9E044D-7DB7-42DE-A376-16460B58008E";
static bool bwaiting = false;
static NSString *Token = @"UT-76444f9f-4a4b-4d3d-ba5c-7a82b5dbb5a5";

- (void)setUp
{
    [super setUp];

    self.buddyClient = [[BuddyClient alloc] initClient:AppName
                                           appPassword:AppPassword
                                            appVersion:@"1"
                                  autoRecordDeviceInfo:TRUE];

    STAssertNotNil(self.buddyClient, @"TestLocationsAndPlaces setUp failed buddyClient nil");
}

- (void)tearDown
{
    [super tearDown];

    self.buddyClient = nil;
}

- (void)waitloop
{
    NSDate *loopTil = [NSDate dateWithTimeIntervalSinceNow:60];

    while (bwaiting && [loopTil timeIntervalSinceNow] > 0)
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopTil];
}

- (void)aLogin
{
    [self.buddyClient login:Token state:nil callback:[^(BuddyAuthenticatedUserResponse *response)
    {
        if (response.isCompleted)
        {
            self.user = response.result;
            NSLog(@"aLogin OK user: %@", self.user.toString);
        }
        else
        {
            STFail(@"alogin failed !response.isCompleted");
        }
        bwaiting = false;
    } copy]];
}

- (void)testBuddyPlacesCatergoryParsing
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_GeoLocationCategoryList"];

    bwaiting = true;
    [self aLogin];
    [self waitloop];

    if (!self.user)
    {
        STFail(@"testBuddyPlacesCatergoryParsing login failed.");
        return;
    }

    NSDictionary *dict = [self.user.places performSelector:@selector(makeCategoryDictionary:) withObject:resArray];
    if (dict == nil)
    {
        STFail(@"testBuddyPlacesCatergoryParsing failed") ;
    }

    resArray = [TestBuddySDK GetTextFileData:@"Test_NoData"];
    dict = [self.user.places performSelector:@selector(makeCategoryDictionary:) withObject:resArray];
    if (dict == nil)
    {
        STFail(@"testBuddyPlacesCatergoryParsing failed NoData") ;
    }

    resArray = [TestBuddySDK GetTextFileData:@"Test_EmptyData"];
    dict = [self.user.places performSelector:@selector(makeCategoryDictionary:) withObject:resArray];
    if (dict == nil)
    {
        STFail(@"testBuddyPlacesCatergoryParsing failed Test_EmptyData") ;
    }
}

- (void)testBuddyPlacesLocationSearchParsing
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_LocationSearch"];

    bwaiting = true;
    [self aLogin];
    [self waitloop];

    if (!self.user)
    {
        STFail(@"testBuddyPlacesLocationSearchParsing login failed.");
        return;
    }


    BuddyPlace *place = [self.user.places performSelector:@selector(makeBuddyPlace:) withObject:resArray];
    if (place == nil)
    {
        STFail(@"testBuddyPlacesLocationSearchParsing failed") ;
    }

    resArray = [TestBuddySDK GetTextFileData:@"Test_NoData"];
    place = [self.user.places performSelector:@selector(makeBuddyPlace:) withObject:resArray];
    if (place != nil)
    {
        STFail(@"testBuddyPlacesLocationSearchParsing failed NoData") ;
    }

    resArray = [TestBuddySDK GetTextFileData:@"Test_EmptyData"];
    place = [self.user.places performSelector:@selector(makeBuddyPlace:) withObject:resArray];
    if (place != nil)
    {
        STFail(@"testBuddyPlacesLocationSearchParsing failed Test_EmptyData") ;
    }
}

- (void)testBuddyPlacesGeoLocationLocationSearchParsing
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_GeoLocationLocationSearch"];

    bwaiting = true;
    [self aLogin];
    [self waitloop];

    if (!self.user)
    {
        STFail(@"testBuddyPlacesGeoLocationLocationSearchParsing login failed.");
        return;
    }

    NSArray *placeList = [self.user.places performSelector:@selector(makeBuddyPlaceList:) withObject:resArray];
    if (placeList == nil || [placeList count] != 3)
    {
        STFail(@"testBuddyPlacesGeoLocationLocationSearchParsing") ;
    }

    resArray = [TestBuddySDK GetTextFileData:@"Test_NoData"];
    placeList = [self.user.places performSelector:@selector(makeBuddyPlaceList:) withObject:resArray];
    if (placeList == nil || [placeList count] != 0)
    {
        STFail(@"testBuddyPlacesGeoLocationLocationSearchParsing NoData") ;
    }

    resArray = [TestBuddySDK GetTextFileData:@"Test_EmptyData"];
    placeList = [self.user.places performSelector:@selector(makeBuddyPlaceList:) withObject:resArray];
    if (placeList == nil || [placeList count] != 0)
    {
        STFail(@"testBuddyPlacesGeoLocationLocationSearchParsing EmptyData") ;
    }
}

- (void)testBuddyLocationParseLocationHistoryJsonData
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_CheckInLocations"];

    bwaiting = true;
    [self aLogin];
    [self waitloop];

    if (!self.user)
    {
        STFail(@"testBuddyLocationParseLocationHistoryJsonData login failed.");
        return;
    }

    NSArray *locations = [self.user performSelector:@selector(makeLocationList:) withObject:resArray];
    if (locations == nil || [locations count] != 2)
    {
        STFail(@"testBuddyLocationParseLocationHistoryJsonData") ;
    }

    resArray = [TestBuddySDK GetTextFileData:@"Test_NoData"];
    locations = [self.user performSelector:@selector(makeLocationList:) withObject:resArray];
    if (locations == nil || [locations count] != 0)
    {
        STFail(@"testBuddyLocationParseLocationHistoryJsonData NoData") ;
    }

    resArray = [TestBuddySDK GetTextFileData:@"Test_EmptyData"];
    locations = [self.user performSelector:@selector(makeLocationList:) withObject:resArray];
    if (locations == nil || [locations count] != 0)
    {
        STFail(@"testBuddyLocationParseLocationHistoryJsonData EmptyData") ;
    }
}

- (void)testBuddyFindUsersParseUserDataJson
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_FindUsers"];

    bwaiting = true;
    [self aLogin];
    [self waitloop];

    if (!self.user)
    {
        STFail(@"testBuddyFindUsersParseUserDataJson login failed.");
        return;
    }

    NSArray *locations = [self.user performSelector:@selector(makeUserList:) withObject:resArray];
    if (locations == nil || [locations count] != 2)
    {
        STFail(@"testBuddyFindUsersParseUserDataJson") ;
    }

    resArray = [TestBuddySDK GetTextFileData:@"Test_NoData"];
    locations = [self.user performSelector:@selector(makeUserList:) withObject:resArray];
    if (locations == nil || [locations count] != 0)
    {
        STFail(@"testBuddyFindUsersParseUserDataJson NoData") ;
    }

    resArray = [TestBuddySDK GetTextFileData:@"Test_EmptyData"];
    locations = [self.user performSelector:@selector(makeUserList:) withObject:resArray];
    if (locations == nil || [locations count] != 0)
    {
        STFail(@"testBuddyFindUsersParseUserDataJson Test_EmptyData ") ;
    }
}


- (void)testBuddyFindUsersParsePicturesSearchPhotosNearbyJson
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_PicturesSearchPhotosNearby"];

    bwaiting = true;
    [self aLogin];
    [self waitloop];

    if (!self.user)
    {
        STFail(@"testBuddyFindUsersParseUserDataJson login failed.");
        return;
    }

    NSDictionary *locations = [self.user performSelector:@selector(makePhotoAlbumDictionary:) withObject:resArray];
    if (locations == nil || [locations count] != 3)
    {
        STFail(@"testBuddyFindUsersParseUserDataJson") ;
    }

    for (id key in locations)
    {
        BuddyPhotoAlbumPublic *bp = (BuddyPhotoAlbumPublic *) [locations objectForKey:key];
        BuddyPicturePublic *pic = [bp.pictures objectAtIndex:0];
        if ([pic.appTag isEqualToString:@"app tag 1"] == FALSE)
        {
            STFail(@"testBuddyFindUsersParsePicturesSearchPhotosNearbyJson app tag 1") ;
        }
    }
    resArray = [TestBuddySDK GetTextFileData:@"Test_NoData"];

    locations = [self.user performSelector:@selector(makePhotoAlbumDictionary:) withObject:resArray];
    if (locations == nil || [locations count] != 0)
    {
        STFail(@"testBuddyFindUsersParseUserDataJson NOdata") ;
    }

    resArray = [TestBuddySDK GetTextFileData:@"Test_EmptyData"];

    locations = [self.user performSelector:@selector(makePhotoAlbumDictionary:) withObject:resArray];
    if (locations == nil || [locations count] != 0)
    {
        STFail(@"testBuddyFindUsersParseUserDataJson EmptyData") ;
    }
}

@end