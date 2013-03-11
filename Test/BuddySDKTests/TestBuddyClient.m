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

#import "TestBuddyClient.h"
#import "BuddyCallbackParams.h"
#import "BuddyDataResponses.h"
#import "BuddyBoolResponse.h"
#import "BuddyClient.h"
#import "BuddyApplicationStatistics.h"


@implementation TestBuddyClient

static NSString *AppName = @"Buddy iOS SDK test app";
static NSString *AppPassword = @"8C9E044D-7DB7-42DE-A376-16460B58008E";
static bool bwaiting = false;
static NSString *Token = @"UT-76444f9f-4a4b-4d3d-ba5c-7a82b5dbb5a5";

@synthesize buddyClient;

- (void)setUp
{
    [super setUp];

    self.buddyClient = [[BuddyClient alloc] initClient:AppName
                                           appPassword:AppPassword
                                            appVersion:@"1"
                                  autoRecordDeviceInfo:TRUE];

    STAssertNotNil(self.buddyClient, @"TestBuddyClient: buddyClient nil");
}

- (void)tearDown
{
    [super tearDown];

    self.buddyClient = nil;
}

- (void)waitloop
{
    NSDate *loopTil = [NSDate dateWithTimeIntervalSinceNow:30];

    while (bwaiting && [loopTil timeIntervalSinceNow] > 0)
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopTil];
}

- (void)testClient
{
    bwaiting = true;
    [self atestPing];
    [self waitloop];

    bwaiting = true;
    [self atestGetServiceTime];
    [self waitloop];

    bwaiting = true;
    [self atestGetServiceVersion];
    [self waitloop];

    bwaiting = true;
    [self atestGetApplicationStatistics];
    [self waitloop];

    bwaiting = true;
    [self atestStats];
    [self waitloop];

    bwaiting = true;
    [self atestUserProfilesGet];
    [self waitloop];

    bwaiting = true;
    [self atestUserProfilesGet2];
    [self waitloop];
}

