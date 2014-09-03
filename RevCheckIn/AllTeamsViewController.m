//
//  AllTeamsViewController.m
//  RevCheckIn
//
//  Created by Calvin Chestnut on 8/26/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import "AllTeamsViewController.h"
#import "TeamTableViewCell.h"
#import "TeamInfoViewController.h"
#import "accountTableViewController.h"
#import <Crashlytics/Crashlytics.h>

#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface AllTeamsViewController ()

@end

@implementation AllTeamsViewController {
    NSMutableDictionary *allTeams;
    
    NSManagedObject *activeUser;
    NSDictionary *activeTeam;
    
    NSDictionary *selectedTeam;
    NSString *selectedMember;
    CGFloat defaultLeft;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    defaultLeft = self.anchorLeftSpace.constant;
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
    [(UIImageView *)self.navigationItem.titleView setContentMode:UIViewContentModeScaleAspectFit];
    [(UIImageView *)self.navigationItem.titleView setImage:[UIImage imageNamed:@"revWithText"]];
    
    [self.teamsTable setRowHeight:110];
    
    [self.teamsTable setDataSource:self];
    [self.teamsTable setDelegate:self];
    
    self.refresh = [[UIRefreshControl alloc] init];
    
    [self.refresh addTarget:self action:@selector(reloadUsers) forControlEvents:UIControlEventValueChanged];
    [self.teamsTable addSubview:self.refresh];
    
    [self.loadingView changeText:@"loading teams"];
    [self.loadingView startAnimating];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"displayUsers" object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [self reloadUsers];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)reloadUsers{

    if (self.refresh.refreshing){
        NSLog(@"refresh");
        [self.refresh endRefreshing];
        [self.loadingView startAnimating];
    } else {
        NSLog(@"not refresh");
    }
    [self.teamsTable setUserInteractionEnabled:NO];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        HTTPHelper *helper = [[HTTPHelper alloc] init];
        
        [helper getAllUsers];
    });

}

