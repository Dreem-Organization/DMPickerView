//
//  DMPickerView.m
//  Dreem
//
//  Created by Olivier Tranzer on 17/10/15.
//  Copyright © 2015 Adrien. All rights reserved.
//

#import "DMPickerView.h"

#define kDefaultSpacing 30
#define kDefaultMinSizeScale 0.2
#define kDefaultSizeScaleRatio 1
#define kDefaultMinAlphaScale 0.2
#define kDefaultAlphaScaleRatio 1
#define kDefaultMinSizeScale 0.2

@interface DMPickerView()

// Views
@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) NSMutableArray *labels;
@property (nonatomic, strong) UILabel *currentLabel;
@property (nonatomic) CGFloat labelSize;
// Data
@property (nonatomic) NSUInteger index;

@end

@implementation DMPickerView {
    NSInteger previousIndex;
}

#pragma mark - Init

- (void)initialize {
    self.backgroundColor = [UIColor clearColor];
    
    // Scrollview
    self.scrollview = [UIScrollView new];
    self.scrollview.delegate = self;
    self.scrollview.backgroundColor = [UIColor clearColor];
    self.scrollview.showsHorizontalScrollIndicator = NO;
    self.scrollview.showsVerticalScrollIndicator = NO;
    self.scrollview.decelerationRate = UIScrollViewDecelerationRateFast;
    self.scrollview.scrollsToTop = NO;
    [self addSubview:self.scrollview];
    
    // Default property values
    self.orientation = VERTICAL;
    self.spacing = kDefaultSpacing;
    self.minSizeScale = kDefaultMinSizeScale;
    self.sizeScaleRatio = kDefaultSizeScaleRatio;
    self.minAlphaScale = kDefaultMinAlphaScale;
    self.alphaScaleRatio = kDefaultAlphaScaleRatio;
    self.shouldUpdateRenderingOnlyWhenSelected = NO;
    self.shouldSelect = YES;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self initialize];
    }
    return self;
}

#pragma mark - Dealloc

- (void)dealloc {
    self.scrollview.delegate = nil;
    self.scrollview = nil;
}

#pragma mark - Getter

- (NSUInteger)currentIndex {
    return self.index;
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Scrollview
    self.scrollview.frame = self.bounds;
    
    // Check if not empty frame
    if (CGRectGetWidth(self.bounds) <= 0 || CGRectGetHeight(self.bounds) <= 0) return;
    
    // Labels
    CGFloat currentX = CGRectGetWidth(self.bounds) / 2;
    CGFloat currentY = CGRectGetHeight(self.bounds) / 2;
    UILabel *selectedLabel = self.labels[self.index];
    [selectedLabel sizeToFit];
    CGFloat currentHeight = CGRectGetHeight(selectedLabel.frame);
    for (int i = 0 ; i < [self.labels count] ; i++) {
        UILabel *label = self.labels[i];
        [label sizeToFit];
        if (self.orientation == HORIZONTAL) {
            CGFloat y = CGRectGetMidY(self.bounds) - CGRectGetHeight(label.frame) / 2;
            CGFloat width = CGRectGetWidth(label.frame);
            CGFloat height = CGRectGetHeight(label.frame);
            label.frame = CGRectMake(currentX, y, width, height);
            currentX += CGRectGetWidth(label.frame) + self.spacing;
        } else {
            label.frame = CGRectMake(CGRectGetMidX(self.bounds) - CGRectGetWidth(label.frame) / 2,
                                     currentY,
                                     CGRectGetWidth(label.frame),
                                     currentHeight);
            currentY += CGRectGetHeight(label.frame) + self.spacing;
        }
    }
    
    // Update offset according to selected index
    if ([self.labels count] > 0) {
        UILabel *label = self.labels[self.index];
        if (self.orientation == HORIZONTAL) {
            CGPoint newContentOffset = CGPointMake(CGRectGetMidX(label.frame) - CGRectGetMidX(self.scrollview.frame), CGRectGetMinY(self.bounds));
            if (CGRectGetWidth(self.scrollview.frame) > 0) {
                [self.scrollview setContentOffset:newContentOffset animated:NO];
            }
        } else {
            CGPoint newContentOffset = CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMidY(label.frame) - CGRectGetMidY(self.scrollview.frame));
            if (CGRectGetHeight(self.scrollview.frame) > 0) {
                [self.scrollview setContentOffset:newContentOffset animated:NO];
            }
        }
    }
    
    self.labelSize = CGRectGetHeight(selectedLabel.bounds);
    
    // Update scrollview contentsize
    if (self.orientation == HORIZONTAL) {
        self.scrollview.contentSize = CGSizeMake(currentX + CGRectGetWidth(self.scrollview.bounds) / 2,
                                                 CGRectGetHeight(self.bounds));
    } else {
        self.scrollview.contentSize = CGSizeMake(CGRectGetWidth(self.bounds),
                                                 currentY + CGRectGetHeight(self.scrollview.bounds) / 2);
    }
    
    // Update alpha and scaling of labels
    [self updateViews];
    
}

#pragma mark - Reload data

