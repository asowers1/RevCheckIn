//
//  AllTeamsViewController.m
//  RevCheckIn
//
//  Created by Calvin Chestnut on 8/26/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import "AllTeamsViewController.h"
#import "TeamTableViewCell.h"

@interface AllTeamsViewController ()

@end

@implementation AllTeamsViewController {
    NSMutableDictionary *allTeams;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.teamsTable setRowHeight:100];
    
    [self.teamsTable setDataSource:self];
    [self.teamsTable setDelegate:self];
    
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [blurEffectView setFrame:self.loadingView.bounds];
    [self.loadingView addSubview:blurEffectView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"displayUsers" object:nil];
    
    allTeams = [[NSMutableDictionary alloc] init];
    
    HTTPHelper *helper = [[HTTPHelper alloc] init];
    
    [helper getAllUsers];
}

-(void)reloadTable{

    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User"
                                              inManagedObjectContext:delegate.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [delegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    for (NSManagedObject *record in fetchedRecords){
        /*
        if ([[record valueForKey:@"state"] isEqualToString:@"1"]){
            
            if ([allTeams valueForKey:[record valueForKey:@"business_name"]]){
                [[allTeams valueForKey:[record valueForKey:@"business_name"]] addObject:record];
            } else {
                NSMutableArray *new = [NSMutableArray arrayWithObject:record];
                [allTeams setValue:new forKey:[record valueForKey:@"business_name"]];
            }
            
        }
        */
        
        if ([allTeams valueForKey:[record valueForKey:@"business_name"]]){
            
            [[allTeams valueForKey:[record valueForKey:@"business_name"]] addObject:record];
        } else {
            NSMutableArray *new = [NSMutableArray arrayWithObject:record];
            
            [allTeams setValue:new forKey:[record valueForKey:@"business_name"]];
        }
    }
    
    for (NSString *key in allTeams.allKeys){
        NSMutableArray *members = [allTeams objectForKey:key];
        
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp"
                                                     ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSMutableArray *sortedArray;
        sortedArray = [NSMutableArray arrayWithArray:[members sortedArrayUsingDescriptors:sortDescriptors]];
        
        [allTeams setObject:sortedArray forKey:key];
        
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.teamsTable reloadData];
    });
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger ret = allTeams.allKeys.count;
    return ret;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"teamCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.team = allTeams.allKeys[indexPath.row];
    [cell.teamImage setImage:[UIImage imageNamed:@"push.png"]];
// Set Team logo cell.teamLogo.image = [Team Image]

    [cell.teamMembers setTeamName:cell.team];
    [cell.teamMembers setDataSource:self];
    [cell.teamMembers setDelegate:self];

    return cell;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
    // return 2 to see non-checked in users
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[allTeams objectForKey:[(TeamMembersCollectionView *)collectionView teamName]] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MemberCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"memberCell" forIndexPath:indexPath];
    NSManagedObject *user = [[allTeams objectForKey:[(TeamMembersCollectionView *)collectionView teamName]] objectAtIndex:indexPath.row];
    [cell.memberImage setImage:[UIImage imageNamed:@"businessMan"]];
    cell.name.text = [user valueForKey:@"name"];
    
    NSString *timestamp = [user valueForKey:@"timestamp"];
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    [fm setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    NSDate *time = [fm dateFromString:timestamp];
    [fm setDateFormat:@"M/d h:mm a"];
    timestamp = [fm stringFromDate:time];
    
    cell.timeStamp.text = timestamp;
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
