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

- (IBAction)rangeChanging:(MARKRangeSlider *)sender {
    switch (currentFilter) {
        case PCFilterPrice:
            _searchItem.minimumPrice = @((NSInteger) sender.leftValue);
            _searchItem.maximumPrice = @((NSInteger) sender.rightValue);
            self.tableView.visibleCells.firstObject.detailTextLabel.text = [NSString stringWithFormat:@"€%@ - €%@", _searchItem.minimumPrice, _searchItem.maximumPrice];
            break;
        case PCFilterScore:
            _searchItem.minimumUserScore = @(sender.leftValue);
            _searchItem.maximumUserScore = @(sender.rightValue);
            self.tableView.visibleCells.firstObject.detailTextLabel.text = [NSString stringWithFormat:@"%.1f - %.1f", _searchItem.minimumUserScore.floatValue, _searchItem.maximumUserScore.floatValue];
            break;
        case PCFilterDistance:
            _searchItem.minimumDistance = @((NSInteger) sender.leftValue);
            _searchItem.maximumDistance = @((NSInteger) sender.rightValue);
            self.tableView.visibleCells.firstObject.detailTextLabel.text = [NSString stringWithFormat:@"%@km - %@km", _searchItem.minimumDistance, _searchItem.maximumDistance];
            break;
        case PCFilterStarRating:
            _searchItem.minimumStar = @(sender.leftValue);
            _searchItem.maximumStar = @(sender.rightValue);
            self.tableView.visibleCells.firstObject.detailTextLabel.text = [NSString stringWithFormat:@"%.1f - %.1f", _searchItem.minimumStar.floatValue, _searchItem.maximumStar.floatValue];
            break;
        default:
            break;
    }
}


- (IBAction)sliderValueChanging:(UISlider *)sender {
    switch (currentFilter) {
        case PCFilterReview:
            _searchItem.minimumReviews = @((NSInteger) sender.value);
            self.tableView.visibleCells.firstObject.detailTextLabel.text = [NSString stringWithFormat:@"At least %@", _searchItem.minimumReviews];
            break;
        case PCFilterCheckInPeople:
            _searchItem.numberOfPeople = @((NSInteger) sender.value);
            self.tableView.visibleCells.firstObject.detailTextLabel.text = [NSString stringWithFormat:@"%@ Adult(s)", _searchItem.numberOfPeople];
            break;
        default:
            break;
    }
}

- (IBAction)editingDidEnd:(id)sender {
    [self.delegate searchShouldChange];
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
                cell.detailTextLabel.text = [NSString stringWithFormat:@"€%@ - €%@", _searchItem.minimumPrice, _searchItem.maximumPrice];
                cell.imageView.image = [UIImage imageNamed:@"money_bag"];
                cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
                break;
            case PCFilterScore:
                cell.textLabel.text = @"Score";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", _searchItem.minimumUserScore, _searchItem.maximumUserScore];
                cell.imageView.image = [UIImage imageNamed:@"like"];
                cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
                break;
            case PCFilterReview:
                cell.textLabel.text = @"Reviews";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"At least %@", _searchItem.minimumReviews];
                cell.imageView.image = [UIImage imageNamed:@"comments"];
                cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
                break;
            case PCFilterDistance:
                cell.textLabel.text = @"Distance";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@km - %@km", _searchItem.minimumDistance, _searchItem.maximumDistance];
                cell.imageView.image = [UIImage imageNamed:@"distance_2"];
                cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
                break;
            case PCFilterStarRating:
                cell.textLabel.text = @"Stars";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", _searchItem.minimumStar, _searchItem.maximumStar];
                cell.imageView.image = [UIImage imageNamed:@"star"];
                cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
                break;
            case PCFilterCheckInPeople:
                cell.textLabel.text = @"People";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ Adult(s)", _searchItem.numberOfPeople];
                cell.imageView.image = [UIImage imageNamed:@"People-2"];
                cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
                break;
            default:
                break;
        }
        cell.imageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        return cell;
    }
    else {
        PCAttributeAdjustmentCell *cell;
        switch (currentFilter) {
            case PCFilterPrice:
                cell = [tableView dequeueReusableCellWithIdentifier:@"RangeCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"Price for 1 night";
                [cell.rangeSlider setMinValue:0 maxValue:5000];
                [cell.rangeSlider setLeftValue:_searchItem.minimumPrice.floatValue rightValue:_searchItem.maximumPrice.floatValue];
                break;
            case PCFilterScore:
                cell = [tableView dequeueReusableCellWithIdentifier:@"RangeCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"How much score does this hotel rated";
                [cell.rangeSlider setMinValue:0 maxValue:10];
                [cell.rangeSlider setLeftValue:_searchItem.minimumUserScore.floatValue rightValue:_searchItem.maximumUserScore.floatValue];
                break;
            case PCFilterReview:
                cell = [tableView dequeueReusableCellWithIdentifier:@"ValueCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"Verified reviews from real guests";
                [cell.slider setMinimumValue:0];
                [cell.slider setMaximumValue:10000];
                [cell.slider setValue:_searchItem.minimumReviews.integerValue];
                break;
            case PCFilterDistance:
                cell = [tableView dequeueReusableCellWithIdentifier:@"RangeCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"How far from hotel to scene spot";
                [cell.rangeSlider setMinValue:0 maxValue:5];
                [cell.rangeSlider setLeftValue:_searchItem.minimumDistance.integerValue rightValue:_searchItem.maximumDistance.integerValue];
                break;
            case PCFilterStarRating:
                cell = [tableView dequeueReusableCellWithIdentifier:@"RangeCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"How many stars is this hotel";
                [cell.rangeSlider setMinValue:0 maxValue:5];
                [cell.rangeSlider setLeftValue:_searchItem.minimumStar.floatValue rightValue:_searchItem.maximumStar.floatValue];
                break;
            case PCFilterCheckInPeople:
                cell = [tableView dequeueReusableCellWithIdentifier:@"ValueCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"# of people you want accommondate";
                [cell.slider setMinimumValue:1];
                [cell.slider setMaximumValue:4];
                [cell.slider setValue:_searchItem.numberOfPeople.integerValue];
                break;
            default:
                break;
        }
        [cell.rangeSlider addTarget:self action:@selector(rangeChanging:) forControlEvents:UIControlEventValueChanged];
        [cell.slider addTarget:self action:@selector(sliderValueChanging:) forControlEvents:UIControlEventValueChanged];
        
        [cell.rangeSlider addTarget:self action:@selector(editingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
        [cell.slider addTarget:self action:@selector(editingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
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
        [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
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
