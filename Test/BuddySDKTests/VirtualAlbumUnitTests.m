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

#import "VirtualAlbumUnitTests.h"
#import "BuddyCallbackParams.h"
#import "BuddyDataResponses.h"
#import "BuddyBoolResponse.h"
#import "TestBuddySDK.h"
#import "BuddyClient.h"
#import "BuddyPhotoAlbum.h"
#import "BuddyVirtualAlbum.h"


@implementation VirtualAlbumUnitTests

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
    
    STAssertNotNil(self.buddyClient, @"VirtualAlbumUnitTests failed buddyClient nil");
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

- (void)alogin
{
    [self.buddyClient login:Token  callback:[^(BuddyAuthenticatedUserResponse *response)
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
    if ([dict count] != 1)
    {
        STFail(@"testVirtualAlbumGetMyParsing failed dict should have 1 item");
    }
}

- (void)photoAlbumCreateWithPic:(NSString *)albumName
{
    [self.buddyUser.photoAlbums create:albumName isPublic:FALSE appTag:nil  callback:[^(BuddyPhotoAlbumResponse *response)
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

    [pAlbum addPicture:base64Data comment:nil latitude:0.0 longitude:0.0 appTag:nil  callback:[^(BuddyPictureResponse *response)
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
