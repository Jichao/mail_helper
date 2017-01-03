#import "FilterViewController.h"
#import "FilterStore.h"
#import "Masonry/Masonry.h"

static NSString* const kCellId = @"FitlerViewCell";
static NSString* const kBundlePath =
@"/Library/MobileSubstrate/DynamicLibraries/mailhelper_res.bundle";

@interface FilterViewController()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) UITableView* tableView;
@end

@implementation FilterViewController

- (instancetype)init
{
    if (self = [super init]) {

    }
    return self;
}

- (void)dealloc
{
    [[FilterStore sharedStore] save];
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.tableView = [[UITableView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(self.view);
    }];

    NSBundle *bundle = [[NSBundle alloc] initWithPath:kBundlePath];
    NSString *imagePath = [bundle pathForResource:@"add" ofType:@"png"];
    UIImage *myImage = [UIImage imageWithContentsOfFile:imagePath];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:myImage style:UIBarButtonItemStylePlain
    target:self action:@selector(addFilter:)];
    [self setToolbarItems:[NSArray arrayWithObject:buttonItem] animated: NO];
    self.title = @"Email filters";
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)addFilter:(id)sender
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Add filter" message:@"Please enter your email:"
    delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeEmailAddress;
    alertTextField.placeholder = @"email address";
    [alert show];
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
   BOOL stricterFilter = NO;
   NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
   NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
   NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
   NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
   return [emailTest evaluateWithObject:checkString];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField * textField = [alertView textFieldAtIndex:0];
    NSLog(@"mailhelper: email : %@, buttonIndex: %d", textField.text, (int)buttonIndex);
    if ([textField.text length] <= 0 || buttonIndex == 0) {
        return;
    }
    NSString* email = [textField.text copy];
    email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"mailhelper: trimed email : %@,", email);
    if (![email length] || ![self NSStringIsValidEmail:email]) {
        return;
    }
    if (buttonIndex == 1) {
        [[FilterStore sharedStore].filters addObject:email];
        NSLog(@"mailhelper: trimed email : %@,", email);
        [_tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (tableView == self.tableView) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: kCellId];
        }
        cell.textLabel.text = [FilterStore sharedStore].filters[[indexPath row]];
        NSLog(@"mailhelper get cell for row %d cell %p", (int)[indexPath row], cell);
        return cell;
    }
    return NULL;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"mailhelper: count = %d", (int)[FilterStore sharedStore].filters.count);
    return  [FilterStore sharedStore].filters.count;
}

#pragma mark - UITableViewDelegate
// for ios8+
// - (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
// {
//     UITableViewRowAction* deleteAction = [UITableViewRowAction rowActionWithStyle: UITableViewRowActionStyleDefault
//     title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
//         [[FilterStore sharedStore].filters removeObjectAtIndex:indexPath.row];
//     }];
//     return @[deleteAction];
// }

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[FilterStore sharedStore].filters removeObjectAtIndex:indexPath.row];
        [_tableView reloadData];
    }
}
@end