- (void)atestUserProfilesGet
{
    NSNumber *row = [NSNumber numberWithInt:1];

    [self.buddyClient getUserProfiles:row pageSize:nil state:nil callback:[^(BuddyArrayResponse *response)
    {
        STAssertNotNil(response, @"atestUserProfilesGet failed response nil");
        if (response.isCompleted && response.result)
        {
            NSLog(@"atestUserProfilesGet OK");
            if ([response.result count] > 0)
            {
                BuddyUser *buddyUser = [response.result objectAtIndex:0];
                NSLog(@"atestUserProfilesGet user name: %@", buddyUser.name);
                NSLog(@"atestUserProfilesGet user ID: % d", [buddyUser.userId intValue]);
            }
        }
        else
        {
            STFail(@"atestUserProfilesGet failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)atestUserProfilesGet2
{
    NSNumber *row = [NSNumber numberWithInt:1];

    [self.buddyClient getUserProfiles:row
                             callback:[^(BuddyArrayResponse *response)
                             {
                                 STAssertNotNil(response, @"atestUserProfilesGet2 failed response nil");
                                 if (response.isCompleted && response.result)
                                 {
                                     NSLog(@"atestUserProfilesGet2 OK");
                                     if ([response.result count] > 0)
                                     {
                                         BuddyUser *buddyuser = [response.result objectAtIndex:0];
                                         NSLog(@"atestUserProfilesGet2 user name: %@", buddyuser.name);
                                         NSLog(@"atestUserProfilesGet2 user ID: %d", [buddyuser.userId intValue]);
                                     }
                                 }
                                 else
                                 {
                                     STFail(@"atestUserProfilesGet2 failed  failed response nil");
                                 }
                                 bwaiting = false;
                             } copy]];
}

- (void)atestPing
{
    NSObject *obj = [[NSObject alloc] init];

    [self.buddyClient ping:obj
                  callback:[^(BuddyStringResponse *response)
                  {
                      STAssertNotNil(response, @"testPing failed response nil");
                      if (response.isCompleted && [response.result isEqualToString:@"Pong"])
                      {
                          NSLog(@"atestPing OK");
                      }
                      else
                      {
                          STFail(@"atestPing failed !response.isCompleted || ![response.result isEqualToString:@'Pong'])");
                      }
                      bwaiting = false;
                  } copy]];
}

- (void)atestGetServiceTime
{
    NSObject *obj = [[NSObject alloc] init];

    [self.buddyClient getServiceTime:obj
                            callback:[^(BuddyDateResponse *response)
                            {
                                STAssertNotNil(response, @"testGetServiceTime failed response nil");
                                if (response.isCompleted && response.result)
                                {
                                    NSLog(@"atestGetServiceTime OK time: %@", response.result);
                                }
                                else
                                {
                                    STFail(@"atestGetServiceTime failed !response.isCompleted || r!esponse.result");
                                }
                                bwaiting = false;
                            } copy]];
}

- (void)atestGetServiceVersion
{
    NSObject *obj = [[NSObject alloc] init];

    [self.buddyClient getServiceVersion:obj
                               callback:[^(BuddyStringResponse *response)
                               {
                                   STAssertNotNil(response, @"testGetServiceVersion failed response nil");
                                   if (response.isCompleted && response.result)
                                   {
                                       NSLog(@"atestGetServiceVersion OK version: %@", response.result);
                                   }
                                   else
                                   {
                                       STFail(@"atestGetServiceVersion failed !response.isCompleted || !response.result");
                                   }
                                   bwaiting = false;
                               } copy]];
}

- (void)atestGetApplicationStatistics
{
    NSObject *obj = [[NSObject alloc] init];

    [self.buddyClient getApplicationStatistics:obj
                                      callback:[^(BuddyArrayResponse *response)
                                      {
                                          STAssertNotNil(response, @"testGetApplicationStatistics failed response nil");
                                          if (response.isCompleted && response.result)
                                          {
                                              if ([response.result count] > 0)
                                              {
                                                  BuddyApplicationStatistics *astats = [response.result objectAtIndex:0];
                                                  NSLog(@"atestGetApplicationStatistic totalUsers: %@", astats.totalUsers);
                                                  NSLog(@"atestGetApplicationStatistic totalPhotos: %@", astats.totalPhotos);
                                                  NSLog(@"atestGetApplicationStatistic totalUserMetadata: %@", astats.totalUserMetadata);
                                                  NSLog(@"atestGetApplicationStatistic totalUserCheckins: %@", astats.totalUserCheckins);

                                                  // unused variables to help make code coverage results more accurate
                                                  NSString *tmp = astats.totalAppMetadata;
                                                  tmp = astats.totalFriends;
                                                  tmp = astats.totalAlbums;
                                                  tmp = astats.totalCrashes;
                                                  tmp = astats.totalMessages;
                                                  tmp = astats.totalPushMessages;
                                                  tmp = astats.totalGamePlayers;
                                                  tmp = astats.totalGameScores;
                                                  tmp = astats.totalDeviceInformation;
                                                  tmp = nil;
                                              }
                                              NSLog(@"atestGetApplicationStatisticGetApplicationStatistics OK");
                                          }
                                          else
                                          {
                                              STFail(@"atestGetApplicationStatistics failed !response.isCompleted || !response.result");
                                          }
                                          bwaiting = false;
                                      } copy]];
}

- (void)atestStats
{
    [self.buddyClient getApplicationStatistics:nil callback:[^(BuddyArrayResponse *response)
    {
        STAssertNotNil(response, @"atestStats failed response nil");
        if (response.exception != nil)
        {
            STFail(@"atestStats: exception");
        }

        if (response.isCompleted && response.result)
        {
            NSLog(@"atestStats OK number of stats = %d", [response.result count]);
        }
        else
        {
            STFail(@"atestStats failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)testGetUserAndEmail
{
    bwaiting = true;
    [self atestGetUserEmails1];
    [self waitloop];

    bwaiting = true;
    [self atestGetUserEmails2];
    [self waitloop];

    bwaiting = true;
    [self atestCheckIfEmailExists];
    [self waitloop];

    bwaiting = true;
    [self atestCheckIfUsernameExists];
    [self waitloop];
}

- (void)atestGetUserEmails1
{
    NSObject *obj = [[NSObject alloc] init];
    NSNumber *row = [NSNumber numberWithInt:1];
    NSNumber *pageSize = [NSNumber numberWithInt:10];

    [self.buddyClient getUserEmails:row
                           pageSize:pageSize
                              state:obj
                           callback:[^(BuddyArrayResponse *response)
                           {
                               if (response.exception != nil)
                               {
                                   STFail(@"testGetUserEmails1 failed exception: %@", response.exception.reason);
                               }

                               if (response.isCompleted && response.result)
                               {
                                   NSLog(@"atestGetUserEmail1 OK");
                               }
                               else
                               {
                                   STFail(@"testGetUserEmails1: falied");
                               }
                               bwaiting = false;
                           } copy]];
}

- (void)atestGetUserEmails2
{
    NSNumber *row = [NSNumber numberWithInt:1];

    [self.buddyClient getUserEmails:row
                           callback:[^(BuddyArrayResponse *response)
                           {
                               if (response.isCompleted && response.result)
                               {
                                   NSLog(@"atestGetUserEmail2 OK");
                               }
                               else
                               {
                                   STFail(@"testGetUserEmails2: falied");
                               }
                           } copy]];
}

- (void)atestCheckIfEmailExists
{
    NSObject *obj = [[NSObject alloc] init];
    NSString *email = @"XXXYYYXXXYYYXXXYYYQ@example.com";

    [self.buddyClient checkIfEmailExists:(NSString *) email state:obj
                                callback:[^(BuddyBoolResponse *response)
                                {
                                    STAssertNotNil(response, @"testCheckIfEmailExists  failed response nil");

                                    if (response.isCompleted && !response.result)
                                    {
                                        NSLog(@"aCheckIfEmailExists OK");
                                    }
                                    else
                                    {
                                        STFail(@"atestCheckIfEmailExists failed !response.isCompleted || response.result");
                                    }
                                    bwaiting = false;
                                } copy]];
}

- (void)atestCheckIfUsernameExists
{
    NSObject *obj = [[NSObject alloc] init];

    NSString *userName = @"xxxzzzyyyzzzyyy";

    [self.buddyClient CheckIfUsernameExists:(NSString *) userName state:obj
                                   callback:[^(BuddyBoolResponse *response)
                                   {
                                       STAssertNotNil(response, @"testCheckIfUsernameExists failed response nil");

                                       if (response.isCompleted && !response.result)
                                       {
                                           NSLog(@"atestCheckIfUsernameExists OK");
                                       }
                                       else
                                       {
                                           STFail(@"atestCheckIfUsernameExists failed !response.isCompleted || response.result");
                                       }
                                       bwaiting = false;
                                   } copy]];
}

- (void)testLoginBadUser
{
    bwaiting = true;
    [self atestLoginBadUser];
    [self waitloop];
}

- (void)atestLoginBadUser
{
    NSObject *obj = [[NSObject alloc] init];

    NSString *password = @"jackjack55555555555555555555555";
    NSString *userName = @"testBuddyUser1353190658";

    [self.buddyClient login:userName
                   password:password
                      state:obj
                   callback:[^(BuddyAuthenticatedUserResponse *response)
                   {
                       STAssertNotNil(response, @"atestLoginBadUser failed response nil");

                       if (response.isCompleted || response.result)
                       {
                           STFail(@"testLoginBadUser failed response.isCompleted || response.result");
                       }

                       bwaiting = false;
                   } copy]];
}

- (void)testFindUsers
{
    bwaiting = true;
    [self atestFindUsers];
    [self waitloop];
    bwaiting = true;
    [self atestFindUser];
    [self waitloop];
}

- (void)atestFindUsers
{
    NSObject *obj = [[NSObject alloc] init];

    [self.buddyClient login:Token state:obj
                   callback:[^(BuddyAuthenticatedUserResponse *response)
                   {
                       STAssertNotNil(response, @"atestFindUsers failed response nil");
                       if (response.isCompleted)
                       {
                           [self findUsers:response.result];
                       }
                       else
                       {
                           bwaiting = false;
                           NSLog(@"atestFindUsers failed exception: %@", response.exception.reason);
                       }
                   } copy]];
}

- (void)findUsers:(BuddyAuthenticatedUser *)authUser
{
    NSNumber *searchDistance = [NSNumber numberWithInt:5000000];

    [authUser findUser:0.0 longitude:0.0 searchDistance:searchDistance
              callback:[^(BuddyArrayResponse *response)
              {
                  STAssertNotNil(response, @"findUsers failed response nil");

                  if (response.isCompleted)
                  {
                      NSLog(@"findUsers OK count: %d", [response.result count]);
                  }
                  else
                  {
                      STAssertNotNil(response, @"findUsers failed !response.isCompleted");
                  }
                  bwaiting = false;
              } copy]];
}

- (void)atestFindUser
{
    NSObject *obj = [[NSObject alloc] init];

    [self.buddyClient login:Token state:obj
                   callback:[^(BuddyAuthenticatedUserResponse *response)
                   {
                       STAssertNotNil(response, @"atestFindUser failed response nil");

                       if (response.isCompleted)
                       {
                           [self findUserBadUserID:response.result];
                       }
                       else
                       {
                           STFail(@"atestFindUser failed !response.isCompleted");
                       }
                   } copy]];
}

- (void)findUserBadUserID:(BuddyAuthenticatedUser *)authUser
{
    NSNumber *numberToFind = [NSNumber numberWithInt:20];

    [authUser findUser:numberToFind state:nil callback:[^(BuddyUserResponse *response)
    {
        STAssertNotNil(response, @"findUser failed response nil");

        if (response.isCompleted)
        {
            STFail(@"findUserBadUserID failed response.isCompleted");
        }
        else
        {
            NSLog(@"findUserBadUserID OK");
        }
        bwaiting = false;
    } copy]];
}

- (void)testUpdate
{
    bwaiting = true;
    [self atestUpdate];
    [self waitloop];
}

- (void)atestUpdate
{
    NSObject *obj = [[NSObject alloc] init];

    [self.buddyClient login:Token state:obj
                   callback:[^(BuddyAuthenticatedUserResponse *response)
                   {
                       STAssertNotNil(response, @"testUpdate failed response nil");

                       if (response.isCompleted)
                       {
                           [self updateUser:response.result];
                       }
                       else
                       {
                           NSLog(@"atestUpdate Login failed exception: %@", response.exception.reason);
                       }
                   } copy]];
}

- (void)updateUser:(BuddyAuthenticatedUser *)authUser
{
    NSString *password = @"jackjack";
    NSString *userName = @"testBuddyUser1353190658";

    NSString *email = @"newmail.com";
    NSString *appTag = @"newappTag";

    [authUser update:userName password:password gender:UserGender_Any age:nil email:email userStatus:UserStatus_AnyUserStatus fuzzLocation:TRUE celebrityMode:TRUE appTag:appTag state:nil callback:[^(BuddyBoolResponse *response)
    {
        STAssertNotNil(response, @"updateUser failed response nil");

        if (response.isCompleted && response.result)
        {
            if ([authUser.email isEqualToString:@"newmail.com"]
                    && [authUser.applicationTag isEqualToString:@"newappTag"])
            {
                NSLog(@"updateUser OK");
            }
            else
            {
                STFail(@"updateUser failed authUser.email != email or authUser.applicationTag != newappTag");
            }
        }
        else
        {
            STFail(@"updateUser failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)testLoginToken
{
    bwaiting = true;
    [self atestLoginToken];
    [self waitloop];
}

- (void)atestLoginToken
{
    NSObject *obj = [[NSObject alloc] init];

    [self.buddyClient login:Token state:obj
                   callback:[^(BuddyAuthenticatedUserResponse *response)
                   {
                       STAssertNotNil(response, @"testLoginToken failed response nil");

                       if (response.isCompleted && response.result)
                       {
                           NSLog(@"atestLoginToken OK");
                       }
                       else
                       {
                           STFail(@"atestLoginToken failed !response.isCompleted || !response.result");
                       }
                       bwaiting = false;
                   } copy]];
}

- (void)testLoginBadToken
{
    bwaiting = true;
    [self atestLoginBadToken];
    [self waitloop];
}

- (void)atestLoginBadToken
{
    NSObject *obj = [[NSObject alloc] init];

    NSString *token = @"UT-d0822162-fe16-4083-9150-2fbd2efda2ef-000000000000";

    [self.buddyClient login:token state:obj
                   callback:[^(BuddyAuthenticatedUserResponse *response)
                   {
                       STAssertNotNil(response, @"testLoginBadToken failed response nil");

                       if (response.isCompleted && response.result)
                       {
                           STFail(@"atestLoginBadToken failed response.isCompleted && response.result");
                       }
                       else
                       {
                           NSLog(@"atestLoginBadToken OK");
                       }
                       bwaiting = false;
                   } copy]];
}

@end
