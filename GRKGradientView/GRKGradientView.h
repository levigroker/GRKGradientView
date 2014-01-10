//
//  GRKGradientView.h
//
//  Created by Levi Brown on 9/4/13.
//  Copyright (c) 2013 Levi Brown <mailto:levigroker@gmail.com>
//  This work is licensed under the Creative Commons Attribution 3.0
//  Unported License. To view a copy of this license, visit
//  http://creativecommons.org/licenses/by/3.0/ or send a letter to Creative
//  Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041,
//  USA.
//
//  The above attribution and the included license must accompany any version
//  of the source code. Visible attribution in any binary distributable
//  including this work (or derivatives) is not required, but would be
//  appreciated.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GRKGradientOrientation) {
    GRKGradientOrientationDown = 0,
    GRKGradientOrientationUp,
    GRKGradientOrientationRight,
    GRKGradientOrientationLeft
};

@interface GRKGradientView : UIView

/**
 The `UIColor` objects to use in the gradient.
 At least two colors should be supplied, or no gradient can be applied.
 */
@property (nonatomic,copy) NSArray *gradientColors;
/**
 The locations to use for the specified gradient colors. This is an array of `NSNumber` objects which will be converted to CGFloats.
 If not specified, the colors in `gradientColors` will be spaced at regular intervals over the size of this view.
 If specified, this array should specify the same number of elements as `gradientColors`.
 */
@property (nonatomic,copy) NSArray *gradientLocations;
/**
 The `UIColor`s to use in the gradient when the view is dimmed due to a `tintColorDidChange` call from iOS 7+.
 If not specified, the `gradientColors` will be desaturated and used in this case.
 */
@property (nonatomic,copy) NSArray *gradientColorsDimmed;
/**
 The locations to use for the specified dimmed gradient colors. This is an array of `NSNumber` objects which will be converted to CGFloats.
 If not specified, the colors in `gradientColorsDimmed` will be spaced at regular intervals over the size of this view.
 If specified, this array should specify the same number of elements as `gradientColorsDimmed`.
 */
@property (nonatomic,copy) NSArray *gradientLocationsDimmed;
/**
 The orientation to with which the gradient is drawn.
 Defaults to `GRKGradientOrientationDown`
 */
@property (nonatomic,assign) GRKGradientOrientation gradientOrientation;

///
/// @name For subclasses to override as needed.
///

/**
 Generate the start and end points for the gradient to be drawn with, given the desired gradient orientation.
 @param start A pointer to a `CGPoint` struct to be populated with the desired starting position of the gradient. This should be relative to the bounds of this view.
 @param end A pointer to a `CGPoint` struct to be populated with the desired ending position of the gradient. This should be relative to the bounds of this view.
 @param orientation The requested orientation for the returned start and end points to represent.
 */
- (void)gradientStartPoint:(CGPoint *)start endPoint:(CGPoint *)end forOrientation:(GRKGradientOrientation)orientation;

/**
 Update the internal gradient reference. This is (and should be) called after any change which causes a need to re-generate the gradient and redraw.
 @see newGradientWithColors:andLocations:
 */
- (void)updateGradient;

/**
 Creates a new gradient with the given colors and locations.
 This is called by `updateGradient`.
 @param colors An `NSArray` defining the colors of the gradient.
 @param locations An `NSArray` defining the locations of the colors of the gradient. This array should be the same length as `colors`, or `nil`.
 @return A `CGGradientRef` with a retain count of +1
 @see updateGradient
 */
- (CGGradientRef)newGradientWithColors:(NSArray *)colors andLocations:(NSArray *)locations;

@end
