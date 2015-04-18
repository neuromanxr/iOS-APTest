//
//  TableSectionViewController.m
//  IOSProgrammerTest
//
//  Created by Justin LeClair on 12/15/14.
//  Copyright (c) 2014 AppPartner. All rights reserved.
//

#import "ChatSectionViewController.h"
#import "MainMenuViewController.h"
#import "ChatCell.h"
#import "APUtility.h"

@interface ChatSectionViewController ()
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *loadedChatData;
@end

@implementation ChatSectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavigationBarTitle];
    
    // dynamic cell height
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 102;
    
    self.loadedChatData = [[NSMutableArray alloc] init];
    [self loadJSONData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)loadJSONData
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"chatData" ofType:@"json"];

    NSError *error = nil;

    NSData *rawData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&error];

    id JSONData = [NSJSONSerialization JSONObjectWithData:rawData options:NSJSONReadingAllowFragments error:&error];

    [self.loadedChatData removeAllObjects];
    if ([JSONData isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *jsonDict = (NSDictionary *)JSONData;

        NSArray *loadedArray = [jsonDict objectForKey:@"data"];
        if ([loadedArray isKindOfClass:[NSArray class]])
        {
            for (NSDictionary *chatDict in loadedArray)
            {
                ChatData *chatData = [[ChatData alloc] init];
                [chatData loadWithDictionary:chatDict];
                [self.loadedChatData addObject:chatData];
            }
        }
    }

    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupNavigationBarTitle
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // setup custom back button
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:BACK_BUTTON_IMAGE] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
    
//    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:BACK_BUTTON_IMAGE]];
//    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:BACK_BUTTON_IMAGE]];
    
    // get the font
    NSArray *fontFamily = [UIFont fontNamesForFamilyName:@"Machinato"];
    UIFont *font = [UIFont fontWithName:[fontFamily firstObject] size:HEADER_FONT_SIZE];
    
    NSAttributedString *attribString = [[NSAttributedString alloc] initWithString:@"CHAT" attributes:@{ NSFontAttributeName : font, NSUnderlineStyleAttributeName : @0, NSBackgroundColorAttributeName : [UIColor clearColor] }];
    
    // custom title for navigation title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    title.numberOfLines = 0;
    title.attributedText = attribString;
    title.adjustsFontSizeToFitWidth = YES;
    title.minimumScaleFactor = 0.5;
    [title sizeToFit];
    [self.navigationItem setTitleView:title];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ChatCell";
    ChatCell *cell = nil;

    if (cell == nil)
    {
        UINib *cellNib = [UINib nibWithNibName:cellIdentifier bundle:nil];
        // register this nib, which contains the cell
        [self.tableView registerNib:cellNib forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
//        cell = (ChatCell *)[nib objectAtIndex:0];
    }

    ChatData *chatData = [self.loadedChatData objectAtIndex:[indexPath row]];

    [cell loadWithData:chatData];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.loadedChatData.count;
}

#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return TABLE_CELL_HEIGHT;
//}
@end
