#import "FilterViewController.h"

@interface FilterViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray* senders;
@end

@implementation FilterViewController

- (instancetype)init
{
  if (self = [super init]) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"filter.dat"];
    NSMutableArray *yourArray = [[NSMutableArray alloc] initWithContentsOfFile: filePath];
    if(yourArray == nil) {
        yourArray = [[NSMutableArray alloc] initWithCapacity:10];
    }
  }
  return self;
}

- (void)loadView
{
  self.view = [[UIView alloc] init];
  self.view.backgroundColor = [UIColor redColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
