//
//  main.m
//  example-objc-CLI-minimum
//
//  Created by dev on 2023-01-30.
//

#import <Foundation/Foundation.h>

#import "IPSME_MsgEnv.h"

bool ipsme_handler_NSString_(id id_msg, NSString* nsstr_msg)
{
	NSLog(@"ipsme_handler_NSString_: \"%@\"", nsstr_msg);

	if ([nsstr_msg isEqual:@"Discovery"]) {
		[IPSME_MsgEnv publish:@"Announcement!"];
		return true;
	}
	
	return false;
}

void ipsme_handler_(id id_msg, NSString*)
{
	NSLog(@"ipsme_handler_: [%@]", [id_msg class]);

	@try {
		if ([id_msg isKindOfClass:[NSString class]] && ipsme_handler_NSString_(id_msg, id_msg))
			return;
	}
	@catch (id ue) {
		if ([ue isKindOfClass:[NSException class]]) {
			NSException* e= ue;
			NSLog(@"ERR: error is message execution: %@", [e reason]);
		}
		else
			NSLog(@"ERR: error is message execution");
		
		return;
	}
	
	NSLog(@"handler_: DROP! %@", [id_msg class]);
}

int main(int argc, const char * argv[])
{
	@autoreleasepool
	{
		NSLog(@"main: Running ...");
		
		[IPSME_MsgEnv subscribe:ipsme_handler_];

		while (true)
		{
			[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
			
			// ...
		}
		
	}
	return 0;
}

