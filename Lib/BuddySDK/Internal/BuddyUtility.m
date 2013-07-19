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

#import "BuddyUtility.h"
#import "BuddyDataResponses_Exn.h"
#if __IPHONE_OS_VERSION_MIN_REQUIRED
#import <UIKit/UIKit.h>
#endif
#include <sys/sysctl.h>


#define kBuddyServiceException @"BuddyServiceException"
#define kBuddyUnknownErrorException @"BuddyUnknownErrorException"

@implementation BuddyUtility

//
//  NSData+Base64.h
//  base64
//
//  Created by Matt Gallagher on 2009/06/03.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//
//  This software is provided 'as-is', without any express or implied
//  warranty. In no event will the authors be held liable for any damages
//  arising from the use of this software. Permission is granted to anyone to
//  use this software for any purpose, including commercial applications, and to
//  alter it and redistribute it freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//     claim that you wrote the original software. If you use this software
//     in a product, an acknowledgment in the product documentation would be
//     appreciated but is not required.
//  2. Altered source versions must be plainly marked as such, and must not be
//     misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source
//     distribution.
//
//
// Mapping from 6 bit pattern to ASCII character.
//
static unsigned char base64EncodeLookup[65] =
"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

//
// Definition for "masked-out" areas of the base64DecodeLookup mapping
//
#define xx 65

//
// Mapping from ASCII character to 6 bit pattern.
//
/* used in decode we don't
static unsigned char base64DecodeLookup[256] =
{
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 62, xx, xx, xx, 63, 
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, xx, xx, xx, xx, xx, xx, 
    xx,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, xx, xx, xx, xx, xx, 
    xx, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
};
*/
//
// Fundamental sizes of the binary and base64 encode/decode units in bytes
//
#define BINARY_UNIT_SIZE 3
#define BASE64_UNIT_SIZE 4

//
// NewBase64Decode
//
// Decodes the base64 ASCII string in the inputBuffer to a newly malloced
// output buffer.
//
//  inputBuffer - the source ASCII string for the decode
//	length - the length of the string or -1 (to specify strlen should be used)
//	outputLength - if not-NULL, on output will contain the decoded length
//
// returns the decoded buffer. Must be free'd by caller. Length is given by
//	outputLength.
//
/*
void *_NewBase64Decode(
                      const char *inputBuffer,
                      size_t length,
                      size_t *outputLength)
{
	if (length == -1)
	{
		length = strlen(inputBuffer);
	}
	
	size_t outputBufferSize =
    ((length+BASE64_UNIT_SIZE-1) / BASE64_UNIT_SIZE) * BINARY_UNIT_SIZE;
	unsigned char *outputBuffer = (unsigned char *)malloc(outputBufferSize);
	
	size_t i = 0;
	size_t j = 0;
	while (i < length)
	{
		//
		// Accumulate 4 valid characters (ignore everything else)
		//
		unsigned char accumulated[BASE64_UNIT_SIZE];
		size_t accumulateIndex = 0;
		while (i < length)
		{
			unsigned char decode = base64DecodeLookup[inputBuffer[i++]];
			if (decode != xx)
			{
				accumulated[accumulateIndex] = decode;
				accumulateIndex++;
				
				if (accumulateIndex == BASE64_UNIT_SIZE)
				{
					break;
				}
			}
		}
		
		//
		// Store the 6 bits from each of the 4 characters as 3 bytes
		//
		// (Uses improved bounds checking suggested by Alexandre Colucci)
		//
		if (accumulateIndex >= 2)  
			outputBuffer[j] = (accumulated[0] << 2) | (accumulated[1] >> 4);  
		if (accumulateIndex >= 3)  
			outputBuffer[j + 1] = (accumulated[1] << 4) | (accumulated[2] >> 2);  
		if (accumulateIndex >= 4)  
			outputBuffer[j + 2] = (accumulated[2] << 6) | accumulated[3];
		j += accumulateIndex - 1;
	}
	
	if (outputLength)
	{
		*outputLength = j;
	}
	return outputBuffer;
}
*/

