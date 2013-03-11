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

#import "TestAnalytics.h"
#import "BuddyCallbackParams.h"
#import "BuddyDataResponses.h"
#import "BuddyBoolResponse.h"
#import "TestNotifications.h"
#import "BuddyClient.h"
#import "BuddyUser.h"
#import "BuddyGameScores.h"
#import "BuddyAuthenticatedUser.h"
#import "BuddyPhotoAlbums.h"
#import "BuddyPhotoAlbum.h"
#import "BuddyPicture.h"
#import "BuddyPlace.h"
#import "BuddyPlaces.h"
#import "BuddyNotificationsApple.h"
#import "BuddyDevice.h"
#import "BuddyGameScore.h"


@implementation TestAnalytics

static NSString *AppName = @"Buddy iOS SDK test app";
static NSString *AppPassword = @"8C9E044D-7DB7-42DE-A376-16460B58008E";
static bool bwaiting = false;
static NSString *Token = @"UT-76444f9f-4a4b-4d3d-ba5c-7a82b5dbb5a5";

@synthesize user;
@synthesize buddyClient;

- (void)setUp
{
    [super setUp];

    self.buddyClient = [[BuddyClient alloc] initClient:AppName
                                           appPassword:AppPassword
                                            appVersion:@"1"
                                  autoRecordDeviceInfo:TRUE];

    STAssertNotNil(self.buddyClient, @"TestAnalytics failed buddyClient nil");
}

- (void)tearDown
{
    [super tearDown];

    self.buddyClient = nil;
    self.user = nil;
}

- (void)waitloop
{
    NSDate *loopTil = [NSDate dateWithTimeIntervalSinceNow:15];

    while (bwaiting && [loopTil timeIntervalSinceNow] > 0)
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopTil];
}

- (void)testAnalytics
{
    bwaiting = true;
    [self alogin];
    [self waitloop];

    if (self.user == nil)
    {
        bwaiting = true;
        [self alogin];
        [self waitloop];
    }

    if (self.user == nil)
    {
        STFail(@"testAnalytics failed to login");
        return;
    }

    int icount = 5;
    while (icount != 0)
    {
        bwaiting = true;
        [self atestAppStats];
        [self waitloop];

        bwaiting = true;
        [self atestAnalyticsRecordInformation];
        [self waitloop];

        bwaiting = true;
        [self atestAnalyticsRecordCrash];
        [self waitloop];

        icount--;
    }
}

- (void)atestAppStats
{
    BuddyWebWrapper *web = [self.buddyClient webService];

    [web enableNetworkActivityDisplay];

    [self.buddyClient getApplicationStatistics:nil callback:[^(BuddyArrayResponse *response)
    {
        if (response.isCompleted && response.result != nil)
        {
            NSLog(@"testAppStats OK count = %d ", [response.result count]);
        }
        else
        {
            STFail(@"testAppStats failed response.isCompleted && response.result != nil");
        }
        bwaiting = false;
    } copy]];
}

- (void)alogin
{
    [self.buddyClient login:Token state:nil callback:[^(BuddyDataResponses *response)
    {
        if (response.isCompleted && response.result != nil)
        {
            self.user = (BuddyAuthenticatedUser *) response.result;
        }
        else
        {
            STFail(@"alogin failed");
        }
        bwaiting = false;
    } copy]];
}

- (void)atestAnalyticsRecordInformation
{
    NSObject *obj = [[NSObject alloc] init];

    BuddyWebWrapper *web = [self.buddyClient webService];

    [web disableNetworkActivityDisplay];

    int r = arc4random() + (arc4random() % 1000);
    NSString *metadataName = [NSString stringWithFormat:@"metadata%d", r];

    [self.buddyClient.device recordInformation:@"iphone" deviceType:@"iphone" authUser:user appVersion:@"1.0" latitude:55.5 longitude:55.4 metadata:metadataName state:obj
                                      callback:[^(BuddyBoolResponse *response)
                                      {
                                          STAssertNotNil(response, @"testAnalyticsRecordInformation failed response nil");

                                          if (response.isCompleted && response.result)
                                          {
                                              NSLog(@"testAnalyticsRecordInformation OK");
                                          }
                                          else
                                          {
                                              STFail(@"testAnalyticsRecordInformation failed response.isCompleted && response.result");
                                          }
                                          bwaiting = false;
                                      } copy]];
}

- (void)atestAnalyticsRecordCrash
{
    NSObject *obj = [[NSObject alloc] init];
    int r = arc4random() + (arc4random() % 1000);
    NSString *metadataName = [NSString stringWithFormat:@"metadata%d", r];

    [self.buddyClient.device recordCrash:@"TestMethod" osVersion:@"iphone" deviceType:@"iphone" authUser:user stackTrace:@"" appVersion:@"1.0" latitude:55.7 longitude:55.5 metadata:metadataName state:obj
                                callback:[^(BuddyBoolResponse *response)
                                {
                                    STAssertNotNil(response, @"atestAnalyticsRecordCrash failed response nil");

                                    if (response.isCompleted && response.result)
                                    {
                                        NSLog(@"testAnalyticsRecordCrash OK");
                                    }
                                    else
                                    {
                                        STFail(@"testAnalyticsRecordCrash failed response.isCompleted && response.result");
                                    }
                                    bwaiting = false;
                                } copy]];
}

@end