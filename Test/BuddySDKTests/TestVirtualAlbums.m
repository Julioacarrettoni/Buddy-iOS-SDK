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

#import "TestVirtualAlbums.h"
#import "BuddyCallbackParams.h"
#import "BuddyDataResponses.h"
#import "BuddyBoolResponse.h"
#import "TestBuddySDK.h"
#import "BuddyClient.h"
#import "BuddyPhotoAlbum.h"
#import "BuddyVirtualAlbum.h"


@implementation TestVirtualAlbums

@synthesize picture;
@synthesize buddyUser;
@synthesize virtualAlbum;
@synthesize buddyClient;
@synthesize virtualAlbums;
@synthesize virtualAlbumArray;

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

    STAssertNotNil(self.buddyClient, @"TestVirtualAlbums failed buddyClient nil");
}

- (void)tearDown
{
    [super tearDown];

    self.buddyClient = nil;
    self.buddyUser = nil;
    self.virtualAlbumArray = nil;
}

- (void)waitloop
{
    NSDate *loopTil = [NSDate dateWithTimeIntervalSinceNow:30];

    while (bwaiting && [loopTil timeIntervalSinceNow] > 0)
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopTil];
}

- (void)testVirtualAlbumCreateDelete
{
    bwaiting = true;
    [self alogin];
    [self waitloop];

    if (self.buddyUser == nil)
    {
        bwaiting = true;
        [self alogin];
        [self waitloop];
    }
    if (self.buddyUser == nil)
    {
        STFail(@"testVirtualAlbumCreateDelete failed to login");
        return;
    }

    int icount = 10;
    while (icount != 0)
    {
        int r = arc4random();
        NSString *name = [NSString stringWithFormat:@"VAlbum%d", r];

        bwaiting = true;
        [self acreateAVirtualAlbum:name];
        [self waitloop];

        icount--;
    }

    bwaiting = true;
    [self alogin];
    [self waitloop];

    bwaiting = true;
    [self agetMyVirtualAlbums];
    [self waitloop];

    bwaiting = true;
    [self agetAllMyVirtualAlbums];
    [self waitloop];

    if (self.virtualAlbumArray)
    {
        for (int i = 0; i < [self.virtualAlbumArray count]; i++)
        {
            bwaiting = true;
            [self getVirtualAlbumToDelete:self.buddyUser.virtualAlbums name:[self.virtualAlbumArray objectAtIndex:i]];
            [self waitloop];

            if (self.virtualAlbum)
            {
                bwaiting = true;
                [self deleteVirtualAlbum];
                [self waitloop];
            }
        }
    }

    bwaiting = true;
    [self agetAllMyVirtualAlbums];
    [self waitloop];
}

- (void)testVirtualAlbumPictures
{
    bwaiting = true;
    [self alogin];
    [self waitloop];

    if (self.buddyUser == nil)
    {
        bwaiting = true;
        [self alogin];
        [self waitloop];
    }

    if (self.buddyUser == nil)
    {
        STFail(@"testVirtualAlbumPictures failed to login");
        return;
    }

    int icount = 2;
    while (icount != 0)
    {
        int r = arc4random();
        NSString *albumName = [NSString stringWithFormat:@"VAlbum%d", r];
        bwaiting = true;
        [self photoAlbumCreateWithPic:albumName];

        NSLog(@"addPicture OK photoID %d", [self.picture.photoId intValue]);
        [self waitloop];

        bwaiting = true;
        [self acreateVirtualAlbum:albumName];
        [self waitloop];

        bwaiting = true;
        [self updateVirtualAlbum];
        [self waitloop];

        bwaiting = true;
        [self updatePicture];
        [self waitloop];

        bwaiting = true;
        [self removePicture];
        [self waitloop];

        bwaiting = true;
        [self addPictureBatch];
        [self waitloop];

        bwaiting = true;
        [self deleteVirtualAlbum];
        [self waitloop];

        bwaiting = true;
        [self alogin];
        [self waitloop];

        bwaiting = true;
        [self agetMyVirtualAlbums];
        [self waitloop];

        icount--;
    }
}

