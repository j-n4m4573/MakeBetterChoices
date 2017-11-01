//
//  ProductDetailViewController.m
//  MakeBetterChoices
//
//  Created by Jamar Gibbs on 6/5/16.
//  Copyright © 2016 B3773R. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "NutritionDetailViewController.h"
#import "FoodProduct.h"

@interface ProductDetailViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *productImageOutlet;
@property (weak, nonatomic) IBOutlet UITextView *productNameOutlet;
@property (weak, nonatomic) IBOutlet UITextView *productBrandOutlet;
@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self setWebviewImage];
}
-(void)setWebviewImage {
    NSString *urlString = self.productDetails.image;
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *requestPage = [NSURLRequest requestWithURL:url];
    [self.productImageOutlet loadRequest:requestPage];
    
    self.productNameOutlet.text = self.productDetails.name;
    self.productBrandOutlet.text = self.productDetails.brand;
    self.navigationItem.title = self.productDetails.name; 
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NutritionDetailViewController *foodDetails = [segue destinationViewController];
    foodDetails.foodProductDetails = self.productDetails;
}

@end