//
// NewBase64Encode
//
// Encodes the arbitrary data in the inputBuffer as base64 into a newly malloced
// output buffer.
//
//  inputBuffer - the source data for the encode
//	length - the length of the input in bytes
//  separateLines - if zero, no CR/LF characters will be added. Otherwise
//		a CR/LF pair will be added every 64 encoded chars.
//	outputLength - if not-NULL, on output will contain the encoded length
//		(not including terminating 0 char)
//
// returns the encoded buffer. Must be free'd by caller. Length is given by
//	outputLength.
//

char *_NewBase64Encode(
                       const void *buffer,
                       size_t length,
                       bool separateLines,
                       size_t *outputLength)
{
	const unsigned char *inputBuffer = (const unsigned char *)buffer;
	
#define MAX_NUM_PADDING_CHARS 2
#define OUTPUT_LINE_LENGTH 64
#define INPUT_LINE_LENGTH ((OUTPUT_LINE_LENGTH / BASE64_UNIT_SIZE) * BINARY_UNIT_SIZE)
#define CR_LF_SIZE 2
	
	//
	// Byte accurate calculation of final buffer size
	//
	size_t outputBufferSize =
    ((length / BINARY_UNIT_SIZE)
     + ((length % BINARY_UNIT_SIZE) ? 1 : 0))
    * BASE64_UNIT_SIZE;
	if (separateLines)
	{
		outputBufferSize +=
        (outputBufferSize / OUTPUT_LINE_LENGTH) * CR_LF_SIZE;
	}
	
	//
	// Include space for a terminating zero
	//
	outputBufferSize += 1;
    
	//
	// Allocate the output buffer
	//
	char *outputBuffer = (char *)malloc(outputBufferSize);
	if (!outputBuffer)
	{
		return NULL;
	}
    
	size_t i = 0;
	size_t j = 0;
	const size_t lineLength = separateLines ? INPUT_LINE_LENGTH : length;
	size_t lineEnd = lineLength;
	
	while (true)
	{
		if (lineEnd > length)
		{
			lineEnd = length;
		}
        
		for (; i + BINARY_UNIT_SIZE - 1 < lineEnd; i += BINARY_UNIT_SIZE)
		{
			//
			// Inner loop: turn 48 bytes into 64 base64 characters
			//
			outputBuffer[j++] = base64EncodeLookup[(inputBuffer[i] & 0xFC) >> 2];
			outputBuffer[j++] = base64EncodeLookup[((inputBuffer[i] & 0x03) << 4)
                                                   | ((inputBuffer[i + 1] & 0xF0) >> 4)];
			outputBuffer[j++] = base64EncodeLookup[((inputBuffer[i + 1] & 0x0F) << 2)
                                                   | ((inputBuffer[i + 2] & 0xC0) >> 6)];
			outputBuffer[j++] = base64EncodeLookup[inputBuffer[i + 2] & 0x3F];
		}
		
		if (lineEnd == length)
		{
			break;
		}
		
		//
		// Add the newline
		//
		outputBuffer[j++] = '\r';
		outputBuffer[j++] = '\n';
		lineEnd += lineLength;
	}
	
	if (i + 1 < length)
	{
		//
		// Handle the single '=' case
		//
		outputBuffer[j++] = base64EncodeLookup[(inputBuffer[i] & 0xFC) >> 2];
		outputBuffer[j++] = base64EncodeLookup[((inputBuffer[i] & 0x03) << 4)
                                               | ((inputBuffer[i + 1] & 0xF0) >> 4)];
		outputBuffer[j++] = base64EncodeLookup[(inputBuffer[i + 1] & 0x0F) << 2];
		outputBuffer[j++] =	'=';
	}
	else if (i < length)
	{
		//
		// Handle the double '=' case
		//
		outputBuffer[j++] = base64EncodeLookup[(inputBuffer[i] & 0xFC) >> 2];
		outputBuffer[j++] = base64EncodeLookup[(inputBuffer[i] & 0x03) << 4];
		outputBuffer[j++] = '=';
		outputBuffer[j++] = '=';
	}
	outputBuffer[j] = 0;
	
	//
	// Set the output length and return the buffer
	//
	if (outputLength)
	{
		*outputLength = j;
	}
	return outputBuffer;
}


