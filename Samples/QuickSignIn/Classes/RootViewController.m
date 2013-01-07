#import "RootViewController.h"
#import "debug_log.h"

@interface RootViewController ()

@end

@implementation RootViewController
@synthesize jrChildNavController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    self.wantsFullScreenLayout = YES;
    [super setView:[[[UIView alloc] init] autorelease]];
    [super view].autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)shouldAutomaticallyForwardRotationMethods
{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    //return NO;
    BOOL b = [jrChildNavController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
    DLog("%d", b);
    return b;
}

- (BOOL)shouldAutorotate
{
    if ([jrChildNavController respondsToSelector:@selector(shouldAutorotate)])
        return [jrChildNavController shouldAutorotate];
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [jrChildNavController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [jrChildNavController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [jrChildNavController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view sizeToFit];
    [self.view setNeedsLayout];
    [jrChildNavController viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [jrChildNavController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [jrChildNavController viewDidDisappear:animated];
}

- (void)dealloc
{
    [jrChildNavController release];
    [super dealloc];
}

@end
