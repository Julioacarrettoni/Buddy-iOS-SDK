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

#import "FriendsUnitTests.h"
#import "BuddyCallbackParams.h"
#import "BuddyDataResponses.h"
#import "BuddyBoolResponse.h"
#import "TestBuddySDK.h"
#import "BuddyClient.h"


@implementation FriendsUnitTests

@synthesize buddyClient;
@synthesize tokenUser;

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
    
    STAssertNotNil(self.buddyClient, @"FriendsUnitTests failed buddyClient nil");
}

- (void)tearDown
{
    [super tearDown];
    
    self.buddyClient = nil;
}

- (void)waitloop
{
    NSDate *loopTil = [NSDate dateWithTimeIntervalSinceNow:20];
    
    while (bwaiting && [loopTil timeIntervalSinceNow] > 0)
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopTil];
}


- (void)alogin
{
    [self.buddyClient login:Token state:nil callback:[^(BuddyAuthenticatedUserResponse *response)
                                                      {
                                                          if (response.isCompleted && response.result)
                                                          {
                                                              NSLog(@"Login OK");
                                                              self.tokenUser = response.result;
                                                          }
                                                          else
                                                          {
                                                              STFail(@"alogin failed !response.isCompleted || !response.result");
                                                          }
                                                          bwaiting = false;
                                                      } copy]];
}



- (void)testFriendRequestGetParsing
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_FriendRequest"];
    
    bwaiting = true;
    [self alogin];
    [self waitloop];
    
    if (!self.tokenUser)
    {
        STFail(@"testFriendRequestGetParsing login failed.");
        return;
    }
    
    NSArray *dict = [self.tokenUser.friends performSelector:@selector(makeFriendsList:) withObject:resArray];
    
    if ([dict count] != 2)
    {
        STFail(@"testFriendRequestGetParsing failed dict should have 2 items");
    }
    
    resArray = [TestBuddySDK GetTextFileData:@"Test_NoData"];
    dict = [self.tokenUser.friends performSelector:@selector(makeFriendsList:) withObject:resArray];
    
    if ([dict count] != 0)
    {
        STFail(@"testFriendRequestGetParsing failed dict should have 0 items");
    }
    
    resArray = [TestBuddySDK GetTextFileData:@"Test_EmptyData"];
    dict = [self.tokenUser.friends performSelector:@selector(makeFriendsList:) withObject:resArray];
    if ([dict count] != 0)
    {
        STFail(@"testFriendRequestGetParsing failed dict should have 0 items");
    }
    
    resArray = [TestBuddySDK GetTextFileData:@"Test_FriendRequestBad"];
    @try
    {
        dict = [self.tokenUser.friends performSelector:@selector(makeFriendsList:) withObject:resArray];
        if ([dict count] != 2)
        {
            STFail(@"test_FriendRequestGetParsing failed dict should have 0 items");
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"testFriendRequestGetParsing Ok");
    }
}

- (void)testFriendsGetListParsing
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_FriendsGetList"];
    
    bwaiting = true;
    [self alogin];
    [self waitloop];
    
    if (!self.tokenUser)
    {
        STFail(@"testFriendsGetListParsing login failed.");
        return;
    }
    
    NSArray *dict = [self.tokenUser.friends performSelector:@selector(makeFriendsList:) withObject:resArray];
    if ([dict count] != 2)
    {
        STFail(@"testFriendsGetListParsing failed dict should have 2 items");
    }
    
    resArray = [TestBuddySDK GetTextFileData:@"Test_NoData"];
    dict = [self.tokenUser.friends performSelector:@selector(makeFriendsList:) withObject:resArray];
    if ([dict count] != 0)
    {
        STFail(@"testFriendsGetListParsing failed dict should have 0 items");
    }
    
    resArray = [TestBuddySDK GetTextFileData:@"Test_EmptyData"];
    dict = [self.tokenUser.friends performSelector:@selector(makeFriendsList:) withObject:resArray];
    if ([dict count] != 0)
    {
        STFail(@"testFriendsGetListParsing failed dict should have 0 items");
    }
    
    resArray = [TestBuddySDK GetTextFileData:@"Test_FriendsGetListBad"];
    @try
    {
        dict = [self.tokenUser.friends performSelector:@selector(makeFriendsList:) withObject:resArray];
        if ([dict count] != 2)
        {
            STFail(@"testFriendsGetListParsing failed dict should have 0 items");
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"testFriendsGetListParsing Ok");
    }
}


@end


