//
//  FeedSearchCell.h
//  GoogleFeedSearch
//
//  Created by Mark on 10/15/13.
//  Copyright (c) 2013 Mark Hambly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedSearchCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *cellTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *cellDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *cellUrlLabel;

@end
