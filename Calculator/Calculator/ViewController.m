//
//  ViewController.m
//  Calculator
//
//  Created by Daniel Honig on 8/27/12.
//  Copyright (c) 2012 Daniel Honig. All rights reserved.
//

#import "ViewController.h"
#import "CalculatorBrain.h"

@interface ViewController ()

@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong)CalculatorBrain *brain;
@property (nonatomic, strong)NSMutableArray *history;

@end

@implementation ViewController

@synthesize display;
@synthesize historyDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;
@synthesize history = _history;

#define kHistoryCapacity 10

-(CalculatorBrain *)brain
{
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

-(NSMutableArray *)history
{
    if(!_history) _history = [[NSMutableArray alloc] initWithCapacity:kHistoryCapacity];
    return _history;
}

- (IBAction)digitPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        if (![@"0" isEqualToString:self.display.text]) 
            self.display.text = [self.display.text stringByAppendingString:[sender currentTitle]];
        else 
            self.display.text = [sender currentTitle];
        
    } else {
        self.userIsInTheMiddleOfEnteringANumber = YES;
        self.display.text = [sender currentTitle];
    }
}

- (IBAction)enterPressed {

    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    
    NSAssert(self.history.count <= kHistoryCapacity,
             @"Error: Too many history elements");
    
    if(self.history.count == kHistoryCapacity)
        [self.history removeObjectAtIndex:0];
    
    //display pi & e properly
    if([self.display.text isEqualToString:@"3.14159"])
        [self.history addObject:@"π"];
    else if([self.display.text isEqualToString:@"2.71828"])
        [self.history addObject:@"e"];
    else
        [self.history addObject:self.display.text];
    
    self.historyDisplay.text = [self.history componentsJoinedByString:@" "];
}

- (IBAction)operationPressed:(UIButton *)sender {
    if(self.userIsInTheMiddleOfEnteringANumber)
        [self enterPressed];
    
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperand:operation];
    if(result)
    self.display.text = [NSString stringWithFormat:@"%g", result];
    
    NSAssert(self.history.count <= kHistoryCapacity,
             @"Error: Too many history elements");
    
    if(self.history.count == kHistoryCapacity)
        [self.history removeObjectAtIndex:0];
    
    //don't add to history for pi & e
    if(![operation isEqualToString:@"π"] &&![operation isEqualToString:@"e"])
        [self.history addObject: sender.currentTitle];
    
    self.historyDisplay.text = [[self.history componentsJoinedByString:@" "]stringByAppendingString:@" ="];
}

- (IBAction)dotPressed {
    if (!self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = @"0.";
        self.userIsInTheMiddleOfEnteringANumber = YES;
    } else {
        NSRange range = [self.display.text rangeOfString:@"." options:NSCaseInsensitiveSearch];
        if (range.location == NSNotFound) 
            self.display.text = [self.display.text stringByAppendingString:@"."];
    }
}

- (IBAction)backPress {
    if(self.userIsInTheMiddleOfEnteringANumber)
    {
        if(self.display.text.length > 0)
        {
            NSString *displayString = self.display.text;

            displayString = [displayString substringToIndex:[displayString length] -1];
            
            self.display.text = displayString;
            
            if(self.display.text.length == 0)
            {
                self.display.text = @"0";
                self.userIsInTheMiddleOfEnteringANumber = NO;
            }
        }
        else
        {
            [self clearPressed];
            self.userIsInTheMiddleOfEnteringANumber = NO;
        }
    }
    else
    {
        self.display.text = @"0";
    }
}

- (IBAction)clearPressed {
    [self.brain clear];
    self.history = nil;
    self.display.text = @"0";
    self.historyDisplay.text = @" ";
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (void)viewDidUnload {
    [self setHistory:nil];
    [self setHistoryDisplay:nil];
    [super viewDidUnload];
}
@end
