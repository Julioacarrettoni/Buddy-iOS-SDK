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

- (void)testSearch
{
    bwaiting = true;
    int icount = 5;

    self.user = nil;
    bwaiting = true;
    [self aLogin];
    [self waitloop];

    if (self.user == nil)
    {
        bwaiting = true;
        [self aLogin];
        [self waitloop];
    }

    if (self.user == nil)
    {
        STFail(@"testSearch failed to login");
        return;
    }

    bwaiting = true;
    [self searchForPhotos];
    [self waitloop];

    while (icount != 0)
    {
        bwaiting = true;
        [self getFindPlaces];
        [self waitloop];

        bwaiting = true;
        [self getCategories];
        [self waitloop];

        bwaiting = true;
        [self getPlace:FALSE];
        [self waitloop];

        bwaiting = true;
        [self getPlace:TRUE];
        [self waitloop];

        bwaiting = true;
        [self getPlace2:FALSE];
        [self waitloop];

        bwaiting = true;
        [self getPlace2:TRUE];
        [self waitloop];


        icount--;
    }
}

- (void)getCategories
{
    [self.user.places getCategories:nil callback:[^(BuddyDictionaryResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"getCategories OK");
            self.categoryDict = response.result;

            if ([self.categoryDict count] < 1)
            {
                STFail(@"getCategories failed count < 1");
            }
            else
            {
                NSLog(@"getCategories OK count: %d", [self.categoryDict count]);
            }
        }
        else
        {
            STFail(@"getCategories failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)searchForPhotos
{
    [self.user searchForAlbums:nil latitude:47.675290 longitude:-122.206460 limitResults:nil state:nil callback:[^(BuddyDictionaryResponse *response)
    {
        if (response.isCompleted && response.result != nil)
        {
            NSDictionary *dict = (NSDictionary *) response.result;

            NSLog(@"searchForPhotos OK count: %d", [dict count]);
        }
        else
        {
            STFail(@"searchForPhotos failed !response.isCompleted || response.result == nil");
        }
        bwaiting = false;
    } copy]];
}

- (void)getPlace2:(BOOL)checkTag
{
    NSNumber *searchDistance = [NSNumber numberWithInt:27468728];

    [self.user.places get:searchDistance latitude:47.675290 longitude:-122.206460 state:nil callback:[^(BuddyPlaceResponse *response)
    {
        if (response.isCompleted && response.result != nil)
        {
            NSLog(@"getPlace2 OK");
            if (checkTag)
            {
                if (![response.result.userTagData isEqualToString:@"userTag"])
                {
                    STFail(@"getPlace2 !response.result.appTagData  == userTag");
                }
                [self SetTag2:response.result tag:@"yyyyyy"];
            }
            else
            {
                NSLog(@"getPlace2 OK");
                [self SetTag2:response.result tag:@"userTag"];
            }
        }
        else
        {
            STFail(@"getPlace2 failed !response.isCompleted || response.result == nil");
            bwaiting = false;
        }
    } copy]];
}


- (void)getPlace:(BOOL)checkTag
{
    NSNumber *searchDistance = [NSNumber numberWithInt:27468728];

    [self.user.places get:searchDistance latitude:47.675290 longitude:-122.206460 state:nil callback:[^(BuddyPlaceResponse *response)
    {
        if (response.isCompleted && response.result != nil)
        {
            // unused variables to help make code coverage results more accurate
            NSString *tmp;
            double dub;
            tmp = response.result.address;
            tmp = response.result.appTagData;
            NSNumber *cat = response.result.categoryId;
            tmp = response.result.categoryName;
            tmp = response.result.city;
            NSDate *date = response.result.createdDate;
            dub = response.result.distanceInKiloMeters;
            dub = response.result.distanceInMeters;
            dub = response.result.distanceInMiles;
            dub = response.result.distanceInYards;
            tmp = response.result.fax;
            NSNumber *num = response.result.placeId;
            dub = response.result.latitude;
            dub = response.result.longitude;
            tmp = response.result.name;
            tmp = response.result.postalState;
            tmp = response.result.postalZip;
            tmp = response.result.region;
            tmp = response.result.shortId;
            tmp = response.result.telephone;
            NSDate *date1 = response.result.touchedDate;
            tmp = response.result.userTagData;
            tmp = response.result.website;
            date = nil;
            num = nil;
            date1 = nil;
            cat = nil;

            if (checkTag)
            {
                NSLog(@"getPlace OK");
                if (![response.result.appTagData isEqualToString:@"appTag"])
                {
                    STFail(@"getPlace !response.result.appTagData  == appTag");
                }
                [self SetTag:response.result tag:@"xxxxx"];
            }
            else
            {
                NSLog(@"getPlace OK");
                [self SetTag:response.result tag:@"appTag"];
            }
        }
        else
        {
            STFail(@"getPlace failed !response.isCompleted || response.result == nil");
            bwaiting = false;
        }
    } copy]];
}

- (void)SetTag:(BuddyPlace *)buddyPlace tag:(NSString *)theTag
{
    [buddyPlace setTag:theTag userTag:@"" state:nil callback:[^(BuddyBoolResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"SetTag OK");
        }
        else
        {
            STFail(@"SetTag failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}


- (void)SetTag2:(BuddyPlace *)buddyPlace tag:(NSString *)theTag
{
    [buddyPlace setTag:@"" userTag:theTag state:nil callback:[^(BuddyBoolResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"SetTag2 OK");
        }
        else
        {
            STFail(@"SetTag2 failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)getFindPlaces
{
    NSNumber *searchDistance = [NSNumber numberWithInt:9999999];

    [self.user.places find:searchDistance latitude:0.0 longitude:0.0 numberOfResults:nil searchForName:nil searchCategoryId:nil state:nil callback:[^(BuddyArrayResponse *response)
    {
        if (response.isCompleted && [response.result count] > 0)
        {
            self.places = response.result;
        }
        else
        {
            STFail(@"getFindPlaces failed !response.isCompleted || [response.result count] == 0");
        }
        bwaiting = false;
    } copy]];
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