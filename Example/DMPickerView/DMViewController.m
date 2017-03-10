//
//  DMViewController.m
//  DMPickerView
//
//  Created by Olivier on 26/10/15.
//  Copyright © 2015 Olivier Tranzer. All rights reserved.
//

#import "DMViewController.h"

@interface DMViewController ()

// Values
@property (nonatomic, strong) NSArray *values;

// Views
@property (weak, nonatomic) IBOutlet DMPickerView *horizontalPickerView;
@property (weak, nonatomic) IBOutlet DMPickerView *verticalPickerView;

@end

@implementation DMViewController

#pragma mark - Init

- (id)init {
    self = [super init];
    if (self) {
        self.values = @[@"Richmond",
                        @"Kew Gardens",
                        @"Gunnersbury",
                        @"Ealing broadway",
                        @"Ealing Common",
                        @"Acton Town",
                        @"Chiswick Park",
                        @"Turnham Green",
                        @"Stamford Brook",
                        @"Ravenscourt Park",
                        @"Hammersmith",
                        @"Barons court",
                        @"West Kensington",
                        @"Wimbledon",
                        @"Wimbledon Park",
                        @"Southfields",
                        @"East Putney",
                        @"Puthney Bridge",
                        @"Parsons Green",
                        @"Fulham Broadway",
                        @"West Brompton",
                        @"Kensington (Olympia)",
                        @"Earl's Court",
                        @"High street Kensington",
                        @"Notting Hill Gate",
                        @"Bayswater",
                        @"Paddington",
                        @"Edgware Road",
                        @"Gloucester Road",
                        @"South Kensington",
                        @"Sloane Square",
                        @"Victoria",
                        @"St James' Park",
                        @"Westminster",
                        @"Embankment",
                        @"Temple",
                        @"Blackfriars",
                        @"Mansion House",
                        @"Cannon Street",
                        @"Monument",
                        @"Tower Hill",
                        @"Aldgate East",
                        @"Whitechapel",
                        @"Upminster"];
    }
    return self;
}

#pragma mark - View load/layout

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Horizontal picker
    self.horizontalPickerView.datasource = self;
    self.horizontalPickerView.delegate = self;
    self.horizontalPickerView.sizeScaleRatio = 1;
    self.horizontalPickerView.minSizeScale = 1;
    self.horizontalPickerView.alphaScaleRatio = 30;
    self.horizontalPickerView.minAlphaScale = 0.3;
    self.horizontalPickerView.spacing = 30;
    self.horizontalPickerView.shouldSelect = NO;
    self.horizontalPickerView.shouldUpdateRenderingOnlyWhenSelected = YES;
    self.horizontalPickerView.orientation = HORIZONTAL;
    [self.horizontalPickerView moveToIndex:6 animated:NO];
    [self.horizontalPickerView reloadData];
    
    // Vertical picker
    self.verticalPickerView.datasource = self;
    self.verticalPickerView.delegate = self;
    self.verticalPickerView.sizeScaleRatio = 1;
    self.verticalPickerView.minSizeScale = 0.2;
    self.verticalPickerView.alphaScaleRatio = 1;
    self.verticalPickerView.minAlphaScale = 0.3;
    self.verticalPickerView.spacing = 20;
    self.verticalPickerView.shouldUpdateRenderingOnlyWhenSelected = NO;
    self.verticalPickerView.orientation = VERTICAL;
    [self.verticalPickerView moveToIndex:3 animated:NO];
    [self.verticalPickerView reloadData];
    
}

#pragma mark - DMPickerview datasource

- (NSUInteger)numberOfLabelsForPickerView:(DMPickerView *)pickerView {
    return [self.values count];
}

- (NSString *)valueLabelForPickerView:(DMPickerView *)pickerView AtIndex:(NSUInteger)index {
    return self.values[index];
}

- (UIFont *)fontForLabelsForPickerView:(DMPickerView *)pickerView {
    return [UIFont fontWithName:@"Helvetica-Light" size:20];
}

- (UIColor *)textColorForLabelsForPickerView:(DMPickerView *)pickerView {
    return [UIColor blackColor];
}

#pragma mark - DMPickerview delegate

- (void)pickerView:(DMPickerView *)pickerView didSelectLabelAtIndex:(NSUInteger)index userTriggered:(BOOL)userTriggered {
    if ([pickerView isEqual:self.horizontalPickerView]) {
        self.horizontalPickerView.shouldSelect = userTriggered;
        NSLog(@"Horizontal current index: %lu", (unsigned long)self.horizontalPickerView.currentIndex);
    } else {
        NSLog(@"Vertical current index: %lu", (unsigned long)self.verticalPickerView.currentIndex);
    }
}

@end
