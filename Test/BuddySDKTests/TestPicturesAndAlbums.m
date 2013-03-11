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

- (void)testphotoAlbumCreateDelete
{
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
        STFail(@"testphotoAlbumCreateDelete failed to login");
        return;
    }

    bwaiting = true;
    [self aphotoAlbumCreateDelete];
    [self waitloop];
}

- (void)testphotoAlbumCreateAndAddPicture
{
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
        STFail(@"testphotoAlbumCreateAndAddPicture failed to login");
        return;
    }

    bwaiting = true;
    [self aphotoAlbumCreateAndAddPicture];
    [self waitloop];
}

- (void)testphotoAlbumCreateAndAddPictureWithWatermark
{
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
        STFail(@"testphotoAlbumCreateAndAddPictureWithWatermark failed to login");
        return;
    }

    bwaiting = true;
    [self aphotoAlbumCreateAndAddPictureWithWatermark];
    [self waitloop];
}

- (void)testphotoAlbumCreateAndAddPictureNSData
{
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
        STFail(@"testphotoAlbumCreateAndAddPictureNSData failed to login");
        return;
    }

    bwaiting = true;
    [self aphotoAlbumCreateAndAddPictureNSData];
    [self waitloop];
}

- (void)testphotoAlbumCreateAndAddPictureWithWatermarkNSData
{
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
        STFail(@"testphotoAlbumCreateAndAddPictureWithWatermarkNSData failed to login");
        return;
    }

    bwaiting = true;
    [self aphotoAlbumCreateAndAddPictureWithWatermarkNSdata];
    [self waitloop];
}

- (void)testAddProfilePhoto
{
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
        STFail(@"testAddProfilePhoto failed to login");
        return;
    }

    bwaiting = true;
    [self aphotoUserPhoto];
    [self waitloop];
}

- (void)testphotoAlbumCountAndDelete
{
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
        STFail(@"testphotoAlbumCountAndDelete failed to login");
        return;
    }

    bwaiting = true;
    [self aphotoAlbumCreateAndAddPictureWithWatermark];
    [self waitloop];

    bwaiting = true;
    [self aphotoAlbumCountAndDelete];
    [self waitloop2];

    bwaiting = true;
    [self aphotoAlbumCountAndDelete];
    [self waitloop2];
}

- (void)testphotoAlbumCountAndPictureDelete
{
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
        STFail(@"testphotoAlbumCountAndPictureDelete failed to login");
        return;
    }

    bwaiting = true;
    [self aphotoAlbumCreateAndAddPicture];
    [self waitloop];

    bwaiting = true;
    [self aphotoAlbumGetByName];
    [self waitloop2];

    bwaiting = true;
    [self aphotoAlbumCreateAndAddPictureWithWatermark];
    [self waitloop];

    bwaiting = true;
    [self aphotoAlbumCountAndTagPicture];
    [self waitloop2];

    bwaiting = true;
    [self aphotoAlbumCountAndPictureDelete];
    [self waitloop];

    bwaiting = true;
    [self deleteAllPicturesInAllAlbums];
//	[self waitloop2];
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

- (void)aphotoAlbumCountAndTagPicture
{
    [self photoAlbumGetPictureAndTag:self.user];
}

- (void)deleteAllPicturesInAllAlbums
{
    for (id key in self.allPhotoAlbums)
    {
        BuddyPhotoAlbum *album = (BuddyPhotoAlbum *) [self.allPhotoAlbums objectForKey:key];
        NSLog(@"photos: %d ID: %d", [album.pictures count], [album.albumId intValue]);

        for (int i = 0; i < [album.pictures count]; i++)
        {
            BuddyPicture *picture = (BuddyPicture *) [album.pictures objectAtIndex:i];
            bwaiting = true;
            [self deletePicture:picture];
            [self waitloop];
        }
    }
}

