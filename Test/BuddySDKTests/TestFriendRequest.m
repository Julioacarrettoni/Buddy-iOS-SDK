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

#import "TestFriendRequest.h"
#import "BuddyCallbackParams.h"
#import "BuddyDataResponses.h"
#import "BuddyBoolResponse.h"
#import "TestBuddySDK.h"
#import "BuddyClient.h"


@implementation TestFriendRequest

@synthesize fixedUser;
@synthesize fixedUser2;
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

    STAssertNotNil(self.buddyClient, @"TestFriendRequest failed buddyClient nil");
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

// Log in 2 users, send friend request to one, and read the request with the other
- (void)testRequestFriend
{
    bwaiting = true;
    [self createFixedUser];
    [self waitloop];

    bwaiting = true;
    [self atestFriendAddRequest];
    [self waitloop];

    bwaiting = true;
    [self userGetRequestsAccept:self.fixedUser];
    [self waitloop];

    bwaiting = true;
    [self userGetAllFriendsAndRemoveFirst:self.fixedUser];
    [self waitloop];

    bwaiting = true;
    [self atestFriendAddRequest];
    [self waitloop];

    bwaiting = true;
    [self userGetRequestsAccept:self.fixedUser];
    [self waitloop];

    bwaiting = true;
    [self createFixedUser2];
    [self waitloop];

    bwaiting = true;
    [self atestFriendAddRequest2];
    [self waitloop];

    bwaiting = true;
    [self userGetRequestsDeny:self.fixedUser2];
    [self waitloop];

    bwaiting = true;
    [self userGetAllFriends:self.fixedUser];
    [self waitloop];
}

- (void)userGetRequestsAccept:(BuddyAuthenticatedUser *)buddyUser
{
    NSDate *startDate = [self getDefaultDate];

    [buddyUser.friends.requests getAll:startDate state:nil callback:[^(BuddyArrayResponse *response)
    {
        if (response.isCompleted && response.result && [response.result count] > 0)
        {
            NSLog(@"userGetRequestsAccept OK requests: %d", [response.result count]);
            [self processRequestsAccept:response.result user:buddyUser];
        }
        else
        {
            STFail(@"userGetRequestsAccept failed !response.isCompleted || !response.result || [response.result count] <= 0");
            bwaiting = false;
        }
    } copy]];
}

- (void)processRequestsAccept:(NSArray *)friendRequestArray user:(BuddyAuthenticatedUser *)buddyUser
{
    if ([friendRequestArray count] > 0)
    {
        BuddyUser *bUser = (BuddyUser *) [friendRequestArray objectAtIndex:0];

        [buddyUser.friends.requests accept:bUser appTag:nil state:nil callback:[^(BuddyBoolResponse *response)
        {
            if (response.isCompleted && response.result)
            {
                NSLog(@"processRequestsAccept OK");
            }
            else
            {
                STFail(@"processRequestsAccept failed !response.isCompleted || !response.result");
            }
            bwaiting = false;
        } copy]];
    }
}

- (void)userGetRequestsDeny:(BuddyAuthenticatedUser *)buddyUser
{
    NSDate *startDate = [self getDefaultDate];

    [buddyUser.friends.requests getAll:startDate state:nil callback:[^(BuddyArrayResponse *response)
    {
        if (response.isCompleted && response.result && [response.result count] > 0)
        {
            NSLog(@"userGetRequestsDeny OK requests: %d", [response.result count]);
            [self processRequestsDeny:response.result user:buddyUser];
        }
        else
        {
            STFail(@"userGetRequestsDeny failed !response.isCompleted || !response.result || [response.result count] <= 0");
            bwaiting = false;
        }
    } copy]];
}

- (void)processRequestsDeny:(NSArray *)friendRequestArray user:(BuddyAuthenticatedUser *)buddyUser
{
    if ([friendRequestArray count] > 0)
    {
        BuddyUser *bUser = (BuddyUser *) [friendRequestArray objectAtIndex:0];

        [buddyUser.friends.requests deny:bUser state:nil callback:[^(BuddyBoolResponse *response)
        {
            if (response.isCompleted && response.result)
            {
                NSLog(@"processRequestsDeny OK ");
            }
            else
            {
                STFail(@"processRequestsDeny failed !response.isCompleted || !response.result");
            }
            bwaiting = false;
        } copy]];
    }
}

