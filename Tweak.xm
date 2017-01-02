/* How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include <substrate.h>, it will be done automatically, as will
the generation of a class list and an automatic constructor.*/

%hook MailboxContentViewController

// Hooking an instance method with an argument.

- (id)tableView:(id)tableView cellForRowAtIndexPath:(id)indexPath
{
	id cell = %orig; // Call through to the original function with its original arguments.
	id msg = [cell performSelector:@selector(message)];
	if (!msg) {
		return cell;
	}

	Ivar var = class_getInstanceVariable(object_getClass(msg),"_sender");
	if (!var) {
		return cell;
	}
	NSString* sender = object_getIvar(msg, var);
	if (!sender) {
		return cell;
	}

	if ([sender containsString: @"jcyangzh@foxmail.com"]) {
		[msg performSelector:@selector(markAsViewed)];
	}
	return cell;
}

// Always make sure you clean up after yourself; Not doing so could have grave consequences!
%end
