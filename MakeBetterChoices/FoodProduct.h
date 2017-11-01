//
//  FoodProduct.h
//  MakeBetterChoices
//
//  Created by Jamar Gibbs on 6/5/16.
//  Copyright © 2016 B3773R. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodProduct : NSObject

@property NSString *foodProductImage;
@property NSString *foodProductName;
@property NSString *foodProductBrand;
@property NSString *foodProductUpc;
@property NSNumber *foodFats;
@property NSNumber *foodProteins;
@property (strong, retain) NSNumber *foodCarbs;
@property NSNumber *foodFibers;
@property NSNumber *foodSugars;
@property NSString *foodCalories;
@property NSString *foodIngredients;
@property NSNumber *foodServingWeight;
@property NSNumber *foodSaturatedFats;

@end
