//
//  CatBreedTableViewCell.h
//  Kittens
//
//  Created by Alex on 02.02.2024.
//

#import <UIKit/UIKit.h>
#import "CatBreed.h"

@interface CatBreedTableViewCell : UITableViewCell

- (void)configureWithCatBreed:(CatBreed *)breed;

@end
