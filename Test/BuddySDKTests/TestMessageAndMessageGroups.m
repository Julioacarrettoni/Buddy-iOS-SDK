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

#import "TestMessageAndMessageGroups.h"
#import "TestBuddySDK.h"
#import "BuddyCallbackParams.h"
#import "BuddyDataResponses.h"
#import "BuddyBoolResponse.h"
#import "BuddyClient.h"
#import "BuddyMessageGroups.h"
#import "BuddyMessage.h"
#import "BuddyMessageGroup.h"
#import "BuddyGroupMessage.h"


@implementation TestMessageAndMessageGroups

@synthesize tempUser;
@synthesize user;
@synthesize buddyClient;
@synthesize buddyMessages1;
@synthesize buddyMessages2;
@synthesize buddymessageGroupArray;

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

    STAssertNotNil(self.buddyClient, @"TestMessageAndMessageGroups: buddyclient nil");

    self.user = nil;
}

- (void)tearDown
{
    [super tearDown];

    self.buddyClient = nil;
    self.buddymessageGroupArray = nil;
}

- (void)waitloop
{
    NSDate *loopTil = [NSDate dateWithTimeIntervalSinceNow:30];

    while (bwaiting && [loopTil timeIntervalSinceNow] > 0)
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopTil];
}

- (void)testSendMessage
{
    bwaiting = true;
    [self alogin];
    [self waitloop];

    bwaiting = true;
    [self atestCreateAUser];
    [self waitloop];

    bwaiting = true;
    [self atestSendMessage];
    [self waitloop];
}

- (void)testMessageGroups
{
    bwaiting = true;
    [self alogin];
    [self waitloop];

    bwaiting = true;
    [self atestMessageGroups];
    [self waitloop];
}

- (void)testMessageGroupsGetAll
{
    bwaiting = true;
    [self alogin];
    [self waitloop];

    bwaiting = true;
    [self atestMessageGroupsGetAll];
    [self waitloop];

    if (self.buddymessageGroupArray)
    {
        if ([self.buddymessageGroupArray count] > 0)
        {
            bwaiting = true;
            [self deleteAGroup:[self.buddymessageGroupArray objectAtIndex:0]];
            [self waitloop];
        }
        bwaiting = false;
    }
}

- (void)testMessageGroupsGetMy
{
    bwaiting = true;
    [self alogin];
    [self waitloop];

    bwaiting = true;
    [self atestMessageGroupsGetMy];
    [self waitloop];
}

- (void)testMessageCreateGroups
{
    bwaiting = true;
    [self alogin];
    [self waitloop];

    bwaiting = true;
    [self atestCreateAUser];
    [self waitloop];

    bwaiting = true;
    [self atestMessageCreateGroups];
    [self waitloop];

    bwaiting = true;
    [self atestMessageGroupsGetMyAndDelete];
    [self waitloop];
}

- (void)testMessageGroupsGetMyAndLeave
{
    bwaiting = true;
    [self alogin];
    [self waitloop];

    bwaiting = true;
    [self atestMessageGroupsGetMyAndLeave];
    [self waitloop];
}

- (void)atestSendMessage
{
    BuddyUser *buddyUser = self.tempUser;

    [self sendMessage:self.user.messages user:buddyUser];

    // unused variables to help make code coverage results more accurate
    NSString *tmp;
    tmp = buddyUser.name;
    double dub;
    NSNumber *n1 = buddyUser.userId;
    UserGender ug = buddyUser.gender;
    tmp = buddyUser.applicationTag;
    dub = buddyUser.latitude;
    dub = buddyUser.longitude;
    NSDate *date1 = buddyUser.lastLoginOn;
    NSURL *url = buddyUser.profilePicture;
    url = nil;
    NSNumber *num = buddyUser.age;
    UserStatus us = buddyUser.status;
    NSDate *date2 = buddyUser.createdOn;
    dub = buddyUser.distanceInKilometers;
    dub = buddyUser.distanceInMeters;
    dub = buddyUser.distanceInMiles;
    dub = buddyUser.distanceInYards;
    ug = UserGender_Any;
    us = UserStatus_AnyUserStatus;
    date1 = nil;
    num = nil;
    n1 = nil;
    date2 = nil;
}