- (void)getVirtualAlbum:(BuddyVirtualAlbums *)vAlbums albumid:(NSNumber *)id
{
    [vAlbums get:id state:nil callback:[^(BuddyVirtualAlbumResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            BuddyVirtualAlbum *vAlbum = response.result;
            NSLog(@"getVirtualAlbum OK count: %d", [vAlbum.pictures count]);
            self.picture = [vAlbum.pictures objectAtIndex:0];
        }
        else
        {
            STFail(@"getVirtualAlbum failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)deleteVirtualAlbum
{
    [self.virtualAlbum delete:nil callback:[^(BuddyBoolResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"deleteVirtualAlbum OK");
        }
        else
        {
            STFail(@"deleteVirtualAlbum failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)updatePicture
{
    [self.virtualAlbum updatePicture:self.picture newComment:@"new comment" newAppTag:@"new tag" state:nil callback:[^(BuddyBoolResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"updatePicture OK");
        }
        else
        {
            STFail(@"updatePicture failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)addPictureBatch
{
    NSMutableArray *pics = [[NSMutableArray alloc] init];

    [pics addObject:self.picture];
    [pics addObject:self.picture];
    [pics addObject:self.picture];

    __block TestVirtualAlbums *_self = self;

    [_self.virtualAlbum addPictureBatch:pics state:nil callback:[^(BuddyBoolResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"addPictureBatch OK");
        }
        else
        {
            STFail(@"addPictureBatch failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)removePicture
{
    [self.virtualAlbum removePicture:self.picture state:nil callback:[^(BuddyBoolResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"removePicture OK");
        }
        else
        {
            STFail(@"removePicture failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)updateVirtualAlbum
{
    [self.virtualAlbum update:@"asdasdadasd" newAppTag:nil state:nil callback:[^(BuddyBoolResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"updateVirtualAlbum OK");
        }
        else
        {
            STFail(@"updateVirtualAlbum failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)addPicToVAlbum:(BuddyVirtualAlbum *)localVirtualAlbum
{
    __block BuddyVirtualAlbum *_virtualAlbum = localVirtualAlbum;

    [localVirtualAlbum addPicture:(BuddyPicturePublic *) self.picture state:nil callback:[^(BuddyBoolResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"addPicToVAlbum OK");
            [self getVirtualAlbum:self.buddyUser.virtualAlbums albumid:_virtualAlbum.virtualAlbumId];
        }
        else
        {
            STFail(@"addPicToVAlbum failed !response.isCompleted || !response.result");
            bwaiting = false;
        }
    } copy]];
}

- (void)acreateVirtualAlbum:(NSString *)albumName
{
    [self.buddyUser.virtualAlbums create:albumName appTag:nil state:nil callback:[^(BuddyVirtualAlbumResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"acreateVirtualAlbum OK");
            self.virtualAlbum = response.result;
            [self addPicToVAlbum:self.virtualAlbum];
        }
        else
        {
            STFail(@"acreateVirtualAlbum failed !response.isCompleted || !response.result");
            bwaiting = false;
        }
    } copy]];
}

- (void)alogin
{
    [self.buddyClient login:Token state:nil callback:[^(BuddyAuthenticatedUserResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"alogin OK");
            self.buddyUser = response.result;
        }
        else
        {
            STFail(@"alogin failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)agetVirtualAlbums:(NSString *)albumName
{
    [self getVirtualAlbum:self.buddyUser.virtualAlbums name:albumName];
}

- (void)getVirtualAlbum:(BuddyVirtualAlbums *)vAlbums name:(NSString *)albumName
{
    NSNumber *ValbumID = [NSNumber numberWithInt:[albumName intValue]];

    [vAlbums get:ValbumID state:nil callback:[^(BuddyVirtualAlbumResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            self.virtualAlbum = response.result;
            NSLog(@"getVirtualAlbum OK");
            [self deleteVirtualAlbum];
        }
        else
        {
            STFail(@"getVirtualAlbum failed !response.isCompleted || !response.result");
            bwaiting = false;
        }
    } copy]];
}


- (void)agetMyVirtualAlbums
{
    [self getMyVirtualAlbum:self.buddyUser.virtualAlbums];
}

- (void)getMyVirtualAlbum:(BuddyVirtualAlbums *)vAlbum
{
    [vAlbum getMy:nil callback:[^(BuddyArrayResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSArray *array = response.result;
            NSLog(@"getMyVirtualAlbum OK count: %d", [array count]);
            for (int i = 0; i < [array count]; i++)
            {
                [self getVirtualAlbum:vAlbum name:[array objectAtIndex:i]];
                break;                             // do just one ...
            }

            if ([array count] == 0)
            {
                bwaiting = false;
            }
        }
        else
        {
            STFail(@"getMyVirtualAlbum failed !response.isCompleted || !response.result");
            bwaiting = false;
        }
    } copy]];
}

- (void)agetAllMyVirtualAlbums
{
    [self getAllMyVirtualAlbum:self.buddyUser.virtualAlbums];
}

- (void)getAllMyVirtualAlbum:(BuddyVirtualAlbums *)vAlbum
{
    [vAlbum getMy:nil callback:[^(BuddyArrayResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            self.virtualAlbumArray = response.result;
            NSLog(@"getAllMyVirtualAlbum OK count: %d", [self.virtualAlbumArray count]);
            bwaiting = false;
        }
        else
        {
            STFail(@"getAllMyVirtualAlbum failed !response.isCompleted || !response.result");
            bwaiting = false;
        }
    } copy]];
}

- (void)getVirtualAlbumToDelete:(BuddyVirtualAlbums *)vAlbums name:(NSString *)albumName
{
    NSNumber *ValbumID = [NSNumber numberWithInt:[albumName intValue]];
    self.virtualAlbum = nil;

    [vAlbums get:ValbumID state:nil callback:[^(BuddyVirtualAlbumResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            self.virtualAlbum = response.result;
            NSLog(@"getVirtualAlbumToDelete OK");
            bwaiting = false;
        }
        else
        {
            STFail(@"getVirtualAlbumToDelete failed !response.isCompleted || !response.result");
            bwaiting = false;
        }
    } copy]];
}


- (void)acreateAVirtualAlbum:(NSString *)albumName
{
    [self createAVirtualAlbum:self.buddyUser.virtualAlbums name:albumName];
}

- (void)createAVirtualAlbum:(BuddyVirtualAlbums *)vAlbums name:(NSString *)albumName
{
    [vAlbums create:albumName appTag:nil state:nil callback:[^(BuddyVirtualAlbumResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"createVirtualAlbum OK");

            // unused variables to help make code coverage results more accurate
            NSString *tmp;
            tmp = response.result.thumbnailUrl;
            tmp = response.result.name;
            tmp = response.result.applicationTag;
            NSDate *date = response.result.createdOn;
            NSNumber *num = response.result.ownerUserId;
            date = nil;
            num = nil;
        }
        else
        {
            STFail(@"createVirtualAlbum failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)testVirtualAlbumGetMyParsing
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_VirtualAlbumGetMy"];

    bwaiting = true;
    [self alogin];
    [self waitloop];
    if (!self.buddyUser)
    {
        STFail(@"testVirtualAlbumGetMyParsing login failed.");
        return;
    }

    NSArray *dict = [self.buddyUser.virtualAlbums performSelector:@selector(makeVirtualAlbumIdList:) withObject:resArray];
    if ([dict count] != 3)
    {
        STFail(@"testVirtualAlbumGetMyParsing should have 3 items");
    }

    resArray = [TestBuddySDK GetTextFileData:@"Test_NoData"];
    dict = [self.buddyUser.virtualAlbums performSelector:@selector(makeVirtualAlbumIdList:) withObject:resArray];
    if ([dict count] != 0)
    {
        STFail(@"testVirtualAlbumGetMyParsing failed dict should have 0 items");
    }

    resArray = [TestBuddySDK GetTextFileData:@"Test_EmptyData"];
    dict = [self.buddyUser.virtualAlbums performSelector:@selector(makeVirtualAlbumIdList:) withObject:resArray];
    if ([dict count] != 0)
    {
        STFail(@"testVirtualAlbumGetMyParsing failed dict should have 0 items");
    }

    resArray = [TestBuddySDK GetTextFileData:@"Test_VirtualAlbumGetMyJsonDataBad"];
    dict = [self.buddyUser.virtualAlbums performSelector:@selector(makeVirtualAlbumIdList:) withObject:resArray];
    if ([dict count] != 0)
    {
        STFail(@"testVirtualAlbumGetMyParsing failed dict should have 0 items");
    }
}

- (void)photoAlbumCreateWithPic:(NSString *)albumName
{
    [self.buddyUser.photoAlbums create:albumName isPublic:FALSE appTag:nil state:nil callback:[^(BuddyPhotoAlbumResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            [self addPicture:response.result];
            NSLog(@"photoAlbumCreateWithPic OK");
        }
        else
        {
            STFail(@"photoAlbumCreateWithPic failed !response.isCompleted || !response.result");
            bwaiting = false;
        }
    } copy]];
}

- (void)addPicture:(BuddyPhotoAlbum *)pAlbum
{
    NSData *blob = [TestBuddySDK GetPicFileData:@"SpaceNeedle"];
    NSData *base64Data = [pAlbum encodeToBase64:blob];

    [pAlbum addPicture:base64Data comment:nil latitude:0.0 longitude:0.0 appTag:nil state:nil callback:[^(BuddyPictureResponse *response)
    {
        if (response.isCompleted && response.result != nil)
        {
            self.picture = response.result;
            NSLog(@"addPicture OK photoID: %d", [self.picture.photoId intValue]);
        }
        else
        {
            STFail(@"addPicture failed !response.isCompleted || !response.result == nil");
        }
        bwaiting = false;
    } copy]];
}

@end