#import <Foundation/Foundation.h>

@interface FilterStore: NSObject
- (void)load;
- (void)save;
@property (nonatomic, strong)NSMutableArray* filters;
@end
