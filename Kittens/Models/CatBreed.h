//
//  CatBreed.h
//  Kittens
//
//  Created by Alex on 02.02.2024.
//

#import <Foundation/Foundation.h>

@interface CatBreed : NSObject

@property (nonatomic, strong) NSString *breedID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *temperament;
@property (nonatomic, strong) NSString *origin;
@property (nonatomic, strong) NSString *breedDescription;
@property (nonatomic, strong) NSString *lifeSpan;
@property (nonatomic, strong) NSString *imageURL;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
