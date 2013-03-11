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

#import "TestNotifications.h"
#import "BuddyCallbackParams.h"
#import "BuddyDataResponses.h"
#import "BuddyBoolResponse.h"
#import "BuddyClient.h"
#import "BuddyNotificationsApple.h"
#import "BuddyRegisteredDeviceApple.h"


@implementation TestNotifications

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

    STAssertNotNil(self.buddyClient, @"TestNotifications failed buddyClient nil");
}

- (void)tearDown
{
    [super tearDown];

    self.buddyClient = nil;
    self.user = nil;
}

- (void)waitloop
{
    NSDate *loopTil = [NSDate dateWithTimeIntervalSinceNow:25];

    while (bwaiting && [loopTil timeIntervalSinceNow] > 0)
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopTil];
}

- (void)testAllNotificationCalls
{
    int icount = 5;

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
        STFail(@"testAllNotificationCalls failed to login");
        return;
    }

    while (icount != 0)
    {
        int r = arc4random();
        NSString *name = [NSString stringWithFormat:@"groupd%d", r];

        bwaiting = true;
        [self atestRegisterDevice:name];
        [self waitloop];

        bwaiting = true;
        [self atestRegisterDevice:nil];
        [self waitloop];

        bwaiting = true;
        [self atestGetRegisteredDevices];
        [self waitloop];

        bwaiting = true;
        [self atestPushGetGroups];
        [self waitloop];

        bwaiting = true;
        [self atestSendRawMessage];
        [self waitloop];

        bwaiting = true;
        [self atestUnRegisterDevice];
        [self waitloop];

        icount--;
    }
}

- (void)atestGetRegisteredDevices
{
    NSNumber *pageSize = [NSNumber numberWithInt:10];
    NSNumber *currentPage = [NSNumber numberWithInt:1];

    [self.user.pushNotifications getRegisteredDevices:nil pageSize:pageSize
                                          currentPage:currentPage
                                                state:nil callback:[^(BuddyArrayResponse *response)
    {
        STAssertNotNil(response, @"testGetRegisteredDevices failed response nil");

        if (response.isCompleted && response.result)
        {
            NSLog(@"atestGetRegisterDevice OK count: %d", [response.result count]);

            if ([response.result count] > 0)
            {
                // unused variables to help make code coverage results more accurate
                BuddyRegisteredDeviceApple *brApple = [response.result objectAtIndex:0];
                NSString *tmp = brApple.APNSDeviceToken;
                tmp = brApple.groupName;
                NSDate *date = brApple.lastUpdateDate;
                date = brApple.registrationDate;
                NSNumber *num = brApple.userId;
                num = nil;
                tmp = [brApple userIdAsString];
            }
        }
        else
        {
            STFail(@"atestGetRegisteredDevices failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)atestRegisterDevice:(NSString *)name
{
    NSString *s = @"12278967676699898698698698698";
    NSData *DeviceToken = [NSData dataWithBytes:[s UTF8String] length:[s length]];

    [self.user.pushNotifications registerDevice:DeviceToken
                                      groupName:name
                                          state:nil callback:[^(BuddyBoolResponse *response)
    {
        STAssertNotNil(response, @"atestRegisteredDevice failed response nil");
        if (response.isCompleted && response.result)
        {
            NSLog(@"atestRegisterDevice OK");
        }
        else
        {
            STFail(@"atestRegisterDevice failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}


- (void)atestUnRegisterDevice
{
    [self.user.pushNotifications unregisterDevice:nil callback:[^(BuddyBoolResponse *response)
    {
        STAssertNotNil(response, @"atestUnRegisteredDevice failed response nil");
        if (response.isCompleted & response.result)
        {
            NSLog(@"atestUnRegisterDevice OK");
        }
        else
        {
            STFail(@"atestUnRegisterDevice failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}


- (void)atestPushGetGroups
{
    [self.user.pushNotifications getGroups:nil callback:[^(BuddyDictionaryResponse *response)
    {
        STAssertNotNil(response, @"testPushGetGroups failed response nil");
        if (response.isCompleted && response.result)
        {
            NSLog(@"atestPushGetGroups OK count: %d", [response.result count]);
        }
        else
        {
            STFail(@"atestPushGetGroups failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}


- (void)alogin
{
    [self.buddyClient login:Token state:nil callback:[^(BuddyAuthenticatedUserResponse *response)
    {
        if (response.isCompleted)
        {
            self.user = response.result;
            NSLog(@"alogin OK user: %@", self.user.toString);
        }
        else
        {
            STFail(@"alogin failed !response.isCompleted");
        }
        bwaiting = false;
    } copy]];
}

- (void)atestSendRawMessage
{
    NSString *userID = [[NSString alloc] initWithFormat:@"%d", [self.user.userId intValue]];

    [self.user.pushNotifications sendRawMessage:userID message:@"Message" badge:@"1" sound:@"default" customItems:@"" deliverAfter:nil groupName:@"" state:nil callback:[^(BuddyBoolResponse *response)
    {
        STAssertNotNil(response, @"testRegisteredDevice failed response nil");

        if (response.isCompleted && response.result)
        {
            NSLog(@"SendRawMessage OK");
        }
        else
        {
            STFail(@"atestSendRawMessage failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

@end