- (void)reloadData {
    
    // Remove all scrollview's subviews
    for (UIView *subView in [self.scrollview subviews]) {
        [subView removeFromSuperview];
    }
    
    // Reinit array
    self.labels = [NSMutableArray array];
    // Get texts from datasource
    NSUInteger n = [self.datasource numberOfLabelsForPickerView:self];
    NSMutableArray *texts = [NSMutableArray array];
    for (int i = 0 ; i < n ; i++) {
        [texts addObject:[self.datasource valueLabelForPickerView:self AtIndex:i]];
    }
    
    // Set font
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:30];
    
    // Set color
    UIColor *textColor = [UIColor whiteColor];
    
    for (int i = 0 ; i < [texts count] ; i++) {
        
        if ([self.datasource respondsToSelector:@selector(fontForLabelsForPickerView:AtIndex:)]) {
            font = [self.datasource fontForLabelsForPickerView:self AtIndex:i];
        }
        
        if ([self.datasource respondsToSelector:@selector(textColorForLabelsForPickerView:AtIndex:)]) {
            textColor = [self.datasource textColorForLabelsForPickerView:self AtIndex:i];
        }
        
        // Create and customize label
        UILabel *label = [UILabel new];
        label.font = font;
        label.textColor = textColor;
        label.text = texts[i];
        label.tag = i;
        [label sizeToFit];
        // Gesture recognizer
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapLabel:)];
        [label addGestureRecognizer:tapGestureRecognizer];
        label.userInteractionEnabled = YES;
        // Add subview
        [self.scrollview addSubview:label];
        // Add label to property array
        [self.labels addObject:label];
    }
    
    // Reload layouts
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}

#pragma mark - Scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.shouldUpdateRenderingOnlyWhenSelected) [self updateViews];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) [self scrollToNearestNeighbour];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollToNearestNeighbour];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    // Notify delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:didSelectLabelAtIndex:userTriggered:)]) {
        [self.delegate pickerView:self didSelectLabelAtIndex:self.index userTriggered:YES];
    }
    
    // Update views if the option was selected
    if (self.shouldUpdateRenderingOnlyWhenSelected) {
        [self updateViews];
    }
}

#pragma mark - Scroll to neearest neighbour

/**
 Scroll to the nearest neighbour
 */
- (void)scrollToNearestNeighbour {
    
    CGPoint position = self.scrollview.contentOffset;
    // Compute the offset of the middle of the visible scroller
    CGFloat middlePosition;
    if (self.orientation == HORIZONTAL) {
        middlePosition = position.x + CGRectGetWidth(self.scrollview.bounds) / 2;
    } else {
        middlePosition = position.y + CGRectGetHeight(self.scrollview.bounds) / 2;
    }
    
    // Find nearest label
    CGFloat minDistance = MAX(self.scrollview.contentSize.width, self.scrollview.contentSize.height);
    UILabel *nearsetLabel = nil;
    NSUInteger index = -1;
    for (int i = 0 ; i < [self.labels count] ; i++) {
        UILabel *label = self.labels[i];
        // Calculate distance from middle
        CGFloat distanceFromMiddle;
        if (self.orientation == HORIZONTAL) {
            distanceFromMiddle = CGRectGetMidX(label.frame) - middlePosition;
            if (ABS(distanceFromMiddle) < ABS(minDistance)) {
                minDistance = distanceFromMiddle;
                nearsetLabel = label;
                index = i;
            }
        } else {
            distanceFromMiddle = CGRectGetMidY(label.frame) - middlePosition;
            if (ABS(distanceFromMiddle) < ABS(minDistance)) {
                minDistance = distanceFromMiddle;
                nearsetLabel = label;
                index = i;
            }
        }
    }
    
    // Move scroll
    if (self.orientation == HORIZONTAL) {
        CGPoint newContentOffset = CGPointMake(self.scrollview.contentOffset.x + minDistance, CGRectGetMinY(self.bounds));
        [self.scrollview setContentOffset:newContentOffset animated:YES];
    }
    else {
        CGPoint newContentOffset = CGPointMake(CGRectGetMinX(self.bounds), self.scrollview.contentOffset.y + minDistance);
        [self.scrollview setContentOffset:newContentOffset animated:YES];
    }
    // Update index
    self.index = index;
}

#pragma mark - Tap label

- (void)didTapLabel:(UITapGestureRecognizer *)recognizer {
    NSUInteger index = recognizer.view.tag;
    [self moveToIndex:index animated:YES];
}

#pragma mark - Move to index

/**
 Move to index
 */
