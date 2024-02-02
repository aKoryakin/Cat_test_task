//
//  CatBreedTableViewCell.m
//  Kittens
//
//  Created by Alex on 02.02.2024.
//

#import "CatBreedTableViewCell.h"
#import "CatAPIService.h"

@interface CatBreedTableViewCell ()

@property (nonatomic, strong) UIImageView *breedImageView;
@property (nonatomic, strong) UILabel *breedNameLabel;

@end

@implementation CatBreedTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.breedImageView = [[UIImageView alloc] init];
    self.breedImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.breedImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.breedImageView];
    
    self.breedNameLabel = [[UILabel alloc] init];
    self.breedNameLabel.font = [UIFont systemFontOfSize:16];
    self.breedNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.breedNameLabel];
    
    [self setupConstraints];
}

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.breedImageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16],
        [self.breedImageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8],
        [self.breedImageView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-8],
        [self.breedImageView.widthAnchor constraintEqualToConstant:80],
        [self.breedImageView.heightAnchor constraintEqualToConstant:80],
    ]];

    [NSLayoutConstraint activateConstraints:@[
        [self.breedNameLabel.leadingAnchor constraintEqualToAnchor:self.breedImageView.trailingAnchor constant:16],
        [self.breedNameLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16],
        [self.breedNameLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
    ]];
}

- (void)configureWithCatBreed:(CatBreed *)breed {
    self.breedNameLabel.text = breed.name;
    
    [self loadImageWithURL:breed.imageURL];
}

- (void)loadImageWithURL:(NSString *)imageURL {
    [[[CatAPIService alloc] init] loadImageWithURL:imageURL completionHandler:^(NSData *imageData, NSError *error) {
        if (imageData) {
            UIImage *image = [UIImage imageWithData:imageData];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.breedImageView.image = image;
            });
        } else {
            NSLog(@"Error loading image: %@", error.localizedDescription);
        }
    }];
}

@end

