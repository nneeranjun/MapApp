//
//  CoordinatesCustomCell.h
//  Maps
//
//  Created by Nilay Neeranjun on 6/8/16.
//  Copyright © 2016 Nilay Neeranjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoordinatesCustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *index;
@property (weak, nonatomic) IBOutlet UILabel *latitude;
@property (weak, nonatomic) IBOutlet UILabel *longitude;

@end