- (void)addRequest:(BuddyAuthenticatedUser *)buddyUser getList:(BOOL)getlist
{
    self.tokenUser = buddyUser;

    __block TestFriendRequest *_self = self;

    [_self.tokenUser.friends.requests add:self.fixedUser appTag:nil state:nil callback:[^(BuddyBoolResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"addRequest OK");
        }
        else
        {
            STFail(@"addRequest failed !response.isCompleted || !response.result");
            bwaiting = false;
        }
    } copy]];
}

- (void)addRequest2:(BuddyAuthenticatedUser *)buddyUser getList:(BOOL)getlist
{
    self.tokenUser = buddyUser;

    __block TestFriendRequest *_self = self;

    [_self.tokenUser.friends.requests add:self.fixedUser2 appTag:nil state:nil callback:[^(BuddyBoolResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"addRequest2 OK");
        }
        else
        {
            STFail(@"addRequest2 failed !response.isCompleted || !response.result");
            bwaiting = false;
        }
    } copy]];
}

- (void)atestFriendAddRequest
{
    int r = arc4random();
    NSString *sd = [NSString stringWithFormat:@"user%d", r];
    NSNumber *age = [NSNumber numberWithInt:100];

    [self.buddyClient createUser:sd password:@"123" gender:UserGender_Any age:age email:@"email" status:UserStatus_AnyUserStatus fuzzLocation:FALSE celebrityMode:FALSE appTag:nil state:nil callback:[^(BuddyAuthenticatedUserResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            [self addRequest:response.result getList:TRUE];
            NSLog(@"atestFriendAddRequest OK");
        }
        else
        {
            STFail(@"atestFriendAddRequest failed !response.isCompleted || !response.result");
            bwaiting = false;
        }
    } copy]];
}

- (void)atestFriendAddRequest2
{
    int r = arc4random();
    NSString *username = [NSString stringWithFormat:@"user%d", r];
    NSNumber *age = [NSNumber numberWithInt:100];

    [self.buddyClient createUser:username password:@"123" gender:UserGender_Any age:age email:@"email" status:UserStatus_AnyUserStatus fuzzLocation:FALSE celebrityMode:FALSE appTag:nil state:nil callback:[^(BuddyAuthenticatedUserResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            [self addRequest2:response.result getList:TRUE];
            NSLog(@"atestFriendAddRequest2 OK");
        }
        else
        {
            STFail(@"atestFriendAddRequest2 failed !response.isCompleted || !response.result");
            bwaiting = false;
        }
    } copy]];
}

