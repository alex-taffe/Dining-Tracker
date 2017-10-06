//
//  AboutViewController.m
//  Dining Tracker
//
//  Created by Alex Taffe on 9/29/17.
//  Copyright © 2017 Alex Taffe. All rights reserved.
//

@import SafariServices;
#import "AboutViewController.h"

@interface AboutViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UIColor *currentStatusBarColor;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *githubLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDictionary<NSString *, NSString *> *openSourceLibraries;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstraint;
@property (strong, nonatomic) IBOutlet UILabel *copyrightLabel;
@property (nonatomic) BOOL swapped;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //set the navigation bar styling
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.95 green:0.43 blue:0.13 alpha:1.00];
    self.navigationController.navigationBar.tintColor = UIColor.whiteColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.whiteColor};
    
    //set the title label styling and add in the version info
    self.titleLabel.text = [[NSString alloc] initWithFormat:@"%@ %@(%@)", self.titleLabel.text, [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"], [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    self.titleLabel.textColor = [UIColor colorWithRed:0.95 green:0.43 blue:0.13 alpha:1.00];
    
    //style the github button color
    self.githubLabel.tintColor = [UIColor colorWithRed:0.95 green:0.43 blue:0.13 alpha:1.00];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //declare our open source libraries
    self.openSourceLibraries = @{
                                 @"CircleProgressBar": @"https://github.com/Eclair/CircleProgressBar",
                                 @"Crashlytics": @"https://fabric.io",
                                 @"CZPicker": @"https://github.com/chenzeyu/CZPicker",
                                 @"EDSunriseSet": @"https://github.com/erndev/EDSunriseSet",
                                 @"Fabric": @"https://fabric.io",
                                 @"FSCalendar": @"https://github.com/WenchaoD/FSCalendar",
                                 @"MZFormSheetController": @"https://github.com/m1entus/MZFormSheetController"
                                 };
    
    //auto table height
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    
    //set the height of the table
    self.tableHeightConstraint.constant = self.openSourceLibraries.count * 44;
    
    //we don't have copyrights yet, so hide the title label
    self.copyrightLabel.hidden = true;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

-(void)viewWillAppear:(BOOL)animated{
    //change the color of the status bar to match the navigation bar
    if(!self.swapped){
        self.currentStatusBarColor = self.statusBar.backgroundColor;
        self.swapped = true;
    }
    [UIView animateWithDuration:0.4 animations:^{
        self.statusBar.backgroundColor = UIColor.clearColor;
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    //return the nav bar color to its previous state
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

//done button pressed, dismiss the controller
- (IBAction)donePressed:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

//open github
- (IBAction)openGitHub:(id)sender {
    SFSafariViewController *safari = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"https://github.com/alex-taffe/Dining-Tracker"]];
    [self presentViewController:safari animated:true completion:nil];
}

#pragma mark - UITableViewDataSource

//we only have one section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//return the number of sections we have
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.openSourceLibraries.count;
}

//get the cell for each open source library
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"openSourceRow"];
    //sort the keys of the library in alphabetical order and assign the text
    cell.textLabel.text = [[self.openSourceLibraries allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)][indexPath.row];
    return cell;
}

//called when the user taps a row in the table view
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //get the cell they tapped
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    //deselect that cell
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    //convert that cell title into a URL
    NSURL *url = [NSURL URLWithString:self.openSourceLibraries[cell.textLabel.text]];
    
    //Open up Safari
    SFSafariViewController *safari = [[SFSafariViewController alloc] initWithURL:url];
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
