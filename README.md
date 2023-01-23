
# example-objc-CLI-minimum

This is minimum example of using IPSME in a macOS native environment. This example will: 1) subscribe to IPSME messages with a callback handler `ipsme_handler_`; and, 2) publish a message to the messaging environment (ME) on a button click .

> ### IPSME- Idempotent Publish/Subscribe Messaging Environment
> https://dl.acm.org/doi/abs/10.1145/3458307.3460966

This example makes use of the following repository:
 - https://github.com/IPSME/objc-msgenv-NSDNC/tree/userInfo

## Subscribing to messages

The following code can be used to receive messages posted to the local ME.
```
void ipsme_handler_(id id_msg, NSString*)
{
	@try {
		// add handlers ...
		return;
	}
	@catch (id ue) {
		// ...		
		return;
	}
	
	NSLog(@"handler_: DROP! %@", [id_msg class]);
}
[IPSME_MsgEnv subscribe:ipsme_handler_];
```
It is important to catch all exceptions in the handler used to subscribe to IPSME; unhandled exceptions are silently dropped.
If reflectors are used, then we are oblivious to the routing complexities on how the message arrived in the local ME. It is **STRONGLY** recommended to use the strictest validation on messages and drop those that do not comply.

When receiving messages of various types, it can be helpful to cascade handlers.
```
bool ipsme_handler_Discovery_(id id_msg, ...)
{
	if (...)
		return true;
	return false;
}

bool ipsme_handler_NSString_(id id_msg, NSString* nsstr_msg)
{
	if ([nsstr_msg isEqual:@"Discovery"] && ipsme_handler_Discovery_(id_msg, ...)) 
		return true;	
	return false;
}

void ipsme_handler_(id id_msg, NSString*)
{
	@try {
		if ([id_msg isKindOfClass:[NSString class]] && ipsme_handler_NSString_(id_msg, id_msg))
			return;
	}
	@catch (id ue) {
		// ...		
		return;
	}
	
	NSLog(@"handler_: DROP! %@", [id_msg class]);
}

[IPSME_MsgEnv subscribe:ipsme_handler_];
```
The original message (`id_msg`) is passed along through the cascade, in case it is to be used in a reply.  Each handler returns a boolean allowing for the following return results:
-   return `true`: message was ACCEPTED, processing was a SUCCESS; stop processing the message further
-   `throw` an error: message was ACCEPTED, processing of the message FAILED; stop processing the message further
-   return `false`: message is NOT accepted; continue processing the message in other handlers

## Publishing a message

```
[IPSME_MsgEnv publish:@"Announcement!"];
```
It is by design that a participant receives the messages it has published itself. If this is not desirable, each message can contain a "referer" (sic) identifier and a clause added in the `ipsme_handler_` to drop those messages containing the participant's own referer id.