- (void)tryLogin
{
    [self.buddyClient login:@"UserXXXXx" password:@"123" state:nil callback:[^(BuddyAuthenticatedUserResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            self.fixedUser = response.result;
            NSLog(@"tryLogin OK");
        }
        else
        {
            STFail(@"tryLogin failed response.isCompleted && response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)tryLogin2
{
    [self.buddyClient login:@"UserXXXXx" password:@"123" state:nil callback:[^(BuddyAuthenticatedUserResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            self.fixedUser2 = response.result;
            NSLog(@"tryLogin2 OK");
        }
        else
        {
            STFail(@"tryLogin2 failed response.isCompleted && response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)createFixedUser
{
    NSNumber *age = [NSNumber numberWithInt:100];

    [self.buddyClient createUser:@"UserXXXXx" password:@"123" gender:UserGender_Any age:age email:@"email" status:UserStatus_AnyUserStatus fuzzLocation:FALSE celebrityMode:FALSE appTag:nil state:nil callback:[^(BuddyAuthenticatedUserResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            self.fixedUser = response.result;

            NSLog(@"createFixedUser OK");

            bwaiting = false;
        }
        else
        {
            [self tryLogin];
        }
    } copy]];
}

- (void)createFixedUser2
{
    NSNumber *age = [NSNumber numberWithInt:100];

    [self.buddyClient createUser:@"UserXXXXx2" password:@"123" gender:UserGender_Any age:age email:@"email" status:UserStatus_AnyUserStatus fuzzLocation:FALSE celebrityMode:FALSE appTag:nil state:nil callback:[^(BuddyAuthenticatedUserResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            self.fixedUser2 = response.result;
            NSLog(@"createFixedUser2 OK");
            bwaiting = false;
        }
        else
        {
            [self tryLogin2];
        }
    } copy]];
}

- (void)testFriendSearchAndGetAll
{
    self.tokenUser = nil;

    bwaiting = true;
    [self alogin];
    [self waitloop];

    if (self.tokenUser == nil)
    {
        bwaiting = true;
        [self alogin];
        [self waitloop];
    }

    if (self.tokenUser == nil)
    {
        STFail(@"testFriendSearchAndGetAll failed to login");
        return;
    }

    bwaiting = true;
    [self atestFriendsGetAll];
    [self waitloop];

    if (self.tokenUser)
    {
        bwaiting = true;
        [self userGetAll:self.tokenUser];
        [self waitloop];
    }
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

- (void)atestFriendsGetAll
{
    int r = arc4random();
    NSString *userName = [NSString stringWithFormat:@"user%d", r];
    NSNumber *age = [NSNumber numberWithInt:100];

    [self.buddyClient createUser:userName password:@"123" gender:UserGender_Any age:age email:@"email" status:UserStatus_AnyUserStatus fuzzLocation:FALSE celebrityMode:FALSE appTag:nil state:nil callback:[^(BuddyAuthenticatedUserResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            self.tokenUser = response.result;
        }
        else
        {
            STFail(@"atestFriendGetAll failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)userGetAll:(BuddyAuthenticatedUser *)buddyUser
{
    NSDate *startDate = [self getDefaultDate];

    __block BuddyAuthenticatedUser *_user = buddyUser;

    [buddyUser.friends getAll:startDate state:nil callback:[^(BuddyArrayResponse *response)
    {
        NSArray *array = response.result;
        if (response.isCompleted && [array count] == 0)
        {
            NSLog(@"userGetAll OK");

            [_user delete:nil callback:nil];
        }
        else
        {
            STFail(@"userGetAll failed !response.isCompleted || [array count] != 0");
            bwaiting = false;
        }
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

- (void)userGetAllFriendsAndRemoveFirst:(BuddyAuthenticatedUser *)buddyUser
{
    NSDate *startDate = [self getDefaultDate];

    [buddyUser.friends getAll:startDate state:nil callback:[^(BuddyArrayResponse *response)
    {
        if (response.isCompleted)
        {
            NSArray *array = response.result;
            NSLog(@"userGetAllFriendsAndRemoveFirst OK");
            if (array && [array count] > 0)
            {
                BuddyUser *user = (BuddyUser *) [array objectAtIndex:0];

                [buddyUser.friends remove:user state:nil callback:[^(BuddyBoolResponse *response2)
                {
                    if (response2.isCompleted && response2.result)
                    {
                        NSLog(@"userGetAllFriendsAndRemoveFirst first removed OK");
                    }
                    else
                    {
                        STFail(@"userGetAllFriendsAndRemoveFirst failed !response2.isCompleted || !response2.result");
                    }
                    bwaiting = false;
                } copy]];
            }
            else
            {
                STFail(@"userGetAllFriendsAndRemoveFirst failed count: 0");
                bwaiting = false;
            }
        }
        else
        {
            STFail(@"userGetAllFriendsAndRemoveFirst failed !response.isCompleted");
            bwaiting = false;
        }
    } copy]];
}

- (void)userGetAllFriends:(BuddyAuthenticatedUser *)buddyUser
{
    NSDate *startDate = [self getDefaultDate];

    [buddyUser.friends getAll:startDate state:nil callback:[^(BuddyArrayResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSArray *array = response.result;

            NSLog(@"userGetAllFriends OK");

            if (array && [array count] > 0)
            {
                NSLog(@"userGetAllFriends count: %d", [array count]);

                BuddyUser *bUser = (BuddyUser *) [array objectAtIndex:0];

                NSLog(@"userGetAllFriends first name: %@", bUser.name);
            }
        }
        else
        {
            STFail(@"userGetAllFriends failed !response.isCompleted || !response.result");
            bwaiting = false;
        }
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