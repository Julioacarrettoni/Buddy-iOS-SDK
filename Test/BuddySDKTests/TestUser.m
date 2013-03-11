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

#import "TestUser.h"
#import "BuddyCallbackParams.h"
#import "BuddyDataResponses.h"
#import "BuddyBoolResponse.h"
#import "BuddyClient.h"
#import "BuddyCheckInLocation.h"


@implementation TestUser

static NSString *AppName = @"Buddy iOS SDK test app";
static NSString *AppPassword = @"8C9E044D-7DB7-42DE-A376-16460B58008E";
static bool bwaiting = false;
static NSString *Token = @"UT-76444f9f-4a4b-4d3d-ba5c-7a82b5dbb5a5";

@synthesize buddyUser;
@synthesize buddyClient;
@synthesize tempUser;
@synthesize sessionID;

static int _checking_count = 0;

- (void)setUp
{
    [super setUp];

    self.buddyClient = [[BuddyClient alloc] initClient:AppName
                                           appPassword:AppPassword
                                            appVersion:@"1"
                                  autoRecordDeviceInfo:TRUE];

    STAssertNotNil(self.buddyClient, @"TestUser failed buddyClient nil");
}

- (void)tearDown
{
    [super tearDown];

    self.buddyClient = nil;
    self.buddyUser = nil;
}

- (void)waitloop
{
    NSDate *loopTil = [NSDate dateWithTimeIntervalSinceNow:15];

    while (bwaiting && [loopTil timeIntervalSinceNow] > 0)
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopTil];
}

- (void)testSessionMetrics
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
        STFail(@"testSessionMetrics failed to login");
        return;
    }

    int icount = 5;
    while (icount != 0)
    {
        int r = arc4random();
        NSString *name = [NSString stringWithFormat:@"sessionName%d", r];

        bwaiting = true;
        [self aStartSession:name];
        [self waitloop];

        bwaiting = true;
        [self aRecordSession];
        [self waitloop];

        bwaiting = true;
        [self aEndSession];
        [self waitloop];

        icount--;
    }
}

