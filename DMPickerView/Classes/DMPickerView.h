//
//  DMPickerView.h
//  Dreem
//
//  Created by Olivier Tranzer on 17/10/15.
//  Copyright © 2015 Olivier Tranzer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    HORIZONTAL,
    VERTICAL
} Orientation;

@protocol DMPickerViewDatasource, DMPickerViewDelegate;

@interface DMPickerView : UIView<UIScrollViewDelegate>

// Customizable values
/**
 Orientation of the picker (vertical by default)
 */
@property (nonatomic) Orientation orientation;
/**
 Spacing between the elements. Default is 30.
 */
@property (nonatomic) CGFloat spacing;
/**
 Minimum scale of the label. Default is 0.2
 */
@property (nonatomic) CGFloat minSizeScale;
/**
 Ratio of the scale. If you increase this value the outer labels will look smaller
 */
@property (nonatomic) CGFloat sizeScaleRatio;
/**
 Minimum scale of the alpha. Default is 0.2
 */
@property (nonatomic) CGFloat minAlphaScale;
/**
 Ratio of the alpha. If you increase this value the outer labels will look dimmer
 */
@property (nonatomic) CGFloat alphaScaleRatio;
/**
 Define if the alpha and ratio should be applied always or only when selected. Default is NO
 */
@property (nonatomic) BOOL shouldUpdateRenderingOnlyWhenSelected;
/**
 Should select the middle label visually. only works if shouldUpdateRenderingOnlyWhenSelected is set to YES
 */
@property (nonatomic) BOOL shouldSelect;

/**
 Datasource
 */
@property (nonatomic, weak) id<DMPickerViewDatasource> datasource;

/**
 Delegate
 */
@property (nonatomic, weak) id<DMPickerViewDelegate> delegate;

/**
 Getter for current index
 */
- (NSUInteger)currentIndex;

/**
 Reload the picker view useing the data from the datasource
 */
- (void)reloadData;

/**
 Move the picker to the index
 */
- (void)moveToIndex:(NSUInteger)index animated:(BOOL)animated;

@end

@protocol DMPickerViewDatasource <NSObject>

@required

/**
 Number of labels to display
 */
- (NSUInteger)numberOfLabelsForPickerView:(DMPickerView *)pickerView;

/**
 String value for the label at the specific index
 */
- (NSString *)valueLabelForPickerView:(DMPickerView *)pickerView AtIndex:(NSUInteger)index;

@optional

/**
 Font for the labels
 */
- (UIFont *)fontForLabelsForPickerView:(DMPickerView *)pickerView AtIndex:(NSUInteger)index;

/**
 Text color for the labels
 */
- (UIColor *)textColorForLabelsForPickerView:(DMPickerView *)pickerView AtIndex:(NSUInteger)index;


@end

@protocol DMPickerViewDelegate <NSObject>

/**
 Selected a label.
 @param index Index of the label
 @param userTriggered The selection is triggered by the user
 */
- (void)pickerView:(DMPickerView *)pickerView didSelectLabelAtIndex:(NSUInteger)index userTriggered:(BOOL)userTriggered;
- (void)pickerView:(DMPickerView *)pickerView closestIndex:(NSInteger)closestIndex previousIndex:(NSInteger)previousIndex;

@end