//
// base64EncodedString
//
// Creates an NSString object that contains the base 64 encoding of the
// receiver's data. Lines are broken at 64 characters long.
//
// returns an autoreleased NSString being the base 64 representation of the
//	receiver.
//
+ (NSString *)_base64EncodedString :(NSData *) data
{
	if( !data )
        return [NSString string];
    
    size_t outputLength = 0;
	char *outputBuffer  = _NewBase64Encode([data bytes], [data length], true, &outputLength);
	
	NSString *result =  [[NSString alloc] initWithBytes: outputBuffer
                                                 length: outputLength
                                               encoding: NSASCIIStringEncoding];
	free(outputBuffer);
	return result;
}

//  Created by Matt Gallagher on 2009/06/03.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//  End


+ (NSString *)hexadecimalString:(NSData *)data
{
	const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    
	if (!dataBuffer)
	{
		return [NSString string];
	}
    
	NSUInteger dataLength  = [data length];
	NSMutableString *hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
	for (int i = 0; i < dataLength; ++i)
	{
		[hexString appendString:[NSString stringWithFormat:@"%02x", (unsigned int)dataBuffer[i]]];
	}
    
	return [NSString stringWithString:hexString];
}

+ (NSData *)encodeToBase64:(NSData *)blob
{
	NSData *encodedBlob = [[NSData alloc] init];
    
	if (!blob)
	{
		return encodedBlob;
	}
    
	NSString *cfsData = [BuddyUtility _base64EncodedString:blob];
    encodedBlob = [NSData dataWithBytes:[cfsData UTF8String] length:[cfsData length]];
    
	return encodedBlob;
}

+ (NSString *)encodeBlob:(NSData *)blob
{
	if (!blob)
	{
		return @"";
	}
    
	NSString *cfsData = [BuddyUtility _base64EncodedString:blob];
    
	// Escape even the "reserved" characters for URLs
	// as defined in http://www.ietf.org/rfc/rfc2396.txt
	NSString *encodedValue = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,                                                                                     (__bridge CFStringRef)cfsData, NULL, (CFStringRef)@"();/!?:@&=+$,", kCFStringEncodingUTF8);
    
	return encodedValue;
}

+ (NSMutableString *)setParams:(NSString *)apiName appName:(NSString *)appName appPassword:(NSString *)appPassword
{
	NSMutableString *params = [[NSMutableString alloc] init];
    
	[params appendFormat:@"?%@&BuddyApplicationName=%@&BuddyApplicationPassword=%@", apiName, [self encodeValue:appName], [self encodeValue:appPassword]];
    
	return params;
}

+ (NSMutableDictionary*)buildCallParams:(NSString *)appName appPassword:(NSString *)appPassword callParams:(NSDictionary*)callParams {
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                    appName, @"BuddyApplicationName",
                    appPassword, @"BuddyApplicationPassword",
                    nil];
    
    // merge in other params
    if (callParams != nil) {
        [params addEntriesFromDictionary:callParams];
    }
    return params;
}




+ ( NSMutableString *)setParams:(NSString *)apiName appName:(NSString *)appName appPassword:(NSString *)appPassword userToken:(NSString *)userToken
{
	NSMutableString *params = [[NSMutableString alloc] init];
    
	[params appendFormat:@"?%@&BuddyApplicationName=%@&BuddyApplicationPassword=%@&UserToken=%@", apiName, [self encodeValue:appName], [self encodeValue:appPassword], [self encodeValue:userToken]];
    
	return params;
}

+ (NSString *)encodeValue:(NSString *)rawValue
{
	if (rawValue == nil || rawValue == (NSString *)[NSNull null])
	{
		rawValue = @"";
	}
    
	return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)rawValue, NULL, (CFStringRef)@"();/?!:@&=+$,", kCFStringEncodingUTF8);
}