- (void)sendMessage:(BuddyMessages *)buddyMessages user:(BuddyUser *)buddyUser
{
    [buddyMessages send:buddyUser message:@"hello buddy" appTag:nil state:nil callback:[^(BuddyBoolResponse *response)
    {
        if (response.isCompleted)
        {
            NSLog(@"sendMessage OK");
            [self getMessage:buddyMessages];
        }
        else
        {
            STFail(@"sendMessage failed !response.isCompleted");
            bwaiting = false;
        }
    } copy]];
}

- (void)getMessage:(BuddyMessages *)buddyMessages
{
    NSDate *receiveDate = [self getdefaultDate];

    [buddyMessages getReceived:receiveDate state:nil callback:[^(BuddyArrayResponse *response)
    {
        if (response.isCompleted && [response.result count] > 0)
        {
            NSLog(@"getMessage OK count: %d", [response.result count]);
            [self getSentMessage:buddyMessages];
        }
        else
        {
            if (response.isCompleted == FALSE)
            {
                STFail(@"getMessage failed !response.isCompleted || [response.result count] <= 0");
            }
            bwaiting = false;
        }
    } copy]];
}

- (void)getSentMessage:(BuddyMessages *)buddyMessages
{
    NSDate *sentDate = [self getdefaultDate];

    [buddyMessages getSent:sentDate state:nil callback:[^(BuddyArrayResponse *response)
    {
        if (response.isCompleted && [response.result count] > 0)
        {
            NSLog(@"getSentMessage OK count: %d", [response.result count]);
            // force code coverage to report variables as used
            BuddyMessage *bm = [response.result objectAtIndex:0];
            NSDate *date = bm.dateSent;
            NSNumber *num = bm.fromUserId;
            NSNumber *num1 = bm.toUserId;
            NSString *tmp = bm.text;
            date = nil;
            num = nil;
            num1 = nil;
            tmp = nil;
        }
        else
        {
            STFail(@"getSentMessage failed !response.isCompleted || [response.result count] <= 0");
        }
        bwaiting = false;
    } copy]];
}

- (void)atestMessageGroups
{
    [self CheckIfGroupsNameExists:self.user.messages warnOnFound:TRUE];
}

- (void)CheckIfGroupsNameExists:(BuddyMessages *)buddyMessages warnOnFound:(BOOL)warn
{
    int rand = arc4random();
    NSString *GroupName = [NSString stringWithFormat:@"groups%d", rand];

    [buddyMessages.groups checkIfExists:GroupName state:nil callback:[^(BuddyBoolResponse *response)
    {
        if (response.isCompleted)
        {
            NSLog(@"CheckIfGroupsNameExists OK");
            if (response.result)
            {
                if (warn)
                {
                    STFail(@"CheckIfGroupsNameExists failed group is found");
                }
            }
            else
            {
                [self CreateGroup:GroupName massageObj:buddyMessages];
            }
        }
        else
        {
            STFail(@"CheckIfGroupsNameExists failed !response.isCompleted");
            bwaiting = false;
        }
    } copy]];
}

- (void)CheckIfGroupNameExists:(BuddyMessages *)buddyMessages groupName:(NSString *)groupName
{
    [buddyMessages.groups checkIfExists:groupName state:nil callback:[^(BuddyBoolResponse *response)
    {
        if (response.isCompleted)
        {
            if (response.result == FALSE)
            {
                STFail(@"CheckIfGroupNameExists failed to find group");
            }
            else
            {
                NSLog(@"CheckIfGroupNameExists OK");
            }
        }
        else
        {
            STFail(@"CheckIfGroupNameExists failed !response.isCompleted");
        }
        bwaiting = false;
    } copy]];
}

