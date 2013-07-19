//
//  BuddyFile.m
//  BuddySDK
//
//  Created by Shawn Burke on 5/22/13.
//
//

#import "BuddyFile.h"
#if __IPHONE_OS_VERSION_MIN_REQUIRED
#import <UIKit/UIImage.h>
#else
#import <AppKit/NSImage.h>
#endif

@implementation BuddyFile
@synthesize contentType;
@synthesize fileName;
@synthesize data;

-(id)init {
    return self;
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED
-(id) initWithImage:(UIImage *)image {
    
    self.fileName = @"image";
    self.data = UIImageJPEGRepresentation(image, 1.0);
    self.contentType = @"image/jpeg";
    
    return self;
}
#else
-(id) initWithImage:(NSImage *)image {
    
    self.fileName = @"image";
    NSArray *representations = [image representations];
    self.data = [NSBitmapImageRep representationOfImageRepsInArray:representations usingType:NSJPEGFileType properties:nil];
    self.contentType = @"image/jpeg";
    
    return self;
}
#endif

-(id)initWithData:(NSData *)d contentType:(NSString *)ct fileName:(NSString*)fn {
    
    self.contentType = ct;
    self.data = d;
    self.fileName = fn;
    return self;
}

@end
