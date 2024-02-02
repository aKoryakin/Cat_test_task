//
//  CatAPIService.m
//  Kittens
//
//  Created by Alex on 02.02.2024.
//

#import "CatAPIService.h"
#import "CatBreed.h"

static NSString * const kBaseURL = @"https://api.thecatapi.com/v1";
static NSString * const kAPIKey = @"live_UFEU8Q4cMMXH8OsPjJVdbBEuyYipyouIZ4V6ia09OttbEk8kANvblqdVCYoanc7k";

@implementation CatAPIService

- (void)loadCatBreedsWithPage:(NSInteger)page
                        limit:(NSInteger)limit
            completionHandler:(void (^)(NSArray *breeds, NSError *error))completionHandler {
    
    NSString *endpoint = [NSString stringWithFormat:@"/breeds?limit=%ld&page=%ld", (long)limit, (long)page];
    NSURL *url = [NSURL URLWithString:[kBaseURL stringByAppendingString:endpoint]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request addValue:kAPIKey forHTTPHeaderField:@"x-api-key"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completionHandler(nil, error);
        } else {
            NSError *jsonError;
            NSArray *breedsData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            if (jsonError) {
                completionHandler(nil, jsonError);
            } else {
                NSMutableArray *breeds = [NSMutableArray array];
                
                for (NSDictionary *breedData in breedsData) {
                    CatBreed *breed = [[CatBreed alloc] initWithDictionary:breedData];
                    [breeds addObject:breed];
                }
                
                completionHandler(breeds, nil);
            }
        }
    }];
    
    [dataTask resume];
}

- (void)loadImageWithURL:(NSString *)imageURL
       completionHandler:(void (^)(NSData *imageData, NSError *error))completionHandler {
    
    NSURL *url = [NSURL URLWithString:imageURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completionHandler(nil, error);
        } else {
            completionHandler(data, nil);
        }
    }];
    
    [dataTask resume];
}

@end


