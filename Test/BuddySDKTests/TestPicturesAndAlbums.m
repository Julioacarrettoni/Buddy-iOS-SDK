/*Copyright (C) 2012 Buddy Platform, Inc.
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
#import "BuddyCallbackParams.h"
#import "BuddyDataResponses.h"
#import "BuddyBoolResponse.h"
#import "TestPicturesAndAlbums.h"
#import "BuddyClient.h"
#import "BuddyPhotoAlbum.h"


@implementation TestPicturesAndAlbums

@synthesize currentPict;
@synthesize buddyClient;
@synthesize user;
@synthesize photoAlbum;
@synthesize currentPictPublic;
@synthesize allPhotoAlbums;

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

    STAssertNotNil(self.buddyClient, @"TestPicturesAndAlbums failed buddyClient nil");
}

- (void)tearDown
{
    [super tearDown];

    self.buddyClient = nil;
}

- (void)waitloop
{
    NSDate *loopTil = [NSDate dateWithTimeIntervalSinceNow:150];

    while (bwaiting && [loopTil timeIntervalSinceNow] > 0)
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopTil];
}

- (void)waitloop2
{
    NSDate *loopTil = [NSDate dateWithTimeIntervalSinceNow:15];

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
        }
        else
        {
            STFail(@"aLogin failed  !response.isCompleted");
        }
        bwaiting = false;
    } copy]];
}

- (void)testBuddyPublicPicture
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_PublicPicture"];

    bwaiting = true;
    [self aLogin];
    [self waitloop];
    if (!self.user)
    {
        STFail(@"testBuddyPublicPicture login failed.");
        return;
    }

    NSArray *dataOut = [self.user performSelector:@selector(makePictureList:) withObject:resArray];

    if (dataOut == nil || [dataOut count] != 2)
    {
        STFail(@"testBuddyPublicPicture failed expected 2 PublicPictures");
    }
    resArray = [TestBuddySDK GetTextFileData:@"Test_EmptyData"];

    dataOut = [self.user performSelector:@selector(makePictureList:) withObject:resArray];
    if (dataOut == nil || [dataOut count] != 0)
    {
        STFail(@"testBuddyPublicPicture failed expected 0 PublicPictures");
    }
}

- (void)testBuddyPhotoAlbumCreation
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_PicturesPhotoAlbumGet"];

    bwaiting = true;
    [self aLogin];
    [self waitloop];
    if (!self.user)
    {
        STFail(@"testBuddyPhotoAlbumCreation login failed.");
        return;
    }

    BuddyPhotoAlbum *album = [self.user.photoAlbums performSelector:@selector(makeBuddyPhotoAlbum:) withObject:resArray];

    if (album == nil || [album.pictures count] != 3)
    {
        STFail(@"BuddyPhotoAlbumCreation failed expected 3");
    }
}

- (void)testBuddyGetAllPictures
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_PicturesPhotoAlbumGetAllPictures"];

    bwaiting = true;
    [self aLogin];
    [self waitloop];
    if (!self.user)
    {
        STFail(@"testBuddyGetAllPictures login failed.");
        return;
    }

    NSDictionary *albums = [self.user.photoAlbums performSelector:@selector(makeBuddyPhotoAlbumDictionary:) withObject:resArray];

    if (albums == nil)
    {
        STFail(@"testBuddyGetAllPictures failed albums == nil");
    }
}

- (void)testBuddyGetAllPicturesBadData
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_PicturesPhotoAlbumGetAllPicturesBad"];

    bwaiting = true;
    [self aLogin];
    [self waitloop];
    if (!self.user)
    {
        STFail(@"testBuddyGetAllPicturesBadData login failed.");
        return;
    }

    NSDictionary *albums = [self.user.photoAlbums performSelector:@selector(makeBuddyPhotoAlbumDictionary:) withObject:resArray];

    if (albums == nil)
    {
        STFail(@"testBuddyGetAllPicturesBadData failed albums == nil");
    }
}

- (void)testBuddyGetAllPicturesNoData
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_NoData"];

    bwaiting = true;
    [self aLogin];
    [self waitloop];
    if (!self.user)
    {
        STFail(@"testBuddyGetAllPicturesNoData login failed.");
        return;
    }

    NSDictionary *albums = [self.user.photoAlbums performSelector:@selector(makeBuddyPhotoAlbumDictionary:) withObject:resArray];

    if (albums == nil)
    {
        STFail(@"testBuddyGetAllPicturesNoData failed");
    }

    resArray = [TestBuddySDK GetTextFileData:@"Test_EmptyData"];
    albums = [self.user.photoAlbums performSelector:@selector(makeBuddyPhotoAlbumDictionary:) withObject:resArray];
    if (albums == nil || [albums count] > 0)
    {
        STFail(@"testBuddyGetAllPicturesBadData EmptyDataJson failed");
    }
}

- (void)testBuddyPhotoAlbumCreationAndFilterListParsing
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_PicturesPhotoAlbumGet"];

    bwaiting = true;
    [self aLogin];
    [self waitloop];
    if (!self.user)
    {
        STFail(@"testBuddyGetAllPicturesNoData login failed.");
        return;
    }

    BuddyPhotoAlbum *album = [self.user.photoAlbums performSelector:@selector(makeBuddyPhotoAlbum:) withObject:resArray];

    if (album == nil)
    {
        STFail(@"BuddyPhotoAlbumCreationAndFilterListParsing failed");
    }

    if ([album.pictures count] != 3)
    {
        STFail(@"BuddyPhotoAlbumCreationAndFilterListParsing failed album.pictures != 3 ");
    }

    BuddyPicture *picture = [album.pictures objectAtIndex:0];

    if (picture == nil)
    {
        STFail(@"BuddyPhotoAlbumCreationAndFilterListParsing failed picture = nil");
    }

    NSArray *resArray2 = [TestBuddySDK GetTextFileData:@"Test_FilterList"];

    NSDictionary *filterList = [picture performSelector:@selector(makeFilterDictionary:) withObject:resArray2];
    if (filterList == nil || [filterList count] < 1)
    {
        STFail(@"BuddyPhotoAlbumCreationAndFilterListParsing failed FilterListJson");
    }
}

- (void)testBuddyPhotoAlbumCreationAndPictureFilterListRequestAndParsing
{
    [self atestBuddyPhotoAlbumCreationAndPictureFilterListRequestAndParsing];
}

- (void)atestBuddyPhotoAlbumCreationAndPictureFilterListRequestAndParsing
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_PicturesPhotoAlbumGet"];

    bwaiting = true;
    [self aLogin];
    [self waitloop];
    if (!self.user)
    {
        STFail(@"atestBuddyPhotoAlbumCreationAndPictureFilterListRequestAndParsing login failed.");
        return;
    }

    BuddyPhotoAlbum *album = [self.user.photoAlbums performSelector:@selector(makeBuddyPhotoAlbum:) withObject:resArray];

    if (album == nil || [album.pictures count] != 3)
    {
        STFail(@"atestBuddyPhotoAlbumCreationAndPictureFilterListRequestAndParsing failed");
    }

    BuddyPicture *picture = [album.pictures objectAtIndex:0];

    if (picture == nil)
    {
        STFail(@"atestBuddyPhotoAlbumCreationAndPictureFilterListRequestAndParsing failed picture != nil");
    }
}

- (void)testBuddyPhotoAlbumCreationNoData
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_NoData"];

    bwaiting = true;
    [self aLogin];
    [self waitloop];
    if (!self.user)
    {
        STFail(@"testBuddyPhotoAlbumCreationNoData login failed.");
        return;
    }

    BuddyPhotoAlbum *album = [self.user.photoAlbums performSelector:@selector(makeBuddyPhotoAlbum:) withObject:resArray];

    if (album == nil || [album.pictures count] != 0)
    {
        STFail(@"testBuddyPhotoAlbumCreationNoData NoData failed");
    }

    resArray = [TestBuddySDK GetTextFileData:@"Test_EmptyData"];
    if (album == nil || [album.pictures count] != 0)
    {
        STFail(@"testBuddyPhotoAlbumCreationNoData EmptyDataJson failed");
    }
}

- (void)testBuddyPhotoAlbumCreationAndPictureDeleteRequestAndParsing
{
    [self atestBuddyPhotoAlbumCreationAndPictureDeleteRequestAndParsing];
}

- (void)atestBuddyPhotoAlbumCreationAndPictureDeleteRequestAndParsing
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_PicturesPhotoAlbumGet"];

    bwaiting = true;
    [self aLogin];
    [self waitloop];
    if (!self.user)
    {
        STFail(@"atestBuddyPhotoAlbumCreationAndPictureDeleteRequestAndParsing login failed.");
        return;
    }

    BuddyPhotoAlbum *album = [self.user.photoAlbums performSelector:@selector(makeBuddyPhotoAlbum:) withObject:resArray];

    if (album == nil)
    {
        STFail(@"atestBuddyPhotoAlbumCreationAndPictureDeleteRequestAndParsing failed album == nil");
    }

    if ([album.pictures count] != 3)
    {
        STFail(@"atestBuddyPhotoAlbumCreationAndPictureDeleteRequestAndParsing failed album.pictures != 3");
    }

    BuddyPicture *picture = [album.pictures objectAtIndex:0];

    if (picture == nil)
    {
        STFail(@"atestBuddyPhotoAlbumCreationAndPictureDeleteRequestAndParsing failed picture = nil");
    }
}

@end
