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

#import "TestBuddySDK.h"


@implementation TestBuddySDK

+ (NSArray *)GetTextFileData:(NSString *)filename
{
    NSError *error;
    NSString *sourcePath = [self GetSourcePath:filename extension:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:sourcePath];

    if (data == nil)
    {
        return nil;
    }

    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingAllowFragments error:&error];

    NSArray *resArray = [json objectForKey:@"data"];
    return resArray;
}

+ (NSData *)GetPicFileData:(NSString *)filename
{
    NSString *sourcePath = [self GetSourcePath:filename extension:@"png"];
    NSData *data = [NSData dataWithContentsOfFile:sourcePath];

    return data;
}

+ (NSString *)GetSourcePath:(NSString *)filename extension:(NSString *)extension
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED
    NSBundle *bundle = [NSBundle mainBundle];
#else
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
#endif
    return [bundle pathForResource:filename ofType:extension];
}
@end