+ (NSString *)UserGenderToString:(UserGender)userGender
{
	NSString *res;
    
	switch (userGender)
	{
		case UserGender_Male : res = @"Male"; break;
		case UserGender_Female : res = @"Female"; break;
		case UserGender_Any : res = @"Any"; break;
	}
    
	return res;
}

+ (int)UserStatusToInteger:(UserStatus)userStatus
{
	int enumValue;
    
	switch (userStatus)
	{
		case UserStatus_Single : enumValue = 1; break;
		case UserStatus_Dating : enumValue = 2; break;
		case UserStatus_Engaged : enumValue = 3; break;
		case UserStatus_Married : enumValue = 4; break;
		case UserStatus_Divorced : enumValue = 5; break;
		case UserStatus_Widowed : enumValue = 6; break;
		case UserStatus_OnTheProwl : enumValue = 7; break;
		case UserStatus_AnyUserStatus : enumValue = -1; break;
	}
    
	return enumValue;
}

+ (UserGender)stringToUserGender:(NSString *)userGender
{
	if ([BuddyUtility isNilOrEmpty:userGender])
	{
		return UserGender_Any;
	}
    
	if ([userGender isEqualToString:@"Male"] || [userGender isEqualToString:@"male"])
	{
		return UserGender_Male;
	}
    
	if ([userGender isEqualToString:@"Female"] || [userGender isEqualToString:@"female"])
	{
		return UserGender_Female;
	}
    
	return UserGender_Any;
}

+ (UserStatus)stringToUserStatus:(NSString *)userStatus
{
	if (userStatus == nil || [userStatus isEqualToString:@""] || [userStatus isEqualToString:@"-1"])
	{
		return UserStatus_AnyUserStatus;
	}
    
	if ([userStatus isEqualToString:@"1"])
	{
		return UserStatus_Single;
	}
    
	if ([userStatus isEqualToString:@"4"])
	{
		return UserStatus_Married;
	}
    
	if ([userStatus isEqualToString:@"2"])
	{
		return UserStatus_Dating;
	}
    
	if ([userStatus isEqualToString:@"3"])
	{
		return UserStatus_Engaged;
	}
    
	if ([userStatus isEqualToString:@"5"])
	{
		return UserStatus_Divorced;
	}
    
	if ([userStatus isEqualToString:@"6"])
	{
		return UserStatus_Widowed;
	}
    
	if ([userStatus isEqualToString:@"7"])
	{
		return UserStatus_OnTheProwl;
	}
    
	return UserStatus_AnyUserStatus;
}

static NSArray *validErrors;