- (void)deletePicture:(BuddyPicture *)picture
{
    [picture delete:nil callback:[^(BuddyBoolResponse *response)
    {
        if (response.isCompleted && response.result == TRUE)
        {
            NSLog(@"deletePicture OK");
        }
        else
        {
            STFail(@"deletePicture failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}


- (NSDate *)getDefaultDate
{
    NSString *date = @"01-Jan-50";
    NSDateFormatter *df = [[NSDateFormatter alloc] init];

    df.dateFormat = @"dd-MMM-yy";
    NSDate *defaullDate = [df dateFromString:date];
    return defaullDate;
}

- (void)photoAlbumGetPictureAndTag:(BuddyAuthenticatedUser *)authUser
{
    NSDate *startDate = [self getDefaultDate];

    [authUser.photoAlbums getAll:startDate state:nil callback:[^(BuddyDictionaryResponse *response)
    {
        if (response.isCompleted)
        {
            self.allPhotoAlbums = response.result;
        }
        else
        {
            STFail(@"photoAlbumGetPictureAndTag");
        }
        bwaiting = false;
    } copy]];
}

- (void)aphotoAlbumCountAndPictureDelete
{
    [self photoAlbumGetPictureDelete:self.user];
}

- (void)photoAlbumGetPictureDelete:(BuddyAuthenticatedUser *)authUser
{
    NSDate *startDate = [self getDefaultDate];

    [authUser.photoAlbums getAll:startDate state:nil callback:[^(BuddyDictionaryResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"photoAlbumGetPictureDelete OK");
            self.allPhotoAlbums = response.result;
        }
        else
        {
            STFail(@"photoAlbumGetPictureDelete failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)aphotoAlbumCountAndDelete
{
    [self photoAlbumGet:self.user];
}

- (void)photoAlbumGet:(BuddyAuthenticatedUser *)authUser
{
    NSDate *startDate = [self getDefaultDate];

    [authUser.photoAlbums getAll:startDate state:nil callback:[^(BuddyDictionaryResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSDictionary *dict = response.result;
            NSLog(@"photoAlbums OK count: %d", [dict count]);
            for (id key in dict)
            {
                BuddyPhotoAlbum *pPhotoAlbum = (BuddyPhotoAlbum *) [dict objectForKey:key];
                NSLog(@"photoAlbums photos: %d ID: %d", [pPhotoAlbum.pictures count], [pPhotoAlbum.albumId intValue]);

                [pPhotoAlbum delete:nil callback:nil];
            }
            bwaiting = false;
        }
        else
        {
            STFail(@"photoAlbumGet failed !response.isCompleted || !response.result");
            bwaiting = false;
        }
    } copy]];
}

- (void)aphotoAlbumGetByName
{
    [self getAlbumByName:@"BuddyiOSSDKTestAlbum" user:self.user];
}

- (void)getAlbumByName:(NSString *)name user:(BuddyAuthenticatedUser *)authUser
{
    [authUser.photoAlbums getWithName:name state:nil callback:[^(BuddyPhotoAlbumResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"getAlbumByName OK name: %@", response.result.albumName);
        }
        else
        {
            STFail(@"getAlbumByName failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)aphotoAlbumCreateAndAddPicture
{
    [self photoAlbumCreateWithPic:self.user];
}

- (void)aphotoAlbumCreateAndAddPictureNSData
{
    [self photoAlbumCreateWithPicNSData:self.user];
}

- (void)photoAlbumCreateWithPicNSData:(BuddyAuthenticatedUser *)authUser
{
    [authUser.photoAlbums create:@"BuddyiOSSDKTestAlbumNSData" isPublic:FALSE appTag:nil state:nil callback:[^(BuddyPhotoAlbumResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"photoAlbumCreateWithPicNSData OK");
            self.photoAlbum = response.result;
            [self addPictureNSData:self.photoAlbum user:authUser];
        }
        else
        {
            STFail(@"photoAlbumCreateWithPicNSData failed !response.isCompleted || !response.result");
        }
    } copy]];
}

- (void)photoAlbumCreateWithPic:(BuddyAuthenticatedUser *)authUser
{
    [authUser.photoAlbums create:@"BuddyiOSSDKTestAlbum" isPublic:FALSE appTag:nil state:nil callback:[^(BuddyPhotoAlbumResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"photoAlbumCreateWithPic OK");

            self.photoAlbum = response.result;
            [self addPicture:self.photoAlbum user:authUser];
        }
        else
        {
            STFail(@"photoAlbumCreateWithPic failed !response.isCompleted || !response.result");
        }
    } copy]];
}

- (void)addPictureNSData:(BuddyPhotoAlbum *)pAlbum user:(BuddyAuthenticatedUser *)authUser
{
    NSData *blob = [TestBuddySDK GetPicFileData:@"SpaceNeedle"];
    NSData *b64Data = [pAlbum encodeToBase64:blob];

    [pAlbum addPicture:b64Data
              callback:[^(BuddyPictureResponse *response)
              {
                  if (response.isCompleted && response.result != nil)
                  {
                      self.currentPict = response.result;

                      NSLog(@"addPictureNSData OK photoID: %d", [self.currentPict.photoId intValue]);
                      [self getPictureByIDNSData:self.currentPict.photoId user:authUser];
                  }
                  else
                  {
                      STFail(@"addPictureNSData failed !response.isCompleted || response.result == nil");
                      bwaiting = false;
                  }
              } copy]];
}

- (void)addPicture:(BuddyPhotoAlbum *)pAlbum user:(BuddyAuthenticatedUser *)authUser
{
    NSData *blob = [TestBuddySDK GetPicFileData:@"SpaceNeedle"];
    NSData *b64Data = [pAlbum encodeToBase64:blob];

    [pAlbum addPicture:b64Data comment:nil latitude:0 longitude:0 appTag:nil state:nil callback:[^(BuddyPictureResponse *response)
    {
        if (response.isCompleted && response.result != nil)
        {
            self.currentPict = response.result;
            NSLog(@"addPicture OK photoID: %d", [self.currentPict.photoId intValue]);
            [self getPictureByID:self.currentPict.photoId user:authUser];
        }
        else
        {
            STFail(@"addPicture failed !response.isCompleted || response.result == nil");
            bwaiting = false;
        }
    } copy]];
}

- (void)getPictureByID:(NSNumber *)pictureID user:(BuddyAuthenticatedUser *)authUser
{
    [authUser getPicture:pictureID state:nil callback:[^(BuddyPictureResponse *response)
    {
        if (response.isCompleted && response.result != nil)
        {
            self.currentPict = response.result;
            NSLog(@"getPictureByID OK photoID: %d", [self.currentPict.photoId intValue]);
            [self applyFilter:self.currentPict];
        }
        else
        {
            STFail(@"getPictureByID failed !response.isCompleted || response.result == nil");
            bwaiting = false;
        }
    } copy]];
}

- (void)getPictureByIDNSData:(NSNumber *)pictureID user:(BuddyAuthenticatedUser *)authUser
{
    [authUser getPicture:pictureID state:nil callback:[^(BuddyPictureResponse *response)
    {
        if (response.isCompleted && response.result != nil)
        {
            NSLog(@"getPictureByIDNSData OK photoID: %d", [response.result.photoId intValue]);
        }
        else
        {
            STFail(@"getPictureByIDNSData failed !response.isCompleted || response.result == nil");
        }
        bwaiting = false;
    } copy]];
}

- (void)pictSupportedFilters:(BuddyPicture *)picture
{
    NSLog(@"getPictureByID OK photoID %d", [picture.photoId intValue]);

    [picture supportedFilters:nil callback:[^(BuddyDictionaryResponse *response)
    {
        if (response.isCompleted && response.result != nil)
        {
            NSLog(@"pictSupportedFilters OK count: %d", [response.result count]);
        }
        else
        {
            STFail(@"pictSupportedFilters failed !response.isCompleted || response.result == nil");
            bwaiting = false;
        }
    } copy]];
}

- (void)applyFilter:(BuddyPicture *)pict
{
    [pict applyFilter:@"Basic Operations" filterParams:@"Crop Left=20;Crop Right=30"
                state:nil callback:[^(BuddyPictureResponse *response)
    {
        if (response.isCompleted && response.result != nil)
        {
            NSLog(@"applyFilter OK photoID: %d", [response.result.photoId intValue]);
        }
        else
        {
            STFail(@"applyFilter failed !response.isCompleted || response.result == nil");
        }
        bwaiting = false;
    } copy]];
}

- (void)aphotoAlbumCreateAndAddPictureWithWatermark
{
    [self photoAlbumCreateWithPicWithWatermark:self.user];
}

- (void)aphotoAlbumCreateAndAddPictureWithWatermarkNSdata
{
    [self photoAlbumCreateWithPicWithWatermarkNSData:self.user];
}

- (void)photoAlbumCreateWithPicWithWatermarkNSData:(BuddyAuthenticatedUser *)authUser
{
    [authUser.photoAlbums create:@"BuddyiOSSDKTestAlbumNSData" isPublic:FALSE appTag:nil state:nil callback:[^(BuddyPhotoAlbumResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"photoAlbumCreateWithPicWithWatermarkNSData OK");
            self.photoAlbum = response.result;
            [self addPictureWithWaterMarkNSData:self.photoAlbum];
        }
        else
        {
            STFail(@"photoAlbumCreateWithPicWithWatermarkNSData failed !response.isCompleted || !response.result");
        }
    } copy]];
}

- (void)photoAlbumCreateWithPicWithWatermark:(BuddyAuthenticatedUser *)authUser
{
    [authUser.photoAlbums create:@"BuddyiOSSDKTestAlbum" isPublic:FALSE appTag:nil state:nil callback:[^(BuddyPhotoAlbumResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"photoAlbumCreateWithPicWithWatermarkNSData OK");
            self.photoAlbum = response.result;
            [self addPictureWithWaterMark:self.photoAlbum];
        }
        else
        {
            STFail(@"photoAlbumCreateWithPicWithWatermark failed !response.isCompleted || !response.result");
        }
    } copy]];
}

- (void)addPictureWithWaterMarkNSData:(BuddyPhotoAlbum *)pAlbum
{
    NSData *blob = [TestBuddySDK GetPicFileData:@"SpaceNeedle"];
    NSData *base64Data = [pAlbum encodeToBase64:blob];

    [pAlbum addPictureWithWatermark:base64Data comment:nil latitude:0.0 longitude:0.0 appTag:nil watermarkMessage:@"sdasdasdasdasdNSData" state:nil callback:[^(BuddyPictureResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"addPictureWithWaterMarkNSData OK photoID: %d", [response.result.photoId intValue]);
            bwaiting = false;
        }
        else
        {
            STFail(@"addPictureWithWaterMarkNSData failed !response.isCompleted || !response.result");
            bwaiting = false;
        }
    } copy]];
}

- (void)addPictureWithWaterMark:(BuddyPhotoAlbum *)pAlbum
{
    NSData *blob = [TestBuddySDK GetPicFileData:@"SpaceNeedle"];

    NSData *base64Data = [pAlbum encodeToBase64:blob];

    [pAlbum addPictureWithWatermark:base64Data comment:nil latitude:0.0 longitude:0.0 appTag:nil watermarkMessage:@"sdasdasdasdasd" state:nil callback:[^(BuddyPictureResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"addPictureWithWaterMark OK photoID: %d", [response.result.photoId intValue]);
            [self aSetPictureAppTag:response.result];
        }
        else
        {
            STFail(@"addPictureWithWaterMark failed !response.isCompleted || !response.result");
            bwaiting = false;
        }
    } copy]];
}

- (void)aSetPictureAppTag:(BuddyPicture *)buddyPicture
{
    [buddyPicture setAppTag:@"AnAppAtag" state:nil callback:[^(BuddyBoolResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"aSetPictureAppTag OK");
        }
        else
        {
            STFail(@"aSetPictureAppTag failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)aphotoUserPhoto
{
    [self addUserPhoto:self.user];
}

- (void)addUserPhoto:(BuddyAuthenticatedUser *)authUser
{
    NSData *blob = [TestBuddySDK GetPicFileData:@"SpaceNeedle"];

    __block BuddyAuthenticatedUser *_authUser = authUser;

    [authUser addProfilePhoto:blob appTag:nil state:nil callback:[^(BuddyBoolResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"addUserPhoto OK");
            [self getProfilePhoto:_authUser];
        }
        else
        {
            STFail(@"addUserPhoto failed !response.isCompleted || !response.result");
            bwaiting = false;
        }
    } copy]];
}

- (void)getProfilePhoto:(BuddyAuthenticatedUser *)authUser
{
    [authUser getProfilePhotos:nil callback:[^(BuddyArrayResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSArray *array = response.result;
            NSLog(@"getProfilePhoto OK: %d", [array count]);
            if ([array count] < 1)
            {
                STFail(@"getProfilePhoto count invalid");
                bwaiting = false;
            }
            else
            {
                [self setProfilePhoto:array user:authUser];
            }
        }
        else
        {
            STFail(@"getProfilePhoto failed !response.isCompleted || !response.result");
            bwaiting = false;
        }
    } copy]];
}

- (void)setProfilePhoto:(NSArray *)photos user:(BuddyAuthenticatedUser *)authUser
{
    self.currentPictPublic = (BuddyPicturePublic *) [photos objectAtIndex:0];

    // temporary variables to help make code coverage results more accurate
    NSString *tmp;
    double dub;
    tmp = self.currentPictPublic.fullUrl;
    tmp = self.currentPictPublic.thumbnailUrl;
    dub = self.currentPictPublic.latitude;
    dub = self.currentPictPublic.longitude;
    tmp = self.currentPictPublic.comment;
    tmp = self.currentPictPublic.appTag;
    NSDate *date = self.currentPictPublic.addedOn;
    date = nil;
    NSNumber *num = self.currentPictPublic.photoId;
    dub = self.currentPictPublic.distanceInKilometers;
    dub = self.currentPictPublic.distanceInMeters;
    dub = self.currentPictPublic.distanceInMiles;
    dub = self.currentPictPublic.distanceInYards;
    date = nil;
    num = nil;

    __block BuddyAuthenticatedUser *_authUser = authUser;

    [authUser setProfilePhoto:self.currentPictPublic state:nil callback:[^(BuddyBoolResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"setProfilePhoto OK");
            [self deleteProfilePhoto:self.currentPictPublic user:_authUser];
        }
        else
        {
            STFail(@"setProfilePhoto failed !response.isCompleted || !response.result");
            bwaiting = false;
        }
    } copy]];
}

