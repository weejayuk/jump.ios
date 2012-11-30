//
//  NewViewController.m
//  QuickSignIn
//
//  Created by Nathan on 11/30/12.
//
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

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
    self.view = [[[UIView alloc] init] autorelease];
    self.view.autoresizingMask = 0-1;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view setNeedsLayout];
    [self.view sizeToFit];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
//    return [[[self childViewControllers]objectAtIndex:0] supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotate
{
    return YES;
//    return [[[self childViewControllers]objectAtIndex:0] shouldAutorotate];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
//    return [[[self childViewControllers]objectAtIndex:0] shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
//    for (UIViewController* cvc in self.childViewControllers)
//    {
//        [cvc willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
