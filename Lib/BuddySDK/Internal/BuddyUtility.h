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

#import <Foundation/Foundation.h>
#import "BuddyEnums.h"


@class BuddyCallbackParams;


// API names for use with directPost
#define kPictures_ProfilePhoto_Add @"Pictures_ProfilePhoto_Add"
#define kPictures_Photo_Add @"Pictures_Photo_Add"
#define kPictures_Photo_AddWithWatermark @"Pictures_Photo_AddWithWatermark"

#define kCommerce_Receipt_VerifyiOSReceipt @"Commerce_Receipt_VerifyiOSReceipt"
#define kCommerce_Receipt_VerifyAndSaveiOSReceipt @"Commerce_Receipt_VerifyAndSaveiOSReceipt"

@interface BuddyUtility : NSObject

+ (NSException *)makeInvalidArgException:(NSString *)reason;

+ (void)throwNilArgException:(NSString *)name reason:(NSString *)reason;

+ (void)throwInvalidArgException:(NSString *)name reason:(NSString *)reason;

+ (NSString *)encodeBlob:(NSData *)blob;

+ (NSString *)_base64EncodedString:(NSData *)data;

+ (NSString *)hexadecimalString:(NSData *)data;

+ (NSMutableString*)setParams:(NSString *)api appName:(NSString *)appName appPassword:(NSString *)appPassword;

+ (NSMutableString*)setParams:(NSString *)api appName:(NSString *)appName appPassword:(NSString *)appPassword userToken:(NSString *)userToken;

+ (NSMutableDictionary*)buildCallParams:(NSString *)appName appPassword:(NSString *)appPassword callParams:(NSDictionary*)callParams;

+ (NSString *)encodeValue:(NSString *)rawValue;

+ (NSData *)encodeToBase64:(NSData *)blob;

+ (NSString *)UserGenderToString:(UserGender)userGender;

+ (int)UserStatusToInteger:(UserStatus)userStatus;

+ (UserGender)stringToUserGender:(NSString*)userGender;

+ (UserStatus)stringToUserStatus:(NSString*)userStatus;

+ (NSException *)processStandardErrors:(NSString *)result name:(NSString *)name;

+ (BOOL)isAStandardError:(NSString *)result;

+ (NSString *)buddyDateToString:(NSDate *)date;

+ (NSDate *)buddyDate:(NSString *)date;

+ (NSDate *)dateFromString:(NSString *)date;

+ (double)doubleFromString:(NSString *)string;

+ (int)intFromString:(NSString *)string;

+ (NSString *)stringFromString:(NSString *)string;

+ (BOOL)boolFromString:(NSString *)string;

+ (NSNumber *)NSNumberFromStringInt:(NSString *)stringInt;

+ (BuddyCallbackParams *)buildBuddyFailure:(NSString *)name reason:(NSString *)reason ;

+ (NSNumber *)NSNumberFromStringLong:(NSString *)stringLong;

+ (long long)longFromString:(NSString *)string;

+ (BuddyCallbackParams *)buildBuddyError:(NSString *)name reason:(NSString *)reason ;

+ (BuddyCallbackParams *)buildBuddyServiceError:(NSString *)name reason:(NSString *)reason ;

+ (BOOL)isNilOrEmpty:(NSString *)data;

+ (void)latLongCheck:(double)latitude longitude:(double)longitude className:(NSString *)name;

+ (NSDate *)defaultAfterDate;

+ (void)checkForNilClient:(id)client name:(NSString *)name;

+ (void)checkForNilUser:(id)user name:(NSString *)name;

+ (void)checkForNilClientAndUser:(id)client user:(id)user name:(NSString *)name;

+ (void)checkNameParam:(NSString *)name functionName:(NSString *)functionName;

+ (void)checkBlobParam:(NSData *)blob functionName:(NSString *)functionName;

+ (void)checkRecordLimitParam:(NSNumber *)recordLimit functionName:(NSString *)functionName;

+ (void)checkForToken: (NSString *)token functionName:(NSString *)functionName;

+ (NSException *)makeException:(NSString *)apiCall errorString:(NSString *)error;

+ (NSException *)buildBuddyServiceException:(NSString *)reason;

+ (NSException *)buildBuddyUnknownErrorException:(NSString *)reason;

+ (NSString *)getDeviceModel;

+ (NSString *)deviceName;

+ (NSString *)osVersion;

+ (NSString *)appVersion;

@end
