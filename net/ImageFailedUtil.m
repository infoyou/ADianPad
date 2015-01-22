
#import "ImageFailedUtil.h"
#import "GDefine.h"

static ImageFailedUtil* _sharedImageFailedUtil = nil;

@implementation ImageFailedUtil

+(ImageFailedUtil*) sharedImageFailedUtil
{
	if(_sharedImageFailedUtil == nil)
    {
		_sharedImageFailedUtil = [[ImageFailedUtil alloc] init];
	}
	return _sharedImageFailedUtil;
}

-(BOOL) isFailedDirectoryThere
{
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	NSError * errorStruct;
	NSArray * dirContents = [fileMgr contentsOfDirectoryAtPath:[[ImageFailedUtil sharedImageFailedUtil] imageFailedDataFilePath] error:&errorStruct];
	if(dirContents)
		return YES;
	else 
		return NO;
}

-(NSString*) imageFailedDataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSString *imageDirectory = [documentsDirectory stringByAppendingPathComponent:@"imageFailedData"];
	return imageDirectory;
}

-(int) addImageFailedToImageDirectory:(UIImage *) image uuid:(NSString *)uuid
{
	
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	NSError * errorStruct;
	
	if(![[ImageFailedUtil sharedImageFailedUtil] isFailedDirectoryThere])
		[fileMgr createDirectoryAtPath:[[ImageFailedUtil sharedImageFailedUtil] imageFailedDataFilePath] 
		   withIntermediateDirectories:YES	
							attributes:nil
								 error:&errorStruct];
	NSData * imageJPEG = UIImageJPEGRepresentation(image, KJpgQuality);
    NSString* imgfile=[NSString stringWithFormat:@"%@/%@",[[ImageFailedUtil sharedImageFailedUtil] imageFailedDataFilePath],uuid];
	BOOL result = [imageJPEG writeToFile:imgfile atomically:YES];
	if(result)
		return 1;
	else {
		return 0;
	}
}

-(BOOL) deleteImageFailedFromImageDirectoryByName:(NSString *) imageName
{
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	NSError * errorStruct;
	NSString * filepath = [NSString stringWithFormat:@"%@/%@", 
						   [[ImageFailedUtil sharedImageFailedUtil] imageFailedDataFilePath], 
						   imageName];
	if([fileMgr removeItemAtPath:filepath error:&errorStruct])
		return YES;
	else 
		return NO;
}

-(NSArray*) listOfFailedDirectoryContents
{
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	NSError * errorStruct;
	return [fileMgr contentsOfDirectoryAtPath:[[ImageFailedUtil sharedImageFailedUtil] imageFailedDataFilePath] error:&errorStruct];	
}

-(NSData*) getFailedImageAsDataFromImageDirectory:(NSString *) whichImage
{
	NSString * filepath = [NSString stringWithFormat:@"%@/%@", 
						   [[ImageFailedUtil sharedImageFailedUtil] imageFailedDataFilePath], 
						   whichImage];
	return [NSData dataWithContentsOfFile:filepath];
}

@end