- (void)CreateGroup:(NSString *)groupName massageObj:(BuddyMessages *)buddyMessages
{
    [buddyMessages.groups create:groupName openGroup:FALSE appTag:nil state:nil callback:[^(BuddyMessageGroupResponse *response)
    {
        if (response.isCompleted && [response.result.name isEqualToString:groupName])
        {
            NSLog(@"CreateGroup OK");

            // unused variables to help make code coverage results more accurate
            NSString *tmp;
            NSNumber *numID = response.result.groupId;
            tmp = response.result.name;
            NSDate *date = response.result.createdOn;
            tmp = response.result.appTag;
            NSNumber *num = response.result.ownerUserId;
            NSArray *ary = response.result.memberUserIds;

            [self CheckIfGroupNameExists:buddyMessages groupName:groupName];
            date = nil;
            num = nil;
            numID = nil;
            ary = nil;
        }
        else
        {
            STFail(@"CreateGroup failed !response.isCompleted || ![response.result.name isEqualToString:groupName]");
            bwaiting = false;
        }
    } copy]];
}

- (void)atestMessageGroupsGetAll
{
    [self getAll:self.user.messages];
}

- (void)getAll:(BuddyMessages *)buddyMessages
{
    [buddyMessages.groups getAll:nil callback:[^(BuddyArrayResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            self.buddymessageGroupArray = response.result;
            NSLog(@"MessageGroupsGetAll OK total: %d", [response.result count]);
            bwaiting = false;
        }
        else
        {
            STFail(@"MessageGroupsGetAll failed !response.isCompleted || !response.result");
            bwaiting = false;
        }
    } copy]];
}

- (void)atestMessageGroupsGetMy
{
    [self getMy:self.user.messages];
}

- (void)getMy:(BuddyMessages *)buddyMessages
{
    [buddyMessages.groups getMy:nil callback:[^(BuddyArrayResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSArray *messageGroupArray = response.result;

            NSLog(@"MessageGroupsGetMy OK total: %d", [messageGroupArray count]);

            for (int i = 0; i < [messageGroupArray count]; i++)
            {
                BuddyMessageGroup *messageGroup = [messageGroupArray objectAtIndex:i];
                NSLog(@"group name %@", messageGroup.name);
                if (i == 1)
                {
                    [self deleteGroup:messageGroup];
                }
            }
            if ([messageGroupArray count] == 0)
            {
                bwaiting = false;
            }
        }
        else
        {
            STFail(@"MessageGroupsGetMy failed !response.isCompleted || !response.result");
            bwaiting = false;
        }
    } copy]];
}

