//
//  CatAPIService.h
//  Kittens
//
//  Created by Alex on 02.02.2024.
//

#import <Foundation/Foundation.h>

@interface CatAPIService : NSObject

- (void)loadCatBreedsWithPage:(NSInteger)page
                        limit:(NSInteger)limit
            completionHandler:(void (^)(NSArray *breeds, NSError *error))completionHandler;

- (void)loadImageWithURL:(NSString *)imageURL
       completionHandler:(void (^)(NSData *imageData, NSError *error))completionHandler;

@end