- (void)aStartSession:(NSString *)name
{
    [self.buddyClient StartSession:self.buddyUser sessionName:name appTag:nil state:nil callback:[^(BuddyStringResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"aStartSession OK");
            self.sessionID = (NSString *) response.result;
        }
        else
        {
            STFail(@"aStartSession failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)aEndSession
{
    [self.buddyClient EndSession:self.buddyUser sessionId:self.sessionID appTag:nil state:nil callback:[^(BuddyBoolResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"aEndSession OK");
        }
        else
        {
            STFail(@"aEndSession failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)aRecordSession
{
    int r = arc4random();
    NSString *name = [NSString stringWithFormat:@"sessionName%d", r];

    [self.buddyClient RecordSessionMetric:self.buddyUser sessionId:self.sessionID metricKey:name metricValue:name appTag:nil state:nil callback:[^(BuddyBoolResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"aRecordSession OK");
        }
        else
        {
            STFail(@"aRecordSession failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)testCheckIns
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
        STFail(@"testCheckIns failed to login");
        return;
    }

    int icount = 5;

    while (icount != 0)
    {
        _checking_count = 0;
        bwaiting = true;
        [self aGetCheckIn];
        [self waitloop];
        int oldcheckin = _checking_count;

        bwaiting = true;
        [self aCheckIn];
        [self waitloop];

        bwaiting = true;
        [self aGetCheckIn];
        [self waitloop];

        if (oldcheckin != (_checking_count - 1))
        {
            STFail(@"testCheckIns failed counts differ from expected");
        }

        bwaiting = true;
        [self aGetProfilePhotos];
        [self waitloop];

        icount--;
    }
}

- (void)aGetCheckIn
{
    NSString *date = @"03-Sep-50";
    NSDateFormatter *df = [[NSDateFormatter alloc] init];

    df.dateFormat = @"dd-MMM-yy";
    NSDate *dd = [df dateFromString:date];

    [self.buddyUser getCheckins:dd state:nil callback:[^(BuddyArrayResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            bwaiting = false;
            NSArray *array = (NSArray *) response.result;
            _checking_count = [array count];
            if (_checking_count > 0)
            {
                // unused variables to help make code coverage results more accurate
                BuddyCheckInLocation *location = [response.result objectAtIndex:0];
                NSString *tmp = location.appTag;
                double dub;
                dub = location.latitude;
                dub = location.longitude;
                NSDate *date = location.checkinDate;
                tmp = location.placeName;
                tmp = location.comment;
                tmp = location.appTag;
                date = nil;
            }
            NSLog(@"aGetCheckIn OK");
        }
        else
        {
            STFail(@"aGetCheckIn failed !response.isCompleted || !response.result");
            bwaiting = false;
        }
    } copy]];
}

- (void)aCheckIn
{
    [self.buddyUser checkIn:18.0 longitude:50.0 comment:@"comment" appTag:@"apptag" state:nil callback:[^(BuddyBoolResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"aCheckIn OK");
        }
        else
        {
            STFail(@"aCheckIn failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)testfindUser
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
        STFail(@"testfindUser failed to login");
        return;
    }

    int icount = 4;
    while (icount != 0)
    {
        bwaiting = true;
        @try
        {
            [self aFindUser];
            [self waitloop];
        }
        @catch (NSException *exception)
        {
            NSLog(@"exception %@", exception.reason);
        }

        bwaiting = true;
        @try
        {
            [self aFindUsersLat];
            [self waitloop];
        }
        @catch (NSException *exception)
        {
            NSLog(@"exception %@", exception.reason);
        }

        bwaiting = true;
        @try
        {
            [self aFindUsersLong];
            [self waitloop];
        }
        @catch (NSException *exception)
        {
            NSLog(@"exception %@", exception.reason);
        }

        bwaiting = true;
        [self aFindUserAnyGender];
        [self waitloop];

        icount--;
    }
}

- (void)aFindUserAnyGender
{
    [self.buddyUser findUser:0.0 longitude:0.0 searchDistance:nil recordLimit:nil gender:UserGender_Any ageStart:nil ageStop:nil userStatus:UserStatus_AnyUserStatus checkinsWithinMinutes:nil appTag:nil state:nil callback:[^(BuddyDataResponses *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"aFindUserAnyGender OK");
        }
        else
        {
            STFail(@"aFindUserAnyGender failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)aFindUser
{
    NSNumber *searchDistance = [NSNumber numberWithInt:-1];

    [self.buddyUser findUser:searchDistance state:nil callback:[^(BuddyDataResponses *response)
    {
        if (response.isCompleted)
        {
            NSLog(@"afindUser OK");
        }
        else
        {
            STFail(@"afindUser failed !response.isCompleted");
        }
        bwaiting = false;
    } copy]];
}

- (void)aFindUsersLat
{
    NSNumber *searchDistance = [NSNumber numberWithInt:-1];

    [self.buddyUser findUser:91.0 longitude:0 searchDistance:searchDistance
                    callback:[^(BuddyDataResponses *response)
                    {
                        if (response.isCompleted)
                        {
                            NSLog(@"aFindUsersLat OK");
                        }
                        else
                        {
                            STFail(@"aFindUsersLat failed !response.isCompleted");
                        }
                        bwaiting = false;
                    } copy]];
}

- (void)aFindUsersLong
{
    NSNumber *searchDistance = [NSNumber numberWithInt:-1];

    [self.buddyUser findUser:0 longitude:190.0 searchDistance:searchDistance
                    callback:[^(BuddyDataResponses *response)
                    {
                        if (response.isCompleted)
                        {
                            NSLog(@"afindUser OK");
                        }
                        else
                        {
                            STFail(@"aFindUsersLong failed !response.isCompleted");
                        }
                        bwaiting = false;
                    } copy]];
}

- (void)testUpdate
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
        STFail(@"testUpdate failed to login");
        return;
    }

    int icount = 4;
    while (icount != 0)
    {
        int r = arc4random();
        NSString *name = [NSString stringWithFormat:@"email@buddy.com%d", r];

        bwaiting = true;
        [self aUpdate:name];
        [self waitloop];

        bwaiting = true;
        [self aloginTempUser];
        [self waitloop];

        [self compare];

        icount--;
    }
}

- (void)compare
{
    if (![self.buddyUser.email isEqualToString:self.tempUser.email])
    {
        NSLog(@"compare OK");
    }

    if ([self.buddyUser.age intValue] != [self.tempUser.age intValue])
    {
        STFail(@"compare");
    }
}

- (void)aUpdate:(NSString *)email
{
    NSNumber *age = [NSNumber numberWithInt:arc4random() % 100];

    [self.buddyUser update:@"Malcolm-xvMMMM" password:@"jackjackjack" gender:UserGender_Any age:age email:email userStatus:UserStatus_AnyUserStatus fuzzLocation:TRUE celebrityMode:TRUE appTag:@"appTag" state:nil callback:[^(BuddyBoolResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"aUpdate OK");
        }
        else
        {
            STFail(@"aUpdate !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)testAuth
{
    bwaiting = true;
    [self alogin];
    [self waitloop];

    int icount = 4;
    while (icount != 0)
    {
        bwaiting = true;
        [self aloginBadUserPassword];
        [self waitloop];

        bwaiting = true;
        [self aloginWithBadToken];
        [self waitloop];

        icount--;
    }
}

- (void)testCreateUser
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
        STFail(@"testCreateUserfailed to login");
        return;
    }


    int icount = 4;
    while (icount != 0)
    {
        int r = arc4random() + (arc4random() % 1000);
        NSString *name = [NSString stringWithFormat:@"testUser%d", r];
        NSString *password = @"password";

        bwaiting = true;
        [self loginAndDelete:name password:password];
        [self waitloop];

        bwaiting = true;
        [self createUserForDelete:name password:password];
        [self waitloop];

        bwaiting = true;
        [self deleteTempUser];
        [self waitloop];

        bwaiting = true;
        [self loginAndDelete:name password:password];
        [self waitloop];

        bwaiting = true;
        [self deleteTempUser];
        [self waitloop];

        bwaiting = true;
        [self createUser:name password:password];
        [self waitloop];

        icount--;
    }
}

- (void)loginAndDelete:(NSString *)suser password:(NSString *)password
{
    [self.buddyClient login:suser password:password state:nil callback:[^(BuddyDataResponses *response)
    {
        if (response.isCompleted && response.result)
        {
            BuddyAuthenticatedUser *authUser = (BuddyAuthenticatedUser *) response.result;
            [authUser delete:nil callback:[^(BuddyBoolResponse *response2)
            {
                bwaiting = false;
            } copy]];
        }
        else
        {
            bwaiting = false;
        }
    } copy]];
}

- (void)deleteTempUser
{
    [self.tempUser delete:nil callback:[^(BuddyBoolResponse *response)
    {
        if (!response.isCompleted || !response.result)
        {
            STFail(@"deleteTempUser failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)createUser:(NSString *)suser password:(NSString *)password
{
    NSNumber *age = [NSNumber numberWithInt:100];

    [self.buddyClient createUser:suser password:password gender:UserGender_Any age:age email:nil status:UserStatus_Widowed fuzzLocation:FALSE celebrityMode:FALSE appTag:nil state:nil callback:[^(BuddyAuthenticatedUserResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"createUser OK");
            self.tempUser = response.result;
        }
        else
        {
            STFail(@"createUser failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)aGetProfilePhotos
{
    [self.buddyUser getProfilePhotos:nil callback:[^(BuddyArrayResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"aGetProfilePhotos OK count: %d", [response.result count]);
        }
        else
        {
            STFail(@"aGetProfilePhotos failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)createUserAlreadyExists:(NSString *)suser password:(NSString *)password
{
    NSNumber *age = [NSNumber numberWithInt:100];

    [self.buddyClient createUser:suser password:password gender:UserGender_Any age:age email:nil status:UserStatus_Widowed fuzzLocation:FALSE celebrityMode:FALSE appTag:nil state:nil callback:[^(BuddyAuthenticatedUserResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            STFail(@"createUserAlreadyExists failed response.isCompleted && response.result");
        }
        else
        {
            NSLog(@"createUserAlreadyExists OK");
        }
        bwaiting = false;
    } copy]];
}

- (void)createUserForDelete:(NSString *)suser password:(NSString *)password
{
    NSNumber *age = [NSNumber numberWithInt:100];

    [self.buddyClient createUser:suser password:password gender:UserGender_Any age:age email:nil status:UserStatus_Widowed fuzzLocation:FALSE celebrityMode:FALSE appTag:nil state:nil callback:[^(BuddyAuthenticatedUserResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            self.tempUser = response.result;
            NSLog(@"createUserForDelete OK");
        }
        else
        {
            STFail(@"createUserForDelete failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)aloginBadUserPassword
{
    [self.buddyClient login:@"testBuddyUser1353190658" password:@"jackjack55555555555555555555555" state:nil callback:[^(BuddyAuthenticatedUserResponse *response)
    {
        if (response.isCompleted)
        {
            STFail(@"aloginBadUserPassword failed response.isCompleted");
        }

        STAssertNil(response.result, @"aloginBadUserPassword failed response.isCompleted nil");

        if (response.isCompleted && response.result)
        {
            STFail(@"aloginBadUserPassword failed  !response.isCompleted || !response.result");
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
            self.buddyUser = response.result;
            NSLog(@"alogin OK");
        }
        else
        {
            STFail(@"alogin failed !response.isCompleted");
        }
        bwaiting = false;
    } copy]];
}

- (void)aloginTempUser
{
    [self.buddyClient login:Token state:nil callback:[^(BuddyAuthenticatedUserResponse *response)
    {
        if (response.isCompleted)
        {
            self.tempUser = response.result;
            NSLog(@"aloginTempUser OK");
        }
        else
        {
            STFail(@"aloginTempUser failed !response.isCompleted");
        }
        bwaiting = false;
    } copy]];
}

- (void)aloginWithToken
{
    [self.buddyClient login:Token state:nil callback:[^(BuddyAuthenticatedUserResponse *response)
    {
        if (response.isCompleted)
        {
            BuddyAuthenticatedUser *authUser = response.result;
            if (![self.buddyUser.token isEqualToString:authUser.token])
            {
                STFail(@"aaloginWithToken failed token mismatch");
            }
        }
        else
        {
            STFail(@"aloginWithToken failed !response.isCompleted");
        }
        bwaiting = false;
    } copy]];
}

- (void)aloginWithBadToken
{
    [self.buddyClient login:@"token" state:nil callback:[^(BuddyAuthenticatedUserResponse *response)
    {
        if (response.isCompleted)
        {
            STFail(@"aloginWithBadToken failed response.isCompleted");
        }
        else
        {
            NSLog(@"loginWithBadToken OK");
        }
        bwaiting = false;
    } copy]];
}

@end