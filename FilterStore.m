#import "FilterStore.h"

@implementation FilterStore
+ (instancetype)sharedStore
{
    static dispatch_once_t token;
    static FilterStore* sharedStore;
    dispatch_once(&token, ^{
        sharedStore = [[FilterStore alloc] init];
    });
    return sharedStore;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self load];
    }
    return self;
}

- (NSString*) getFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"filter.dat"];
    return filePath;
}

- (void)load
{
    _filters = [NSMutableArray arrayWithContentsOfFile: [self getFilePath]];
    if (!_filters) {
        _filters = [[NSMutableArray alloc] init];
    }
}

- (void)save
{
    [_filters writeToFile: [self getFilePath] atomically: YES];
}

@end