- (void)deleteProfilePhoto:(BuddyPicturePublic *)pic user:(BuddyAuthenticatedUser *)authUser
{
    [authUser deleteProfilePhoto:pic state:nil callback:[^(BuddyBoolResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"deleteProfilePhoto OK");
        }
        else
        {
            STFail(@"deleteProfilePhoto failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)aphotoAlbumCreateDelete
{
    [self photoAlbumCreate:self.user];
}

- (void)photoAlbumCreate:(BuddyAuthenticatedUser *)authUser
{
    [authUser.photoAlbums create:@"BuddyiOSSDKTestAlbum" isPublic:FALSE appTag:nil state:nil callback:[^(BuddyPhotoAlbumResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            self.photoAlbum = response.result;
            [self photoAlbumDelete:self.photoAlbum];
        }
        else
        {
            [authUser.photoAlbums getWithName:@"BuddyiOSSDKTestAlbum" state:nil callback:[^(BuddyPhotoAlbumResponse *response2)
            {
                if (response2.isCompleted && response2.result)
                {
                    self.photoAlbum = response2.result;
                    [self photoAlbumDelete:self.photoAlbum];
                }
                else
                {
                    STFail(@"photoAlbumCreate failed !response2 || !response2");
                    bwaiting = false;
                }
            } copy]];
        }
    } copy]];
}

- (void)photoAlbumDelete:(BuddyPhotoAlbum *)pAlbum
{
    [pAlbum delete:nil callback:[^(BuddyBoolResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"photoAlbumDelete OK");
        }
        else
        {
            STFail(@"phootAlbumDelete failed !response.isCompleted || !response.result");
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
