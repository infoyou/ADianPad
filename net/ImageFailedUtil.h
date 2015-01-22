
#import <Foundation/Foundation.h>

#define IF_Util [ImageFailedUtil sharedImageFailedUtil]

@interface ImageFailedUtil : NSObject

+ (ImageFailedUtil*)sharedImageFailedUtil;

- (BOOL) isFailedDirectoryThere;
- (NSString*) imageFailedDataFilePath;
- (int) addImageFailedToImageDirectory:(UIImage*) image uuid:(NSString*)uuid;
- (BOOL) deleteImageFailedFromImageDirectoryByName:(NSString*) imageName;
- (NSArray*) listOfFailedDirectoryContents;
- (NSData*) getFailedImageAsDataFromImageDirectory:(NSString*) whichImage;

@end