- (void)moveToIndex:(NSUInteger)index animated:(BOOL)animated {
    UILabel *label = self.labels[index];
    if (self.orientation == HORIZONTAL) {
        CGPoint newContentOffset = CGPointMake(CGRectGetMidX(label.frame) - CGRectGetMidX(self.scrollview.frame), CGRectGetMinY(self.bounds));
        if (newContentOffset.x < self.scrollview.contentSize.width && CGRectGetWidth(self.scrollview.frame) > 0) {
            [self.scrollview setContentOffset:newContentOffset animated:animated];
        }
    } else {
        CGPoint newContentOffset = CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMidY(label.frame) - CGRectGetMidY(self.scrollview.frame));
        if (newContentOffset.y < self.scrollview.contentSize.height && CGRectGetHeight(self.scrollview.frame) > 0) {
            [self.scrollview setContentOffset:newContentOffset animated:animated];
        }
    }
    
    // Notify delegate
    self.index = index;
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:didSelectLabelAtIndex:userTriggered:)]) {
        [self.delegate pickerView:self didSelectLabelAtIndex:self.index userTriggered:animated];
    }
}

#pragma mark - Update views

/**
 Change scaling and alpha of labels depending on their distance to the center
 */
- (void)updateViews {
    CGPoint position = self.scrollview.contentOffset;
    
    if (self.orientation == HORIZONTAL) {
        // Compute the offset of the middle of the visible scroller
        CGFloat middlePosition = position.x + CGRectGetWidth(self.scrollview.bounds) / 2;
        
        // Transform
        for (UILabel *label in self.labels) {
            // Calculate distance from middle
            CGFloat distanceFromMiddle = ABS(CGRectGetMidX(label.frame) - middlePosition);
            
            // Scale according to this distance
            CGFloat sizeScale = MAX(1 - self.sizeScaleRatio * distanceFromMiddle/CGRectGetWidth(self.scrollview.bounds), self.minSizeScale);
            label.transform = CGAffineTransformScale(CGAffineTransformIdentity, sizeScale, sizeScale);
            
            // Change alpha according to distance
            CGFloat alphaScale = MAX(1 - self.alphaScaleRatio * distanceFromMiddle/CGRectGetWidth(self.scrollview.bounds), self.minAlphaScale);
            label.alpha = self.shouldSelect ? alphaScale : self.minAlphaScale;
        }
    } else {
        // Compute the offset of the middle of the visible scroller
        CGFloat middlePosition = position.y + CGRectGetHeight(self.scrollview.bounds) / 2;
        
        // Transform
        for (UILabel *label in self.labels) {
            // Calculate distance from middle
            CGFloat distanceFromMiddle = ABS(CGRectGetMidY(label.frame) - middlePosition);
            
            // Scale according to this distance
            CGFloat sizeScale = MAX(1 - self.sizeScaleRatio * distanceFromMiddle/CGRectGetHeight(self.scrollview.bounds), self.minSizeScale);
            label.transform = CGAffineTransformScale(CGAffineTransformIdentity, sizeScale, sizeScale);
            
            if (@available(iOS 10.0, *)) {
                if (label != _currentLabel) {
                    if (CGRectIntersectsRect(CGRectMake(0, CGRectGetMidY(self.scrollview.bounds) - (self.labelSize / 2), _scrollview.bounds.size.width, self.labelSize), CGRectMake(label.frame.origin.x, CGRectGetMidY(label.frame), CGRectGetWidth(label.bounds), 1))) {
                        UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator new] initWithStyle: UIImpactFeedbackStyleMedium];
                        [generator impactOccurred];
                        _currentLabel = label;
                    }
                }
            }
            
            // Change alpha according to distance
            CGFloat alphaScale = MAX(1 - self.alphaScaleRatio * distanceFromMiddle/CGRectGetHeight(self.scrollview.bounds), self.minAlphaScale);
            label.alpha = self.shouldSelect ? alphaScale : self.minAlphaScale;
        }
    }

    NSInteger currentIndex = [self findMiddleIndex];

    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:closestIndex:previousIndex:)]) {
        [self.delegate pickerView:self closestIndex:currentIndex previousIndex:previousIndex];
    }
    
    if (currentIndex != previousIndex) {
        previousIndex = currentIndex;
    }
}

- (NSInteger)findMiddleIndex {
    CGPoint position = self.scrollview.contentOffset;
    // Compute the offset of the middle of the visible scroller
    CGFloat middlePosition;
    if (self.orientation == HORIZONTAL) {
        middlePosition = position.x + CGRectGetWidth(self.scrollview.bounds) / 2;
    } else {
        middlePosition = position.y + CGRectGetHeight(self.scrollview.bounds) / 2;
    }
    
    // Find nearest label
    CGFloat minDistance = MAX(self.scrollview.contentSize.width, self.scrollview.contentSize.height);
    NSInteger index = -1;
    for (int i = 0 ; i < [self.labels count] ; i++) {
        UILabel *label = self.labels[i];
        // Calculate distance from middle
        CGFloat distanceFromMiddle;
        if (self.orientation == HORIZONTAL) {
            distanceFromMiddle = CGRectGetMidX(label.frame) - middlePosition;
            if (ABS(distanceFromMiddle) < ABS(minDistance)) {
                minDistance = distanceFromMiddle;
                index = i;
            }
        } else {
            distanceFromMiddle = CGRectGetMidY(label.frame) - middlePosition;
            if (ABS(distanceFromMiddle) < ABS(minDistance)) {
                minDistance = distanceFromMiddle;
                index = i;
            }
        }
    }
    return index;
}

@end