- (void)deleteGroup:(BuddyMessageGroup *)messageGroup
{
    [messageGroup delete:nil callback:[^(BuddyBoolResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"deleteGroup OK");
        }
        else
        {
            STFail(@"deleteGroup failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)atestCreateAUser
{
    int rand = arc4random();
    NSString *userName = [NSString stringWithFormat:@"user%d", rand];
    NSNumber *age = [NSNumber numberWithInt:100];

    [self.buddyClient createUser:userName password:@"123" gender:UserGender_Any age:age email:@"email" status:UserStatus_AnyUserStatus fuzzLocation:FALSE celebrityMode:FALSE appTag:nil state:nil callback:[^(BuddyAuthenticatedUserResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            self.tempUser = response.result;
            NSLog(@"atestCreateAUser OK");
        }
        else
        {
            STFail(@"atestCreateAUser failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)atestMessageCreateGroups
{
    [self makeGroups:self.user.messages];
}

- (void)makeGroups:(BuddyMessages *)buddyMessages
{
    int rand = arc4random();
    NSString *groupName = [NSString stringWithFormat:@"groups%d", rand];

    NSLog(@"CreateAGroup called %@", groupName);
    [self CreateAGroup:groupName massageObj:buddyMessages];
}

- (void)CreateAGroup:(NSString *)groupName massageObj:(BuddyMessages *)buddyMessages
{
    [buddyMessages.groups create:groupName openGroup:TRUE appTag:nil state:nil callback:[^(BuddyMessageGroupResponse *response)
    {
        if (response.isCompleted)
        {
            NSLog(@"CreateAGroup OK");
            if ([response.result.name isEqualToString:groupName] == FALSE)
            {
                STFail(@"CreateAGroup failed");
            }
            else
            {
                [self joinGroup:response.result];
            }
        }
        else
        {
            STFail(@"CreateAGroup failed !response.isCompleted");
        }
    } copy]];
}

- (void)joinGroup:(BuddyMessageGroup *)buddyMessageGroup
{
    [buddyMessageGroup join:nil callback:[^(BuddyBoolResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"joinGroup OK");
            [self addUser:buddyMessageGroup];
        }
        else
        {
            STFail(@"joinGroup failed !response.isCompleted || !response.result");
        }
    } copy]];
}

- (void)atestMessageGroupsGetMyAndLeave
{
    [self getMyAndLeave:self.user.messages];
}

- (void)getMyAndLeave:(BuddyMessages *)buddyMessages
{
    [buddyMessages.groups getMy:nil callback:[^(BuddyArrayResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSArray *messagesGroupArray = response.result;

            NSLog(@"getMyAndLeave OK groups total = %d", [messagesGroupArray count]);

            if (messagesGroupArray != nil && [messagesGroupArray count] > 0)
            {
                for (int i = 0; i < [messagesGroupArray count]; i++)
                {
                    [self leaveGroup:[messagesGroupArray objectAtIndex:i]];
                }
                [self sendAMessage:[messagesGroupArray objectAtIndex:0]];
            }
            else
            {
                bwaiting = false;
            }
        }
        else
        {
            STFail(@"getMyAndLeave failed  !response.isCompleted || !response.result");
            bwaiting = false;
        }
    } copy]];
}

- (void)leaveGroup:(BuddyMessageGroup *)buddyMessageGroup
{
    [buddyMessageGroup leave:nil callback:[^(BuddyBoolResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"leaveGroup OK");
        }
        else
        {
            STFail(@"leaveGroup failed !response.isCompleted || !response.result");
        }
    } copy]];
}

- (void)atestMessageGroupsGetMyAndDelete
{
    [self getMyAndDelete:self.user.messages];
}

- (void)getMyAndDelete:(BuddyMessages *)buddyMessages
{
    [buddyMessages.groups getMy:nil callback:[^(BuddyArrayResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSArray *messagesGroupArray = response.result;

            NSLog(@"getMyAndDelete OK groups total = %d", [messagesGroupArray count]);

            int icount = [messagesGroupArray count];
            [self deleteAGroup:[messagesGroupArray objectAtIndex:icount - 1]];
        }
        else
        {
            STFail(@"getMyAndDelete failed !response.isCompleted || !response.result");
            bwaiting = false;
        }
    } copy]];
}

- (void)addUser:(BuddyMessageGroup *)buddyMessageGroup
{
    __block BuddyMessageGroup *_buddyMessageGroup = buddyMessageGroup;

    [buddyMessageGroup addUser:self.tempUser state:nil callback:[^(BuddyBoolResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"addUser OK");
            [self removeUser:_buddyMessageGroup];
        }
        else
        {
            STFail(@"addUser failed !response.isCompleted || !response.result");
            bwaiting = false;
        }
    } copy]];
}

- (void)removeUser:(BuddyMessageGroup *)buddyMessageGroup
{
    [buddyMessageGroup removeUser:self.tempUser state:nil callback:[^(BuddyBoolResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"removeUser OK");
        }
        else
        {
            STFail(@"removeUser failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)deleteAGroup:(BuddyMessageGroup *)buddyMessageGroup
{
    [buddyMessageGroup delete:nil callback:[^(BuddyBoolResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"deleteAGroup OK");
        }
        else
        {
            NSLog(@"deleteAGroup failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)sendAMessage:(BuddyMessageGroup *)buddyMessageGroup
{
    [buddyMessageGroup sendMessage:@"Hello" latitude:0.0 longitude:0.0 appTag:nil state:nil callback:[^(BuddyDictionaryResponse *response)
    {
        if (response.isCompleted && response.result != nil)
        {
            NSLog(@"sendAMessage OK");
            [self getallForGroup:buddyMessageGroup];
        }
        else
        {
            STFail(@"sendAMessage failed !response.isCompleted || response.result == nil");
            bwaiting = false;
        }
    } copy]];
}

- (NSDate *)getdefaultDate
{
    NSString *date = @"01-Jan-50";
    NSDateFormatter *df = [[NSDateFormatter alloc] init];

    df.dateFormat = @"dd-MMM-yy";
    return [df dateFromString:date];
}

- (void)getallForGroup:(BuddyMessageGroup *)buddyMessageGroup
{
    NSDate *receivedDate = [self getdefaultDate];

    [buddyMessageGroup getReceived:receivedDate state:nil callback:[^(BuddyArrayResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSArray *array = response.result;
            NSLog(@"getallForGroup OK count: %d", [array count]);
            if ([response.result count] > 0)
            {
                // unused variables to help make code coverage results more accurate
                double dub;
                BuddyGroupMessage *bG = [response.result objectAtIndex:0];
                NSDate *date = bG.dateSent;
                NSNumber *num = bG.fromUserID;
                BuddyMessageGroup *group = bG.group;
                NSString *tmp = bG.text;
                dub = bG.latitude;
                dub = bG.longitude;
                date = nil;
                num = nil;
                group = nil;
                tmp = nil;
            }
        }
        else
        {
            STFail(@"getallForGroup failed  !response.isCompleted || !response.result");
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
        }
        else
        {
            STFail(@"alogin  failed !response.isCompleted");
        }
        bwaiting = false;
    } copy]];
}

- (void)testMessageParsing
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_MessageListGet"];

    bwaiting = true;
    [self alogin];
    [self waitloop];

    if (!self.user)
    {
        STFail(@"testMessageParsing login failed.");
        return;
    }

    NSArray *dict = [self.user.messages performSelector:@selector(makeMessageList:) withObject:resArray];
    if ([dict count] != 2)
    {
        STFail(@"testMessageParsing failed dict should have 2 items");
    }

    resArray = [TestBuddySDK GetTextFileData:@"Test_NoData"];
    dict = [self.user.messages performSelector:@selector(makeMessageList:) withObject:resArray];
    if ([dict count] != 0)
    {
        STFail(@"testMessageParsing failed dict should have 0 items");
    }

    resArray = [TestBuddySDK GetTextFileData:@"Test_EmptyData"];
    dict = [self.user.messages performSelector:@selector(makeMessageList:) withObject:resArray];
    if ([dict count] != 0)
    {
        STFail(@"testMessageParsing failed dict should have 0 items");
    }

    resArray = [TestBuddySDK GetTextFileData:@"Test_MessageListGetBad"];
    dict = [self.user.messages performSelector:@selector(makeMessageList:) withObject:resArray];
    if ([dict count] != 2)
    {
        STFail(@"testMessageParsing failed dict should have 2 items");
    }
}

- (void)testMessageParsingTo
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_MessageListGet"];

    bwaiting = true;
    [self alogin];
    [self waitloop];

    if (!self.user)
    {
        STFail(@"testMessageParsingTo login failed.");
        return;
    }

    NSArray *dict = [self.user.messages performSelector:@selector(makeMessageList:) withObject:resArray];
    if ([dict count] != 2)
    {
        STFail(@"testMessageParsingTo failed dict should have 2 items");
    }

    resArray = [TestBuddySDK GetTextFileData:@"Test_NoData"];
    dict = [self.user.messages performSelector:@selector(makeMessageList:) withObject:resArray];
    if ([dict count] != 0)
    {
        STFail(@"testMessageParsingTo failed dict should have 0 items");
    }

    resArray = [TestBuddySDK GetTextFileData:@"Test_EmptyData"];
    dict = [self.user.messages performSelector:@selector(makeMessageList:) withObject:resArray];
    if ([dict count] != 0)
    {
        STFail(@"testMessageParsingTo failed dict should have 0 items");
    }

    resArray = [TestBuddySDK GetTextFileData:@"Test_MessageListGetBad"];
    dict = [self.user.messages performSelector:@selector(makeMessageList:) withObject:resArray];
    if ([dict count] != 2)
    {
        STFail(@"testMessageParsingTo failed dict should have 2 items");
    }
}

- (void)testMessageParsingFrom
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_MessageListGet"];

    bwaiting = true;
    [self alogin];
    [self waitloop];

    if (!self.user)
    {
        STFail(@"testMessageParsingFrom login failed.");
        return;
    }

    NSArray *dict = [self.user.messages performSelector:@selector(makeMessageList:) withObject:resArray];
    if ([dict count] != 2)
    {
        STFail(@"testMessageParsingFrom failed dict should have 2 items");
    }

    resArray = [TestBuddySDK GetTextFileData:@"Test_NoData"];
    dict = [self.user.messages performSelector:@selector(makeMessageList:) withObject:resArray];
    if ([dict count] != 0)
    {
        STFail(@"testMessageParsingFrom failed dict should have 0 items");
    }

    resArray = [TestBuddySDK GetTextFileData:@"Test_EmptyData"];
    dict = [self.user.messages performSelector:@selector(makeMessageList:) withObject:resArray];
    if ([dict count] != 0)
    {
        STFail(@"testMessageParsingFrom failed dict should have 0 items");
    }

    resArray = [TestBuddySDK GetTextFileData:@"Test_MessageListGetBad"];
    dict = [self.user.messages performSelector:@selector(makeMessageList:) withObject:resArray];
    if ([dict count] != 2)
    {
        STFail(@"testMessageParsingFrom failed dict should have 2 items");
    }
}

- (void)testMessageParsingGroups
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_GroupMessagesMembershipGetAllGroups"];

    bwaiting = true;
    [self alogin];
    [self waitloop];

    if (!self.user)
    {
        STFail(@"testMessageParsingGroups login failed.");
        return;
    }

    NSArray *dict = [self.user.messages.groups performSelector:@selector(makeMessageGroupList:) withObject:resArray];
    if ([dict count] != 3)
    {
        STFail(@"testMessageParsingGroups failed dict should have 3 items");
    }
    else
    {
        BuddyMessageGroup *pMG = (BuddyMessageGroup *) [dict objectAtIndex:0];

        NSArray *messageArray = [TestBuddySDK GetTextFileData:@"Test_GroupMessage"];
        if ([messageArray count] > 0)
        {
            NSArray *aryGroupsMessage = [pMG performSelector:@selector(makeGroupMessageList:) withObject:messageArray];
            if ([aryGroupsMessage count] > 0)
            {
                BuddyGroupMessage *bgm = (BuddyGroupMessage *) [aryGroupsMessage objectAtIndex:0];
                NSString *tmp;
                double dub;
                tmp = bgm.text;
                dub = bgm.latitude;
                dub = bgm.longitude;
                NSNumber *num = bgm.fromUserID;
                NSDate *date = bgm.dateSent;
                date = nil;
                num = nil;
            }
        }
    }

    resArray = [TestBuddySDK GetTextFileData:@"Test_NoData"];
    dict = [self.user.messages.groups performSelector:@selector(makeMessageGroupList:) withObject:resArray];
    if ([dict count] != 0)
    {
        STFail(@"testMessageParsingGroups failed dict should have 0 items");
    }


    resArray = [TestBuddySDK GetTextFileData:@"Test_EmptyData"];
    dict = [self.user.messages.groups performSelector:@selector(makeMessageGroupList:) withObject:resArray];
    if ([dict count] != 0)
    {
        STFail(@"testMessageParsingGroups failed dict should have 0 items");
    }
}

@end