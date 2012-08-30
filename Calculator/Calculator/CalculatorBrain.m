//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Daniel Honig on 8/27/12.
//  Copyright (c) 2012 Daniel Honig. All rights reserved.
//

#import "CalculatorBrain.h"
@interface CalculatorBrain()

@property (nonatomic, strong)NSMutableArray *operandStack;
    
@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

-(NSMutableArray *)operandStack
{
    if(!_operandStack)
        _operandStack = [[NSMutableArray alloc] init];
    
    return _operandStack;
}

-(void) pushOperand:(double)operand
{
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.operandStack addObject:operandObject];
}

-(double)popOperand
{
    NSNumber *operandObject = [self.operandStack lastObject];
    if(operandObject)[self.operandStack removeLastObject];
    return [operandObject doubleValue];
}

-(double)performOperand:(NSString *)operation
{
    double result = 0;
    
    if([operation isEqualToString:@"+"])
    {
        result = [self popOperand] + [self popOperand];
    }
    else if ([operation isEqualToString:@"*"])
    {
        result = [self popOperand] * [self popOperand];
    }
    else if([operation isEqualToString:@"-"])
    {
        double subtrhend = [self popOperand];
        result = [self popOperand] - subtrhend;
    }
    else if([operation isEqualToString:@"/"])
    {
        double divisor = [self popOperand];
        if(divisor) result = [self popOperand] / divisor;
    }
    else if([operation isEqualToString:@"sin"])
    {
        double operand = [self popOperand];
        operand = (operand * M_PI/180); //convert to radians
        result = sin(operand);
    }
    else if([operation isEqualToString:@"cos"])
    {
        double operand = [self popOperand];
        operand = (operand * M_PI/180); //convert to radians
        result = cos(operand);
    }
    else if([operation isEqualToString:@"sqrt"])
    {
        double operand = [self popOperand];
        result = operand * operand;
    }
    else if([operation isEqualToString:@"π"])
    {
        result = M_PI;
    }
    else if([operation isEqualToString:@"+/-"])
    {
        result = (-1.0)*[self popOperand];
    }
    else if ([operation isEqualToString:@"log"]) {
        result = log([self popOperand]);
    }
    else if([operation isEqualToString:@"e"])
    {
        result = M_E;
    }
    
    [self pushOperand:result];
    
    return result;
}

-(void)clear
{
    self.operandStack = nil;
}

@end
