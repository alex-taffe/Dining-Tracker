//
//  AboutViewController.m
//  Dining Tracker
//
//  Created by Alex Taffe on 9/29/17.
//  Copyright © 2017 Alex Taffe. All rights reserved.
//

@import SafariServices;
#import "AboutViewController.h"

@interface AboutViewController ()
@property (strong, nonatomic) UIColor *currentStatusBarColor;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) BOOL swapped;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.95 green:0.43 blue:0.13 alpha:1.00];
    self.navigationController.navigationBar.tintColor = UIColor.whiteColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.whiteColor};
    self.titleLabel.text = [[NSString alloc] initWithFormat:@"%@ %@(%@)", self.titleLabel.text, [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"], [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    self.titleLabel.textColor = [UIColor colorWithRed:0.95 green:0.43 blue:0.13 alpha:1.00];
}

-(void)viewWillAppear:(BOOL)animated{
    if(!self.swapped){
        self.currentStatusBarColor = self.statusBar.backgroundColor;
        self.swapped = true;
    }
    [UIView animateWithDuration:0.4 animations:^{
        self.statusBar.backgroundColor = UIColor.clearColor;
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    if(self.swapped){
        [UIView animateWithDuration:0.4 animations:^{
        self.statusBar.backgroundColor = self.currentStatusBarColor;
        }];
        self.swapped = false;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)donePressed:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)openGitHub:(id)sender {
    SFSafariViewController *safari = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"https://github.com/alex-taffe/Dining-Tracker"]];
    [self presentViewController:safari animated:true completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
