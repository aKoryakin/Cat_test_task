//
//  CatDetailViewController.m
//  Kittens
//
//  Created by Alex on 02.02.2024.
//

#import "CatDetailViewController.h"
#import "CatAPIService.h"

@interface CatDetailViewController ()

@property (nonatomic, strong) CatBreed *catBreed;
@property (nonatomic, strong) UIImageView *breedImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *temperamentLabel;
@property (nonatomic, strong) UILabel *originLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *lifespanLabel;

@end

@implementation CatDetailViewController

#pragma mark - Initializations

- (instancetype)initWithCatBreed:(CatBreed *)breed {
    self = [super init];
    if (self) {
        self.catBreed = breed;
    }
    return self;
}

#pragma mark - Vc life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Cat Details";
    
    [self setupUI];
    [self configureUIWithCatBreed];
}

#pragma mark - Helpers

- (void)setupUI {
    self.breedImageView = [[UIImageView alloc] init];
    self.breedImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.breedImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.breedImageView];
    
    self.nameLabel = [self createLabel];
    self.temperamentLabel = [self createLabel];
    self.originLabel = [self createLabel];
    self.descriptionLabel = [self createLabel];
    self.lifespanLabel = [self createLabel];
    
    [self setupConstraints];
}

- (UILabel *)createLabel {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.numberOfLines = 0;
    [self.view addSubview:label];
    return label;
}

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.breedImageView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:10],
        [self.breedImageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:10],
        [self.breedImageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-10],
        [self.breedImageView.heightAnchor constraintEqualToConstant:200],
    ]];
    
    NSArray<UILabel *> *labels = @[self.nameLabel, self.temperamentLabel, self.originLabel, self.descriptionLabel, self.lifespanLabel];
    for (NSUInteger i = 0; i < labels.count; i++) {
        [NSLayoutConstraint activateConstraints:@[
            [labels[i].leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:10],
            [labels[i].trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-10],
        ]];
        
        if (i == 0) {
            [NSLayoutConstraint activateConstraints:@[
                [labels[i].topAnchor constraintEqualToAnchor:self.breedImageView.bottomAnchor constant:10],
            ]];
        } else {
            [NSLayoutConstraint activateConstraints:@[
                [labels[i].topAnchor constraintEqualToAnchor:labels[i - 1].bottomAnchor constant:10],
            ]];
        }
    }
}

- (void)configureUIWithCatBreed {
    self.nameLabel.attributedText = [self attributedStringWithBoldTitle:@"Name" value:self.catBreed.name];
    self.temperamentLabel.attributedText = [self attributedStringWithBoldTitle:@"Temperament" value:self.catBreed.temperament];
    self.originLabel.attributedText = [self attributedStringWithBoldTitle:@"Origin" value:self.catBreed.origin];
    self.descriptionLabel.attributedText = [self attributedStringWithBoldTitle:@"Description" value:self.catBreed.breedDescription];
    self.lifespanLabel.attributedText = [self attributedStringWithBoldTitle:@"Lifespan" value:self.catBreed.lifeSpan];
    
    [self loadImageWithURL:self.catBreed.imageURL];
}

- (NSAttributedString *)attributedStringWithBoldTitle:(NSString *)title value:(NSString *)value {
    NSString *htmlString = [NSString stringWithFormat:@"<span style='font-size:16px;'><b>%@:</b> %@</span>", title, value];
    return [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                            options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                 documentAttributes:nil
                                              error:nil];
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
