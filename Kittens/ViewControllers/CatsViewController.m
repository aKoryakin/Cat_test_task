//
//  ViewController.m
//  Kittens
//
//  Created by Alex on 01.02.2024.
//

#import "CatsViewController.h"
#import "CatBreed.h"
#import "CatAPIService.h"
#import "CatBreedTableViewCell.h"
#import "CatDetailViewController.h"

@interface CatsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<CatBreed *> *catBreeds;
@property (nonatomic, strong) CatAPIService *apiService;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) BOOL isLoadingData;

@end

@implementation CatsViewController

#pragma mark - Vc life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Cat Breeds";
    
    self.apiService = [[CatAPIService alloc] init];
    self.currentPage = 0;
    self.catBreeds = [NSMutableArray array];
    
    [self setupUI];
    [self loadCatBreeds];
}

#pragma mark - Helpers

- (void)setupUI {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass: [CatBreedTableViewCell class] forCellReuseIdentifier:@"CatBreedCellIdentifier"];
    [self.view addSubview:self.tableView];
    
    [self setupConstraints];
}

- (void)setupConstraints {
    NSLayoutConstraint *topConstraint = [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor];
    NSLayoutConstraint *leadingConstraint = [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor];
    NSLayoutConstraint *trailingConstraint = [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor];
    NSLayoutConstraint *bottomConstraint = [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor];

    [NSLayoutConstraint activateConstraints:@[topConstraint, leadingConstraint, trailingConstraint, bottomConstraint]];
}

- (void)loadCatBreeds {
    if (self.isLoadingData) {
        return;
    }
    
    self.isLoadingData = YES;
    
    [self.apiService loadCatBreedsWithPage:self.currentPage limit:10 completionHandler:^(NSArray *breeds, NSError *error) {
        if (error) {
            NSLog(@"Error loading cat breeds: %@", error.localizedDescription);
        } else {
            self.catBreeds = [self.catBreeds arrayByAddingObjectsFromArray:breeds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                self.isLoadingData = NO;
            });
        }
    }];
}

#pragma mark - Table view ds / delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.catBreeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CatBreedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CatBreedCellIdentifier" forIndexPath:indexPath];
    
    CatBreed *breed = self.catBreeds[indexPath.row];
    [cell configureWithCatBreed:breed];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CatBreed *selectedBreed = self.catBreeds[indexPath.row];
    
    CatDetailViewController *detailViewController = [[CatDetailViewController alloc] initWithCatBreed:selectedBreed];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.catBreeds.count - 2) {
        self.currentPage++;
        [self loadCatBreeds];
    }
}

@end

