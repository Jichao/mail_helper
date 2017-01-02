/* How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include <substrate.h>, it will be done automatically, as will
the generation of a class list and an automatic constructor.*/

%hook MailboxContentViewController

// Hooking an instance method with an argument.
static NSString* const kTag = @"mailhelper: %@";

// - (void)viewDidLoad
// {
// 	%log;
// 	id mall = [(id)self performSelector:@selector(mall)];
// 	NSArray* malls = [mall performSelector:@selector(_copyMalls)];
// 	NSLog(@"mailhelper malls: %@", malls);
// 	for (id miniMall in malls) {
// 		NSUInteger count = (NSUInteger)[miniMall performSelector:@selector(messageCount)];
// 		NSArray* messageInfos = [miniMall performSelector:@selector(_copyAllMessageInfos)];
// 		for (unsigned int i = 0; i < count; ++i) {
// 			id msg = [miniMall performSelector:@selector(_messageForMessageInfo:cache:)
// 			withObject:messageInfos[i] withObject:[NSNumber numberWithBool:NO]];
// 			Ivar var = class_getInstanceVariable(object_getClass(msg),"_sender");
// 			NSArray* senders = object_getIvar(msg, var);
// 			for (NSString* sender in senders) {
// 				NSRange range =  [sender rangeOfString: @"jcyangzh@foxmail.com"];
// 				if (range.location != NSNotFound) {
// 					NSLog(@"mailhelper msg %p markAsViewed", msg);
// 					[msg performSelector:@selector(markAsViewed)];
// 					break;
// 				}
// 			}
// 		}
// 	}
// }

- (id)tableView:(id)tableView cellForRowAtIndexPath:(id)indexPath
{
	%log;
	NSLog(kTag, @"kekekekek");
	id cell = %orig; // Call through to the original function with its original arguments.
	if (!cell) {
		NSLog(kTag, @"cell empty");
		return cell;
	}
	if (![cell respondsToSelector:@selector(message)]) {
		NSLog(kTag, @"cell does not respon to message");
		return cell;
	}
	NSLog(kTag, @"cell does respon to message");

	id msg = [cell performSelector:@selector(message)];
	if (!msg) {
		NSLog(kTag, @"could not get the message");
		return cell;
	}
	NSLog(kTag, @"does get the message");

	Ivar var = class_getInstanceVariable(object_getClass(msg),"_sender");
	if (!var) {
		NSLog(kTag, @"could not get the sender ivar");
		return cell;
	}
	NSLog(kTag, @"could get the sender ivar");
	NSArray* senders = object_getIvar(msg, var);
	if (!senders) {
		NSLog(kTag, @"could not get the sender value");
		return cell;
	}
	NSLog(kTag, @"could get the sender value");
	for (NSString* sender in senders) {
		NSRange range =  [sender rangeOfString: @"jcyangzh@foxmail.com"];
		NSLog(@"mailhelper: range ( %d, %d) notfound %d", (int)range.location, (int)range.length, (int)NSNotFound);
		if (range.location != NSNotFound) {
			[msg performSelector:@selector(markAsViewed)];
			NSLog(kTag, @"matched the keke");
			break;
		}
	}
	return cell;
}

// Always make sure you clean up after yourself; Not doing so could have grave consequences!
%end