-(void)reloadTable{
    
    allTeams = [[NSMutableDictionary alloc] init];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"Active_user"];
    
    NSArray *actuveUserArray = [delegate.managedObjectContext executeFetchRequest:fetch error:nil];
    if (actuveUserArray.count > 0){
        
        activeUser = actuveUserArray[0];
        
    }
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User"
                                              inManagedObjectContext:delegate.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [delegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    for (NSManagedObject *record in fetchedRecords){
        
        if ([allTeams valueForKey:[record valueForKey:@"business_name"]]){
            NSMutableDictionary *teamInfo = allTeams[[record valueForKey:@"business_name"]];
            
            if ([[record valueForKey:@"state"] isEqualToString:@"1"]){
                [teamInfo[@"checkedIn"] addObject:record];
            }
            [teamInfo[@"members"] addObject:record];
            
            if ([[record valueForKey:@"username"] isEqualToString:[activeUser valueForKey:@"username"]]){
                activeTeam = teamInfo;
                activeUser = record;
            }
            
        } else {
            // Download Team Image
            NSURL *teamURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://experiencepush.com/rev/rest/index.php?PUSH_ID=123&call=getBusinessPicture&username=%@", [record valueForKey:@"username"]]];
            NSData *logoData = [NSData dataWithContentsOfURL:teamURL];
            UIImage *teamLogo;
            if (logoData.length > 0){
                teamLogo = [UIImage imageWithData:logoData];
            } else {
                teamLogo = [UIImage imageNamed:@"defaultLogo"];
            }
            NSMutableDictionary *teamInfo = [NSMutableDictionary dictionaryWithObjects:@[[record valueForKey:@"business_name"], [[NSMutableArray alloc] init], [[NSMutableArray alloc] init], teamLogo, @"Push Interactive was founded by some guys who wanted to do some things Push Interactive was founded by some guys who wanted to do some things Push Interactive was founded by some guys who wanted to do some things"] forKeys:@[@"teamName", @"checkedIn", @"members", @"logo", @"bio"]];

            if ([[record valueForKey:@"state"] isEqualToString:@"1"]){
                [teamInfo[@"checkedIn"] addObject:record];
            }
            [teamInfo[@"members"] addObject:record];
            
            if ([[record valueForKey:@"username"] isEqualToString:[activeUser valueForKey:@"username"]]){
                activeTeam = teamInfo;
                activeUser = record;
            }
            
            [allTeams setValue:teamInfo forKey:[record valueForKey:@"business_name"]];
        }
    }
    
    for (NSString *key in allTeams.allKeys){
        NSMutableArray *members = [[allTeams objectForKey:key] objectForKey:@"members"];
        
        NSSortDescriptor *sortState;
        sortState = [[NSSortDescriptor alloc] initWithKey:@"state"
                                                     ascending:NO];
        NSSortDescriptor *name = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sortState, name, nil];
        NSMutableArray *sortedArray;
        sortedArray = [NSMutableArray arrayWithArray:[members sortedArrayUsingDescriptors:sortDescriptors]];
        
        [[allTeams objectForKey:key] setObject:sortedArray forKey:@"members"];
        
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.loadingView hide];
        [self.teamsTable reloadData];
        [self.teamsTable setUserInteractionEnabled:YES];
        [self.refresh endRefreshing];
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
    cell.team = [allTeams objectForKey:allTeams.allKeys[indexPath.row]];
    [cell.teamImage setImage:[allTeams[[allTeams.allKeys objectAtIndex:indexPath.row]] objectForKey:@"logo"]];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];;
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [blurEffectView setFrame:CGRectMake(0, 0, 96, 105)];
    [[cell contentView] addSubview:blurEffectView];
    
    UIVisualEffectView *blurBuffer = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [blurBuffer setFrame:CGRectMake(88, 0, 16, 105)];
    
    CAGradientLayer *l = [CAGradientLayer layer];
    l.frame = blurBuffer.bounds;
    l.colors = [NSArray arrayWithObjects:(id)[UIColor clearColor].CGColor, (id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
    l.startPoint = CGPointMake(0.0f, 0.5f);
    l.endPoint = CGPointMake(1.0f, 0.5f);
    blurBuffer.layer.mask = l;

    [cell.contentView addSubview:blurBuffer];
    [cell.contentView sendSubviewToBack:blurBuffer];
    [[cell contentView] sendSubviewToBack:blurEffectView];
    [[cell contentView] sendSubviewToBack:cell.teamMembers];
    
    [cell.teamMembers setTeamName:allTeams.allKeys[indexPath.row]];
    if (cell.teamMembers.delegate == self){
        [cell.teamMembers reloadData];
    } else {
        [cell.teamMembers setDataSource:self];
        [cell.teamMembers setDelegate:self];
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectedMember = nil;
    selectedTeam = [(TeamTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] team];
    self.anchorTopSpace.constant = [tableView cellForRowAtIndexPath:indexPath].frame.origin.y + (tableView.rowHeight / 2.0) + self.teamsTable.frame.origin.y;
    self.anchorLeftSpace.constant = defaultLeft;
    self.anchorWidth.constant = 1;
    NSLog(@"%f", self.anchorTopSpace.constant);
    [self.view layoutIfNeeded];
    
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 8){
        [self performSegueWithIdentifier:@"showTeam" sender:self];
    } else {
        UIViewController *info = [self.storyboard instantiateViewControllerWithIdentifier:@"teamModal"];
        
        [(TeamInfoViewController *)[(UINavigationController *)info viewControllers][0] setTeam:selectedTeam];
        
        if (selectedMember){
            [(TeamInfoViewController *)[(UINavigationController *)info viewControllers][0] setMember:selectedMember];
            selectedMember = nil;
        }
        
        if (!IPAD){
            [self presentViewController:info animated:YES completion:nil];
        } else {
            
            UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:info];
            popover.popoverContentSize = CGSizeMake(644, 425); //your custom size.
            [popover presentPopoverFromRect:self.anchor.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
    // return 2 to see non-checked in users
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 106, 0, 5);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[[allTeams objectForKey:[(TeamMembersCollectionView *)collectionView teamName]] objectForKey:@"members"] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MemberCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"memberCell" forIndexPath:indexPath];
    NSManagedObject *user = [[[allTeams objectForKey:[(TeamMembersCollectionView *)collectionView teamName]] objectForKey:@"members"] objectAtIndex:indexPath.row];
    [cell.memberImage setImage:[UIImage imageWithData:[user valueForKey:@"picture"]]];
    [cell.memberImage.layer setCornerRadius:cell.memberImage.frame.size.width/2.0];
    [cell.memberImage setClipsToBounds:YES];
    
    if ([[user valueForKey:@"state"] isEqualToString:@"1"]){
        [cell.memberImage.layer setBorderColor:[UIColor greenColor].CGColor];
        [cell.memberImage.layer setBorderWidth:2];
        [cell.timeStamp setHidden:NO];
    } else {
        [cell.memberImage.layer setBorderWidth:0];
        [cell.timeStamp setHidden:YES];
    }
    
    cell.name.text = [user valueForKey:@"name"];
    
    [cell.name setMarqueeType:MLContinuous];
    [cell.name setContinuousMarqueeExtraBuffer:20];
    [cell.name setAnimationDelay:2];
    [cell.name setRate:10];
    [cell.name setFadeLength:5];
    
    NSString *timestamp = [user valueForKey:@"timestamp"];
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    [fm setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    NSDate *time = [fm dateFromString:timestamp];
    [fm setDateFormat:@"M/d h:mm a"];
    timestamp = [fm stringFromDate:time];
    
    cell.timeStamp.text = timestamp;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    selectedTeam = [allTeams objectForKey:[(TeamMembersCollectionView *)collectionView teamName]];
    selectedMember = [[(MemberCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath] name] text];
    UIView *view = collectionView;
    while (view && ![view isKindOfClass:[UITableViewCell class]]){
        view = view.superview;
    }
    self.anchorTopSpace.constant = view.frame.origin.y + [(MemberCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath] memberImage].frame.origin.y + ([(MemberCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath] memberImage].frame.size.height / 2.0) + self.teamsTable.frame.origin.y;
    
// Modify the anchor space to fit match the selected Cell
    self.anchorLeftSpace.constant = [collectionView convertRect:[collectionView cellForItemAtIndexPath:indexPath].frame toView:self.view].origin.x;
    self.anchorWidth.constant = [[(MemberCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath] memberImage] frame].size.width;
    [self.view layoutIfNeeded];
    
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 8){
        [self performSegueWithIdentifier:@"showTeam" sender:self];
    } else {
        UIViewController *info = [self.storyboard instantiateViewControllerWithIdentifier:@"teamModal"];
        
        [(TeamInfoViewController *)[(UINavigationController *)info viewControllers][0] setTeam:selectedTeam];
        
        if (selectedMember){
            [(TeamInfoViewController *)[(UINavigationController *)info viewControllers][0] setMember:selectedMember];
            selectedMember = nil;
        }
        
        if (!IPAD){
            [self presentViewController:info animated:YES completion:nil];
        } else {
            
            UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:info];
            popover.popoverContentSize = CGSizeMake(644, 425); //your custom size.
            [popover presentPopoverFromRect:self.anchor.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showTeam"]){
        [(TeamInfoViewController *)[(UINavigationController *)[segue destinationViewController] viewControllers][0] setTeam:selectedTeam];
        
        if (selectedMember){
            [(TeamInfoViewController *)[(UINavigationController *)[segue destinationViewController] viewControllers][0] setMember:selectedMember];
            selectedMember = nil;
        }
    } else if ([segue.identifier isEqualToString:@"accountSettings"]){
        [(AccountTableViewController *)[(UINavigationController *)[segue destinationViewController] viewControllers][0] setTeamInfo:activeTeam];
        
        [(AccountTableViewController *)[(UINavigationController *)[segue destinationViewController] viewControllers][0] setUser:activeUser];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