+ (NSException *)processStandardErrors:(NSString *)result name:(NSString *)name
{
	if (validErrors == nil)
	{
		validErrors = [NSArray arrayWithObjects:@"WrongSocketLoginOrPass", @"SecurityTokenInvalidPleaseRenew", @"SecurityTokenRenewed", @"SecurityTokenCouldNotBeRenewed", @"SecurityFailedBannedDeviceID",
					   @"SecurityFailedBadUserNameOrPassword", @"SecurityFailedBadUserName", @"SecurityFailedBadUserPassword", @"DeviceIDAlreadyInSystem", @"UserNameAlreadyInUse",
					   @"UserNameAvailble", @"UserAccountNotFound", @"UserInvalidAccountSetting", @"UserAccountErrorSettingMetaValue", @"UserErrorUpdatingAccount", @"UserEmailTaken",
					   @"UserEmailAvailable", @"UserProfileIDEmpty", @"IdentityValueEmpty", @"DeviceIDNotFound", @"DateTimeFormatWasIncorrect", @"LatLongFormatWasIncorrect",
					   @"GeoLocationCategoryIncorrect", @"BadGeoLocationName", @"GeoLocationIDIncorrect", @"BadParameter", @"PhotoUploadGenericError", @"CouldNotFindPhotoTodelete",
					   @"CouldNotDeleteFileGenericError", @"PhotoAlbumDoesNotExist", @"AlbumNamesCannotBeBlank", @"PhotoIDDoesNotExistInContext", @"dupelocation", @"invalidflagreason",
					   @"EmptyDeviceURI", @"EmptyGroupName", @"EmptyImageURI", @"EmptyMessageCount", @"EmptyMessageTitle", @"EmptyRawMessage", @"EmptyToastTitle", @"EmptyToastSubTitle",
					   @"EmptyToastParameter", @"GroupNameCannotBeEmpty", @"GroupSecurityCanOnlyBy0or1", @"GroupAlreadyExists", @"GroupChatIDEmpty", @"GroupChatNotFound", @"GroupOwnerSecurityError",
					   @"ApplicationAPICallDisabledByDeveloper",
					   @"InvalidApplicationAndUserToken",
					   @"CouldNotUpdateInformation",
					   @"HTTP 400 Response",
					   @"GenericFilterApplicationIssue",
					   @"CouldNotfindFilteredPhoto",@"iOsReceiptSandboxSettingInvalid",@"FileLargerThanMaxSize",@"AccessTokenInvalid", @"PasswordResetCodeInvalid", @"NoEmailSetForUser", @"PasswordResetEmailNotConfigured",
                       @"BlobDoesNotExist",@"VideoDoesNotExist",@"Object reference not set to an instance of an object.", // TODO: remove when VideoDoesNotExist is implemented
					   nil];
	}
    
	if (result != nil && [result isKindOfClass:[NSString class]])
	{
		if ([validErrors containsObject:result])
		{
			NSString *reason = [name stringByAppendingFormat:@": %@", result];
			return [NSException exceptionWithName:kBuddyServiceException reason:reason userInfo:nil];
		}
        
		if ([result isEqualToString:@"-1"])
		{
			return [NSException exceptionWithName:kBuddyServiceException reason:@"Server returned -1." userInfo:nil];
		}
        
		NSString *reason = [name stringByAppendingFormat:@": %@", result];
		return [NSException exceptionWithName:kBuddyUnknownErrorException reason:reason userInfo:nil];
	}
    
	NSString *reason = [name stringByAppendingFormat:@": Unknown."];
	return [NSException exceptionWithName:kBuddyUnknownErrorException reason:reason userInfo:nil];
}

+ (BOOL)isAStandardError:(NSString *)result
{
	if (validErrors == nil)
	{
		[BuddyUtility processStandardErrors:@"" name:@""];
	}
    
	if ([validErrors containsObject:result])
	{
		return TRUE;
	}
    
	if ([result isEqualToString:@"-1"])
	{
		return TRUE;
	}
    
	return FALSE;
}

+ (NSString *)stringFromString:(NSString *)string;
{
	if (string == nil)
	{
		return @"";
	}
    
	return string;
}

static NSDateFormatter *stringDateFormatter;

+ (NSDate *)defaultAfterDate
{
	NSString *date = @"01-Jan-50";
    
	if (stringDateFormatter == nil)
	{
		stringDateFormatter = [[NSDateFormatter alloc] init];
		stringDateFormatter.dateFormat = @"dd-MMM-yy";
	}
    
	NSDate *dd = [stringDateFormatter dateFromString:date];
    
	return dd;
}

static NSDateFormatter *dateFormatter;

