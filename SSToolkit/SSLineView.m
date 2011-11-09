//
//  SSLineView.m
//  SSToolkit
//
//  Created by Sam Soffes on 4/12/10.
//  Copyright 2010-2011 Sam Soffes. All rights reserved.
//

#import "SSLineView.h"

@implementation SSLineView

@synthesize lineColor = _lineColor;
@synthesize insetColor = _insetColor;
@synthesize showInset = _showInset;

#pragma mark -
#pragma mark NSObject

- (void)dealloc {
	self.lineColor = nil;
	self.insetColor = nil;
}


#pragma mark -
#pragma mark UIView

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		self.lineColor = [UIColor grayColor];
		self.insetColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
		
		_showInset = YES;
	}
	return self;
}


- (void)drawRect:(CGRect)rect {	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextClipToRect(context, rect);

	// Inset
	if (self.showInset && self.insetColor) {
		CGContextSetLineWidth(context, rect.size.height/2);
		CGContextSetStrokeColorWithColor(context, _insetColor.CGColor);
		CGContextMoveToPoint(context, 0.0f, rect.size.height*3/4);
		CGContextAddLineToPoint(context, rect.size.width, rect.size.height*3/4);
		CGContextStrokePath(context);
	}
	
	// Top border
	if (!self.showInset)
		CGContextSetLineWidth(context, rect.size.height); // take full height in stroke if not showing inset
	else
		CGContextSetLineWidth(context, rect.size.height/2); // take full height in stroke if not showing inset
	CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
	if (!self.showInset) {
		CGContextMoveToPoint(context, 0.0f, rect.size.height/2);
		CGContextAddLineToPoint(context, rect.size.width, rect.size.height/2);
	}
	else {
		CGContextMoveToPoint(context, 0.0f, rect.size.height/4);
		CGContextAddLineToPoint(context, rect.size.width, rect.size.height/4);
	}
	CGContextStrokePath(context);
}


- (void)willMoveToSuperview:(UIView *)newSuperview {
	[super willMoveToSuperview:newSuperview];
	if (newSuperview && ![self observationInfo]) {
		[self addObserver:self forKeyPath:@"lineColor" options:NSKeyValueObservingOptionNew context:nil];
		[self addObserver:self forKeyPath:@"insetColor" options:NSKeyValueObservingOptionNew context:nil];
		[self addObserver:self forKeyPath:@"showInset" options:NSKeyValueObservingOptionNew context:nil];
		return;
	}
	
	if (!newSuperview && [self observationInfo]) {
		[self removeObserver:self forKeyPath:@"lineColor"];
		[self removeObserver:self forKeyPath:@"insetColor"];
		[self removeObserver:self forKeyPath:@"showInset"];
	}	
}


#pragma mark -
#pragma mark NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	// Redraw if colors changed
	if ([keyPath isEqualToString:@"lineColor"] || [keyPath isEqualToString:@"insetColor"] || [keyPath isEqualToString:@"showInset"]) {
		[self setNeedsDisplay];
		return;
	}
	
	[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

@end
