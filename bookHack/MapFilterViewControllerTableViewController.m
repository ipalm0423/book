//
//  MapFilterViewControllerTableViewController.m
//  bookHack
//
//  Created by 蘇柄臣 on 2017/3/11.
//  Copyright © 2017年 Jack KY Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapFilterViewControllerTableViewController.h"
#import <MARKRangeSlider/MARKRangeSlider.h>


@implementation PCAttributeAdjustmentCell

@end

typedef enum : NSInteger {
    PCFilterNone            = -1,
    PCFilterPrice           = 0,
    PCFilterDistance        = 1,
    PCFilterStarRating      = 2,
    PCFilterReview          = 3,
    PCFilterScore           = 4,
    PCFilterCheckInPeople   = 5
} PCFilterEnum;

@interface MapFilterViewControllerTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelPriceRange;
@property (weak, nonatomic) IBOutlet MARKRangeSlider *sliderPriceRange;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellPrice;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellDistance;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellHotelStar;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellNumberOfReviews;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellCustomerScore;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellCheckInPeople;

@end

@implementation MapFilterViewControllerTableViewController
{
    PCFilterEnum currentFilter;
    NSLayoutConstraint *heightConstraint;
}
@synthesize labelPriceRange, sliderPriceRange;
@synthesize cellPrice, cellDistance, cellHotelStar, cellNumberOfReviews, cellCustomerScore, cellCheckInPeople;

- (void)viewDidLoad {
    [super viewDidLoad];
    currentFilter = PCFilterNone;
    [sliderPriceRange setMinValue:100 maxValue:10000];
    [sliderPriceRange setLeftValue:1000 rightValue:4000];
    labelPriceRange.text = @"$1000 - $4000";
    
    self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView layoutIfNeeded];
    
    heightConstraint = [NSLayoutConstraint constraintWithItem:self.view
                                                    attribute:NSLayoutAttributeHeight
                                                    relatedBy:NSLayoutRelationEqual
                                                       toItem:nil
                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                   multiplier:1
                                                     constant:240];
    heightConstraint.priority = UILayoutPriorityDefaultHigh;
    [self.view addConstraint:heightConstraint];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGSize)preferredContentSize
{
    // Force the table view to calculate its height
    [self.tableView layoutIfNeeded];
    return self.tableView.contentSize;
}

- (IBAction)rangeChanged:(MARKRangeSlider *)sender {
    labelPriceRange.text = [NSString stringWithFormat:@"$%d - $%d", (int)sender.leftValue, (int)sender.rightValue];
    cellPrice.detailTextLabel.text = [NSString stringWithFormat:@"$%d - $%d", (int)sender.leftValue, (int)sender.rightValue];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (currentFilter == PCFilterNone) {
        return 6;
    }
    else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (currentFilter == PCFilterNone || indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell" forIndexPath:indexPath];
        switch (indexPath.row) {
            case PCFilterPrice:
                cell.textLabel.text = @"Price";
                break;
            case PCFilterScore:
                cell.textLabel.text = @"Score";
                break;
            case PCFilterReview:
                cell.textLabel.text = @"Reviews";
                break;
            case PCFilterDistance:
                cell.textLabel.text = @"Distance";
                break;
            case PCFilterStarRating:
                cell.textLabel.text = @"Stars";
                break;
            case PCFilterCheckInPeople:
                cell.textLabel.text = @"People";
                break;
            default:
                break;
        }
        return cell;
    }
    else {
        PCAttributeAdjustmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RangeCell" forIndexPath:indexPath];
        [cell.rangeSlider addTarget:self action:@selector(rangeChanged:) forControlEvents:UIControlEventValueChanged];
        switch (currentFilter) {
            case PCFilterPrice:
                cell.titleLabel.text = @"Price";
                break;
            case PCFilterScore:
                cell.titleLabel.text = @"Score";
                break;
            case PCFilterReview:
                cell.titleLabel.text = @"Number of reviews";
                break;
            case PCFilterDistance:
                cell.titleLabel.text = @"Distance";
                break;
            case PCFilterStarRating:
                cell.titleLabel.text = @"Stars";
                break;
            case PCFilterCheckInPeople:
                cell.titleLabel.text = @"How many people to check in?";
                break;
            default:
                break;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (currentFilter == PCFilterNone || indexPath.row == 0) {
        return 40;
    }
    return UITableViewAutomaticDimension;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (currentFilter == PCFilterNone) {
        return indexPath;
    }
    if (indexPath.row == 0) {
        return indexPath;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView beginUpdates];
    if (currentFilter != PCFilterNone) {
        NSMutableArray *indexPathsInsert = [NSMutableArray new];
        for (NSInteger i = 0; i != 6; i++) {
            if (i == currentFilter) {
                continue;
            }
            [indexPathsInsert addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        currentFilter = PCFilterNone;
        [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView insertRowsAtIndexPaths:indexPathsInsert withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else {
        currentFilter = indexPath.row;
        NSMutableArray *indexPathsDelete = [NSMutableArray new];
        for (NSInteger i = 0; i != 6; i++) {
            if (i == indexPath.row) {
                continue;
            }
            [indexPathsDelete addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        [tableView deleteRowsAtIndexPaths:indexPathsDelete withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [tableView endUpdates];
}

@end
