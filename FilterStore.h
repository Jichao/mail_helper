#import <Foundation/Foundation.h>

@interface FilterStore: NSObject
+ (instancetype)sharedStore;
- (void)load;
- (void)save;
@property (nonatomic, strong)NSMutableArray* filters;
@end
