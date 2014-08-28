//
//  TeamInfoViewController.m
//  RevCheckIn
//
//  Created by Calvin Chestnut on 8/28/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import "TeamInfoViewController.h"
#import "EmployeeTableViewCell.h"

@interface TeamInfoViewController ()

@end

@implementation TeamInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.control setSelectedSegmentIndex:[[NSNumber numberWithBool:self.member.boolValue] intValue]];
    [self changeSubview:self.control];
    
    [self setPreferredContentSize:CGSizeMake(320, 750)];
    
    [self.logo.layer setCornerRadius:75];
    [self.logo.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.logo.layer setBorderWidth:5];
    
    [self.employeeTable setRowHeight:90];
    /*
    [self.employeeTable setDataSource:self];
    [self.employeeTable setDelegate:self];
    */
    self.navigationItem.titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 178, 39)];
    [(UIImageView *)self.navigationItem.titleView setContentMode:UIViewContentModeScaleAspectFit];
    [(UIImageView *)self.navigationItem.titleView setImage:[UIImage imageNamed:@"revWithText"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.team objectForKey:@"members"] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EmployeeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"employeeCell"];
    
    [cell passMember:[[self.team objectForKey:@"members"] objectAtIndex:indexPath.row]];
    
    return cell;
}

- (IBAction)close:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changeSubview:(id)sender {
    switch ([(UISegmentedControl *)sender selectedSegmentIndex]) {
        case 0:
            [self.bioView setHidden:NO];
            [self.employeeTable setHidden:YES];
            break;
            
        case 1:
            [self.bioView setHidden:YES];
            [self.employeeTable setHidden:NO];
            break;
            
        default:
            break;
    }
}
@end
