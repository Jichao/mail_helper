/* How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include <substrate.h>, it will be done automatically, as will
the generation of a class list and an automatic constructor.*/

#import "FilterViewController.h"
#import "FilterStore.h"

%hook MailboxContentViewController

// Hooking an instance method with an argument.
// static NSString* const kTag = @"mailhelper: %@";
static NSString* const kBundlePath =
@"/Library/MobileSubstrate/DynamicLibraries/mailhelper_res.bundle";
static UIBarButtonItem* filterButton;
%new
- (void)myMarkAll
{
	if ([FilterStore sharedStore].filters.count == 0) {
		return;
	}
	id mall = [(id)self performSelector:@selector(mall)];
	NSArray* malls = [mall performSelector:@selector(_copyMalls)];
	for (id miniMall in malls) {
		NSUInteger count = (NSUInteger)[miniMall performSelector:@selector(messageCount)];
		NSArray* messageInfos = [miniMall performSelector:@selector(_copyAllMessageInfos)];
		for (unsigned int i = 0; i < count; ++i) {
			id msg = [miniMall performSelector:@selector(_messageForMessageInfo:cache:)
			withObject:messageInfos[i] withObject:[NSNumber numberWithBool:NO]];
			Ivar var = class_getInstanceVariable(object_getClass(msg),"_sender");
			NSArray* senders = object_getIvar(msg, var);
			for (NSString* sender in senders) {
				for (NSString* addr in [FilterStore sharedStore].filters) {
					NSRange range = [sender rangeOfString: addr];
					if (range.location != NSNotFound) {
						[msg performSelector:@selector(markAsViewed)];
						goto done;
					}
				}
			}
		}
	}
done:
	return;
}

- (void)updateBarButtons
{
	%orig;
	if (!filterButton) {
		NSBundle *bundle = [[NSBundle alloc] initWithPath:kBundlePath];
		NSString *imagePath = [bundle pathForResource:@"filter" ofType:@"png"];
		UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
		filterButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain
		target:self action:@selector(showFilters:)];
		[bundle release];
	}
	Ivar var = class_getInstanceVariable(object_getClass((id)self), "_defaultToolbarItems");
	NSArray* oldButtonItems = object_getIvar((id)self, var);
	if ([oldButtonItems count]) {
		if (oldButtonItems[0] != filterButton) {
			NSMutableArray* newButtonItems = [oldButtonItems mutableCopy];
			[newButtonItems insertObject:filterButton atIndex:0];
			object_setIvar((id)self, var, newButtonItems);
			[(UIViewController*)self setToolbarItems:newButtonItems animated: NO];
		}
	}
}

%new
- (void)showFilters:(id)sender
{
	FilterViewController* controller = [[FilterViewController alloc] init];
	[[(UIViewController*)self navigationController] pushViewController:controller
	animated: NO];
}

// - (void)viewDidAppear
// {
// 	// [(id)self performSelector:@selector(addFilterUI)];
// 	%orig;
// 	// [(id)self performSelector:@selector(myMarkAll)];
// }

- (id)tableView:(id)tableView cellForRowAtIndexPath:(id)indexPath
{
	// %log;
	id cell = %orig; // Call through to the original function with its original arguments.
	if (!cell) {
		//NSLog(kTag, @"cell empty");
		return cell;
	}
	if ([FilterStore sharedStore].filters.count == 0) {
		return cell;
	}
	if (![cell respondsToSelector:@selector(message)]) {
		//NSLog(kTag, @"cell does not respon to message");
		return cell;
	}
	//NSLog(kTag, @"cell does respon to message");

	id msg = [cell performSelector:@selector(message)];
	if (!msg) {
		//NSLog(kTag, @"could not get the message");
		return cell;
	}
	//NSLog(kTag, @"does get the message");

	Ivar var = class_getInstanceVariable(object_getClass(msg),"_sender");
	if (!var) {
		//NSLog(kTag, @"could not get the sender ivar");
		return cell;
	}
	//NSLog(kTag, @"could get the sender ivar");
	NSArray* senders = object_getIvar(msg, var);
	if (!senders) {
		//NSLog(kTag, @"could not get the sender value");
		return cell;
	}
	//NSLog(kTag, @"could get the sender value");
	for (NSString* sender in senders) {
		for (NSString* addr in [FilterStore sharedStore].filters) {
			NSRange range = [sender rangeOfString: addr];
			if (range.location != NSNotFound) {
				[msg performSelector:@selector(markAsViewed)];
				goto done;
			}
		}
	}
done:
	return cell;
}

// Always make sure you clean up after yourself; Not doing so could have grave consequences!
%end
