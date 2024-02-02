//
//  CatBreed.m
//  Kittens
//
//  Created by Alex on 02.02.2024.
//

#import "CatBreed.h"

@implementation CatBreed

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.breedID = dictionary[@"id"];
        self.name = dictionary[@"name"];
        self.temperament = dictionary[@"temperament"];
        self.origin = dictionary[@"origin"];
        self.breedDescription = dictionary[@"description"];
        self.lifeSpan = dictionary[@"life_span"];
        self.imageURL = dictionary[@"image"][@"url"];
    }
    return self;
}

@end
