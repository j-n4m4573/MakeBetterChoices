//
//  NutritionDetailViewController.m
//  MakeBetterChoices
//
//  Created by Jamar Gibbs on 6/5/16.
//  Copyright © 2016 B3773R. All rights reserved.
//

#import "NutritionDetailViewController.h"
#import "FoodProduct.h"

@interface NutritionDetailViewController ()
@property (strong, retain) FoodProduct *foodProduct;
@property NSDictionary *nutrixFoodData;
@property (weak, nonatomic) IBOutlet UITextView *calorieOutlet;
@property (weak, nonatomic) IBOutlet UITextView *fatsOutlet;
@property (weak, nonatomic) IBOutlet UITextView *sugarsOutlet;
@property (weak, nonatomic) IBOutlet UITextView *carbsOutlet;
@property (weak, nonatomic) IBOutlet UITextView *proteinsOutlet;
@property (weak, nonatomic) IBOutlet UITextView *fibersOutlet;
@property NSNumber *calorieCalculation;
@property NSNumber *sugarCalculation;
@property NSNumber *carbMultiplier;
@property (weak, nonatomic) IBOutlet UITextView *calorieCalculationOutlet;
@property (weak, nonatomic) IBOutlet UITextView *fatsCalculationOutlet;
@property (weak, nonatomic) IBOutlet UITextView *sugarsCalculationOutlet;
@property (weak, nonatomic) IBOutlet UITextView *carbCalculationOutlet;
@property (weak, nonatomic) IBOutlet UITextView *proteinCalculationOutlet;
@property (weak, nonatomic) IBOutlet UITextView *fiberCalculationOutlet;
@property NSString *testString;
@end

@implementation NutritionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.foodProduct = [FoodProduct new];
    [self getNutrixData];
}

-(void)getNutrixData {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.nutritionix.com/v1_1/item?upc=%@&appId=dc5c3f31&appKey=2762589da8bb4b44bcbd88c89ae505da",self.foodProductDetails.barcode]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler: ^(NSData *data, NSURLResponse *response, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSDictionary *returnedNutrixData = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             self.nutrixFoodData = returnedNutrixData;
             
             self.foodProduct.foodFats = self.nutrixFoodData[@"nf_total_fat"];
             self.foodProduct.foodProteins = self.nutrixFoodData[@"nf_protein"];
             self.foodProduct.foodCarbs = self.nutrixFoodData[@"nf_total_carbohydrate"];
             self.foodProduct.foodFibers = self.nutrixFoodData[@"nf_dietary_fiber"];
             self.foodProduct.foodSugars = self.nutrixFoodData[@"nf_sugars"];
             self.foodProduct.foodCalories = self.nutrixFoodData[@"nf_calories"];
             self.foodProduct.foodIngredients = self.nutrixFoodData[@"nf_ingredient_statement"];
             self.foodProduct.foodServingWeight = self.nutrixFoodData[@"nf_serving_weight_grams"];
             self.foodProduct.foodSaturatedFats = self.nutrixFoodData[@"nf_saturated_fat"];
             self.testString = [self.nutrixFoodData[@"nf_total_carbohydrate"]stringValue];
             
             NSLog(@"%@", self.testString);
             NSLog(@"%@",self.foodProduct.foodCalories);
             NSLog(@"%@",self.nutrixFoodData);
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self setLabels];
             });
         }
     }];
   
    [task resume];
}

-(void)setLabels {
    
    self.calorieOutlet.text = [NSString stringWithFormat:@"%@",self.foodProduct.foodCalories];
    self.sugarsOutlet.text =[NSString stringWithFormat:@"%@", self.foodProduct.foodSugars];
    self.fatsOutlet.text = [NSString stringWithFormat:@"%@",self.foodProduct.foodFats];
    self.carbsOutlet.text = [NSString stringWithFormat:@"%@",self.foodProduct.foodCarbs];
    self.proteinsOutlet.text = [NSString stringWithFormat:@"%@", self.foodProduct.foodProteins];
//    self.fibersOutlet.text = [NSString stringWithFormat:@"%@",[self.foodProduct.foodFibers stringValue]];
    
    NSLog(@"%@",self.foodProduct.foodCarbs);
    [self calculateNutritionalValue];
}


-(void)calculateNutritionalValue {
//    self.calorieCalculation = self.foodProduct.foodCalories;
    self.sugarCalculation = self.foodProduct.foodSugars;
    
    if (self.calorieCalculation <= [NSNumber numberWithLong:400]) {
        self.calorieCalculationOutlet.text = @"Excellent Choice! 😀😊😊";
        NSLog(@"%@",self.calorieCalculation);
    }
    if(self.foodProduct.foodFats <= [NSNumber numberWithLong:10]){
        self.fatsCalculationOutlet.text = @"Excellent Choice!😀😊😊";
    }
    if(self.sugarCalculation <= [NSNumber numberWithLong:4]) {
        self.sugarsCalculationOutlet.text = @"Excellent Choice!😀😊😊";
    }
    if (self.carbMultiplier <= [NSNumber numberWithLong:20]) {
        self.carbCalculationOutlet.text = @"Excellent Choice!😀😊😊";
    }
   
}
    

@end
