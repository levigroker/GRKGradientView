//
//  GRKGradientView.m
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

#import "GRKGradientView.h"

@interface GRKGradientView ()

//Tell ARC that it should manage this CF pointer for us
//See: http://stackoverflow.com/a/16022585/397210
@property (nonatomic,strong) __attribute__((NSObject)) CGGradientRef gradient;

@end

@implementation GRKGradientView

#ifdef __IPHONE_7_0
@synthesize gradientColorsDimmed = _gradientColorsDimmed;
#endif

#pragma mark - Lifecycle

- (void)dealloc
{
    self.gradient = NULL;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.contentMode = UIViewContentModeRedraw;
}

#pragma mark - Accessors

- (void)setGradientColors:(NSArray *)gradientColors
{
	_gradientColors = gradientColors;
	[self updateGradient];
}

- (void)setGradientLocations:(NSArray *)gradientLocations
{
	_gradientLocations = gradientLocations;
	[self updateGradient];
}

- (void)setGradientOrientation:(GRKGradientOrientation)gradientOrientation
{
	_gradientOrientation = gradientOrientation;
	[self setNeedsDisplay];
}


#ifdef __IPHONE_7_0
- (NSArray *)gradientColorsDimmed
{
	if (!_gradientColorsDimmed)
    {
		NSMutableArray *dimmed = [self.gradientColors mutableCopy];
		[dimmed enumerateObjectsUsingBlock:^(UIColor *color, NSUInteger index, BOOL *stop) {
			CGFloat hue, saturation, brightness, alpha;
			[color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
			[dimmed replaceObjectAtIndex:index withObject:[UIColor colorWithHue:hue saturation:0.0f brightness:brightness alpha:alpha]];
		}];
		return dimmed;
	}

	return _gradientColorsDimmed;
}

- (void)setGradientColorsDimmed:(NSArray *)gradientColorsDimmed
{
	_gradientColorsDimmed = gradientColorsDimmed;
    [self updateGradient];
}

#endif
#pragma mark - Overrides

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
    
	if (self.gradient)
    {
		CGPoint start, end;
        [self gradientStartPoint:&start endPoint:&end forOrientation:self.gradientOrientation];
        
		CGContextDrawLinearGradient(context, self.gradient, start, end, kNilOptions);
	}
}

#ifdef __IPHONE_7_0
- (void)tintColorDidChange
{
    [super tintColorDidChange];
	[self updateGradient];
}
#endif

#pragma mark - Implementation

#pragma mark Orientation

- (void)gradientStartPoint:(CGPoint *)start endPoint:(CGPoint *)end forOrientation:(GRKGradientOrientation)orientation
{
    if (start != NULL && end != NULL)
    {
        *start = CGPointZero;
        *end = CGPointZero;
        CGSize size = self.bounds.size;
        
        switch (self.gradientOrientation) {
            case GRKGradientOrientationRight:
                start->x = size.width;
                break;
            case GRKGradientOrientationLeft:
                end->x = size.width;
                break;
            case GRKGradientOrientationUp:
                start->y = size.height;
                break;
            case GRKGradientOrientationDown:
            default:
                end->y = size.height;
                break;
        }
    }
}

#pragma mark Gradient

- (void)updateGradient
{
    NSArray *colors = self.gradientColors;
    NSArray *locations = self.gradientLocations;
    
#ifdef __IPHONE_7_0
    //Handle dimmed colors for iOS 7+
	if ([self respondsToSelector:@selector(tintAdjustmentMode)] && self.tintAdjustmentMode == UIViewTintAdjustmentModeDimmed)
    {
        colors = self.gradientColorsDimmed;
        
        if (self.gradientColorsDimmed.count != locations.count)
        {
            locations = nil;
        }
	}
#endif
    
    //Create our new gradient (with a +1 retain count)
    CGGradientRef newGradient = [self newGradientWithColors:colors andLocations:locations];
    //Assign the new gradient to our property, letting ARC handle the future management
    self.gradient = newGradient;
    //Release the new gradient, since ARC is handling it now.
    CGGradientRelease(newGradient);
    
    //Now that we have a new gradient, we need to redraw
    [self setNeedsDisplay];
}

//Creates a new gradient with the given colors and locations.
//This returns a CGGradientRef with a retain count of +1, so should be released
- (CGGradientRef)newGradientWithColors:(NSArray *)colors andLocations:(NSArray *)locations
{
    CGGradientRef retVal = NULL;
    
    NSUInteger numColors = colors.count;
	if (numColors >= 2)
    {
        //Create a primitive array of CGFloats for the gradient locations, if we have them.
        CGFloat *gradientLocations = NULL;
        
        NSUInteger numLocations = locations.count;
        if (numLocations == numColors)
        {
            gradientLocations = (CGFloat *)malloc(sizeof(CGFloat) * numLocations);
            if (gradientLocations)
            {
                [locations enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
                    gradientLocations[index] = [object floatValue];
                }];
            }
        }
        
        CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors objectAtIndex:0] CGColor]);
        //Get all the CGColors from the UIColor objects
        NSMutableArray *cgColors = [NSMutableArray arrayWithCapacity:numColors];
        [colors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CGColorRef colorRef = [obj CGColor];
            [cgColors addObject:(__bridge id)colorRef];
        }];

        retVal = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)cgColors, gradientLocations);
        
        //Free up our malloc'd primitive array
        if (gradientLocations)
        {
            free(gradientLocations);
        }
    }
    
	return retVal;
}

@end