+ (NSDate *)dateFromString:(NSString *)dateString
{
	if (dateString != nil && [dateString length] > 0)
	{
		@try
		{   // "2012-11-14T10:17:12.0000000-08:00" - date in this format
			NSString *s1;
			NSArray *listItems = [dateString componentsSeparatedByString:@"."];
			if ([listItems count] == 2)
			{
				s1 = [listItems objectAtIndex:0];
                
				NSString *s2 = [listItems objectAtIndex:1];
                
				s2 = [s2 stringByReplacingOccurrencesOfString:@"0000000-"
												   withString:@"-"];
                
				s2 = [s2 stringByReplacingOccurrencesOfString:@":"
												   withString:@""];
                
				s1 = [s1 stringByAppendingString:s2];
			}
            
			if (dateFormatter == nil)
			{
				NSLocale *enUSPOSIXLocale;
                
				dateFormatter = [[NSDateFormatter alloc] init];
                
				enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                
				[dateFormatter setLocale:enUSPOSIXLocale];
                
				[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
                
				[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
			}
            
			NSDate *date = [dateFormatter dateFromString:s1];
			if (date == nil)
			{
				s1 = [listItems objectAtIndex:0];
                
				date = [dateFormatter dateFromString:s1];
			}
            
			if (date != nil)
			{
				return date;
			}
		}
		@catch (NSException *ex) {}
	}
    
    return [BuddyUtility buddyDate:dateString];
}

+ (double)doubleFromString:(NSString *)string
{
	return [string doubleValue];
}

+ (NSNumber *)NSNumberFromStringInt:(NSString *)stringInt
{
	return [NSNumber numberWithInt:[stringInt intValue]];
}

+ (NSNumber *)NSNumberFromStringLong:(NSString *)stringLong
{
	return [NSNumber numberWithLongLong:[stringLong longLongValue]];
}

+ (int)intFromString:(NSString *)string
{
	return [string intValue];
}

+ (long long)longFromString:(NSString *)string
{
    return [string longLongValue];
}

+ (BOOL)boolFromString:(NSString *)string
{
	if ([string isEqualToString:@"1"])
	{
		return TRUE;
	}
            
	if ([string isEqualToString:@"True"])
	{
		return TRUE;
	}

	return FALSE;
}

static NSDateFormatter *buddyDateFormatter;

+ (NSDate *)buddyDate:(NSString *)dateString
{
	[BuddyUtility dateFormat];
	NSDate *date = [buddyDateFormatter dateFromString:dateString];
	return date;
}

+ (NSString *)buddyDateToString:(NSDate *)date
{
	[BuddyUtility dateFormat];
    NSString *dateString = [buddyDateFormatter stringFromDate:date];
	return dateString;
}

+ (void)dateFormat
{
	if (buddyDateFormatter == nil)
	{
		buddyDateFormatter = [[NSDateFormatter alloc] init];
		[buddyDateFormatter setAMSymbol:@"AM"];
		[buddyDateFormatter setPMSymbol:@"PM"];
		[buddyDateFormatter setDateFormat:@"M/d/yyyy h:mm:ss a"];
	}
}

+ (BuddyCallbackParams *)buildBuddyFailure:(NSString *)name reason:(NSString *)reason 
{
	NSString *tempReason = [name stringByAppendingFormat:@": %@", reason];
    
	NSException *exception = [NSException exceptionWithName:kBuddyUnknownErrorException reason:tempReason userInfo:nil];
    
	BuddyCallbackParams *callbackParams = [[BuddyCallbackParams alloc] initWithError:exception  apiCall:name];
    
	return callbackParams;
}

+ (BuddyCallbackParams *)buildBuddyServiceError:(NSString *)name reason:(NSString *)reason 
{
	NSString *tempReason = [name stringByAppendingFormat:@": %@", reason];
    
	NSException *exception = [NSException exceptionWithName:kBuddyServiceException reason:tempReason userInfo:nil];
    
	BuddyCallbackParams *callbackParams = [[BuddyCallbackParams alloc] initWithError:exception  apiCall:name];
    
	return callbackParams;
}


+ (BuddyCallbackParams *)buildBuddyError:(NSString *)name reason:(NSString *)reason 
{
	NSException *exception = [BuddyUtility processStandardErrors:reason name:name];
    
	BuddyCallbackParams *callbackParams = [[BuddyCallbackParams alloc] initWithError:exception  apiCall:name];
    
	return callbackParams;
}

+ (NSException *)buildBuddyServiceException:(NSString *)reason
{
	return [NSException exceptionWithName:kBuddyServiceException reason:reason userInfo:nil];
}

+ (NSException *)buildBuddyUnknownErrorException:(NSString *)reason
{
    return [NSException exceptionWithName:kBuddyUnknownErrorException reason:reason userInfo:nil];
}

+ (BOOL)isNilOrEmpty:(NSString *)data
{
	if (data == nil || [data length] == 0)
	{
		return TRUE;
	}
    
	if ([[data stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0)
	{
		return TRUE;
	}
    
	return FALSE;
}

+ (void)latLongCheck:(double)latitude longitude:(double)longitude className:(NSString *)name
{
	if (latitude > 90.0 || latitude < -90.0)
	{
		[NSException raise:NSInvalidArgumentException format:@"%@: latitude can't be bigger than 90.0 or smaller than -90.0.", name];
	}
    
	if (longitude > 180.0 || longitude < -180.0)
	{
		[NSException raise:NSInvalidArgumentException format:@"%@: longitude can't be bigger than 180.0 or smaller than -180.0.", name];
	}
}

+ (NSException *)makeInvalidArgException:(NSString *)reason
{
	return [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
}

+ (void)throwInvalidArgException:(NSString *)name reason:(NSString *)reason
{
	[NSException raise:NSInvalidArgumentException format:@"%@: %@", name, reason];
}

+ (void)throwNilArgException:(NSString *)name reason:(NSString *)reason
{
	[NSException raise:NSInvalidArgumentException format:@"%@: %@ can't be nil or empty.", name, reason];
}

+ (void)checkForNilClientAndUser:(id)client user:user name:(NSString *)name
{
	[BuddyUtility checkForNilClient:client name:name];
	[BuddyUtility checkForNilUser:user name:name];
}

+ (void)checkForNilClient:(id)client name:(NSString *)name
{
	if (client == nil)
	{
		[NSException raise:NSInvalidArgumentException format:@"%@: client can't be nil or empty", name];
	}
}

+ (void)checkForNilUser:(id)user name:(NSString *)name
{
	if (user == nil)
	{
		[NSException raise:NSInvalidArgumentException format:@"%@: user can't be nil or empty", name];
	}
}

+ (void)checkNameParam:(NSString *)name functionName:(NSString *)functionName
{
	if ([BuddyUtility isNilOrEmpty:name])
	{
		[NSException raise:NSInvalidArgumentException format:@"%@ name can't be nil or empty", functionName];
	}
}

+ (void)checkBlobParam:(NSData *)blob functionName:(NSString *)functionName
{
	if (blob == nil || [blob length] == 0)
	{
		[NSException raise:NSInvalidArgumentException format:@"%@: blob can't be nil or empty.", functionName];
	}
}

+ (void)checkRecordLimitParam:(NSNumber *)recordLimit functionName:(NSString *)functionName
{
	if (recordLimit == nil || [recordLimit intValue] <= 0)
	{
		[NSException raise:NSInvalidArgumentException format:@"%@: recordLimit can't be nil or smaller or equal to 0.", functionName];
	}
}

+ (void)checkForToken:(NSString *)token functionName:(NSString *)functionName
{
	if ([BuddyUtility isNilOrEmpty:token])
	{
		[NSException raise:NSInvalidArgumentException format:@"%@: token can't be nil or empty.", functionName];
	}
}

+ (NSException *)makeException:(NSString *)apiCall errorString:(NSString *)error
{
	NSString *errorName = (apiCall == nil) ? @"Unknown" : apiCall;
    
	NSException *exception = [BuddyUtility processStandardErrors:error name:errorName];
    
	return exception;
}

+ (NSString *)osVersion
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED
	return [[UIDevice currentDevice] systemVersion];
#else
    NSString *versionString;
    NSDictionary *sv = [NSDictionary dictionaryWithContentsOfFile:@"/System/Library/CoreServices/SystemVersion.plist"];
    versionString = [sv objectForKey:@"ProductVersion"];
    return versionString;
#endif
}

+ (NSString *)appVersion
{
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}

+ (NSString *)getDeviceModel
{
	size_t size;
    
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    
	char *model = malloc(size);
    
	sysctlbyname("hw.machine", model, &size, NULL, 0);
    
	NSString *deviceModel = [NSString stringWithCString:model encoding:NSUTF8StringEncoding];
    
	free(model);
    
	return deviceModel;
}

+ (NSString *)deviceName
{
	return [self getDeviceModel];
}

@end