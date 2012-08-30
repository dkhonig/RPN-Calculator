//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Daniel Honig on 8/27/12.
//  Copyright (c) 2012 Daniel Honig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject
    -(void)pushOperand:(double)operand;
    -(double)popOperand;
    -(double)performOperand:(NSString *)operation;
    -(void)clear;
@end
