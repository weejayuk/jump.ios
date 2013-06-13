#import "CaptureDynamicForm.h"
#import "AppDelegate.h"
#import "Utils.h"

static NSMutableDictionary *identifierMap = nil;

@interface CaptureDynamicForm ()
@property(nonatomic, strong) JRCaptureUser *captureUser;
@end

@implementation CaptureDynamicForm
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.captureUser = [JRCaptureUser captureUser];
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];

    //"email",
    //"displayName",
    //"firstName",
    //"lastName",
    //"password",
    //"password_confirm"
    [self addTitleLabel:@"Traditional Registration"];
    [self addTextFieldFormLabeled:@"Email" forAttrName:@"email"];
    [self addTextFieldFormLabeled:@"Display Name" forAttrName:@"displayName"];
    [self addTextFieldFormLabeled:@"First" forAttrName:@"givenName"];
    [self addTextFieldFormLabeled:@"Last" forAttrName:@"familyName"];
    [self addTextFieldFormLabeled:@"Password" forAttrName:@"password"];
    //[self addTextFieldFormLabeled:@"Confirm" forAttrName:@"password"];

    [self setupToolbar];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden = YES;
}

- (void)setupToolbar
{
    self.navigationController.toolbar.tintColor = [UIColor blackColor];
    self.navigationController.toolbarHidden = NO;
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                          target:self action:nil];
    UIBarButtonItem *registerUser = [[UIBarButtonItem alloc] initWithTitle:@"Register"
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self action:@selector(registerUser)];
    self.toolbarItems = @[flex, registerUser, flex];
}

- (void)registerUser
{
    [JRCapture registerNewUser:self.captureUser socialRegistrationToken:nil forDelegate:self];
}

- (void)registerUserDidSucceed:(JRCaptureUser *)registeredUser
{
    appDelegate.captureUser = registeredUser;
    [Utils handleSuccessWithTitle:@"Registration Complete" message:nil forVc:self];
}

- (void)registerUserDidFailWithError:(NSError *)error
{
    [error isJRMergeFlowError];
    if ([error isJRFormValidationError])
    {
        NSDictionary *invalidFieldLocalizedFailureMessages = [error JRValidationFailureMessages];
        [Utils handleFailureWithTitle:@"Invalid Form Submission"
                              message:[invalidFieldLocalizedFailureMessages description]];

    }
    else
    {
        [Utils handleFailureWithTitle:@"Registration Failed" message:[error localizedDescription]];
    }
}

- (void)addTitleLabel:(NSString *)titleText
{
    UIView *lastSubView = [self.view.subviews lastObject];
    UILabel *label = [self addLabelWithText:titleText toSuperView:self.view];
    NSDictionary *views = NSDictionaryOfVariableBindings(label);

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]-|"
                                                                      options:NSLayoutFormatAlignAllTop
                                                                      metrics:nil views:views]];
    [self appendViewToVerticalLayout:label lastSubView:lastSubView];
}

- (void)appendViewToVerticalLayout:(UIView *)v lastSubView:(UIView *)lastSubView
{
    NSDictionary *views = lastSubView ? NSDictionaryOfVariableBindings(v, lastSubView)
            : NSDictionaryOfVariableBindings(v);

    if (lastSubView)
    {
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lastSubView]-[v]"
                                                                          options:(NSLayoutFormatOptions) 0
                                                                          metrics:nil views:views]];
    }
    else
    {
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[v]"
                                                                          options:(NSLayoutFormatOptions) 0
                                                                          metrics:nil views:views]];
    }
}

- (UITextField *)addTextFieldWithSuperView:(UIView *)superview identifier:(NSString *)identifier
                                  hintText:(NSString *)hintText
{
    UITextField *textField = [[UITextField alloc] init];
    textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [textField setTranslatesAutoresizingMaskIntoConstraints:NO];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:15];
    textField.placeholder = @"enter text";
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = self;
    textField.placeholder = hintText;
    [superview addSubview:textField];
    textField.tag = [self intTagForIdentifier:identifier];
    return textField;
}

- (NSInteger)intTagForIdentifier:(NSString *)string
{
    static NSInteger index = 0;
    if (!identifierMap) identifierMap = [NSMutableDictionary dictionary];
    if ([identifierMap objectForKey:string]) return [[identifierMap objectForKey:string] integerValue];
    else [identifierMap setObject:[NSNumber numberWithInteger:index] forKey:string];
    return index++;
}

- (NSString *)identifierForIntTag:(NSInteger)i
{
    return [[identifierMap allKeysForObject:[NSNumber numberWithInteger:i]] lastObject];
}

- (void)addTextFieldFormLabeled:(NSString *)labelText forAttrName:(NSString *)attrName
{
    UIView *lastSubView = [self.view.subviews lastObject];
    UILabel *label = [self addLabelWithText:labelText toSuperView:self.view];
    UITextField *field = [self addTextFieldWithSuperView:self.view identifier:attrName hintText:labelText];

    NSDictionary *views = NSDictionaryOfVariableBindings(label, field);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label(100)]-[field]-|"
                                                                      options:NSLayoutFormatAlignAllBaseline
                                                                      metrics:nil views:views]];

    [self appendViewToVerticalLayout:field lastSubView:lastSubView];
}

- (UILabel *)addLabelWithText:(NSString *)labelText toSuperView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] init];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [view addSubview:label];
    label.text = labelText;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *identifier = [self identifierForIntTag:textField.tag];
    SEL setSel = NSSelectorFromString([NSString stringWithFormat:@"set%@:", upcaseFirst(identifier)]);
    [self.captureUser performSelector:setSel withObject:textField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

@end