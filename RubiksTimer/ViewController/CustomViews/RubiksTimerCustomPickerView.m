//
//  RubiksTimerCustomPickerView.m
//  RubiksTimer
//
//  Created by Jichao Li on 5/28/12.
//  Copyright (c) 2012 Sufflok University. All rights reserved.
//

#import "RubiksTimerCustomPickerView.h"
#define componentCount 2  
#define typeComponent 0  
#define subsetComponent 1  
#define typeComponentWidth 110  
#define subsetComponentWidth 120 


@implementation RubiksTimerCustomPickerView

@synthesize chooseType;
@synthesize chooseSubsets;


- (id)initWithFrame:(CGRect)frame {  
    self.chooseType = @"2x2";
    self.chooseSubsets = @"random state";
    if (self = [super initWithFrame:frame]) {
        NSLog(@"asdads");
        NSBundle *bundle = [NSBundle mainBundle];
        NSURL *plistURL = [bundle URLForResource:@"scrambleTypes" withExtension:@"plist"];
        NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfURL:plistURL];
        scrType = dictionary;  
        types = [scrType allKeys];              
        types= [types sortedArrayUsingSelector:@selector(compare:)]; 
        NSString *select = [types objectAtIndex:0];
        subsets = [scrType objectForKey:select];
        selectPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];  
        selectPicker.showsSelectionIndicator = YES;  
        selectPicker.delegate = self;  
        selectPicker.dataSource = self;          
        selectPicker.opaque = YES;  
    }  
    return self;  
}          

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {  
    return componentCount;  
}  

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {  
    if (component == typeComponent) {  
        return [types count];  
    } else {  
        return [subsets count];  
    }  
}  

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {  
    UILabel *printString;  
    if (component == typeComponent) {  
        printString = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, typeComponentWidth, 45)];  
        printString.text = [types objectAtIndex:row];  
        //[printString setFont:[UIFont fontWithName:@"Georgia" size:12.0f]];  
    } else {  
        printString = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, subsetComponentWidth, 45)];  
        printString.text = [subsets objectAtIndex:row];  
    }  
    printString.backgroundColor = [UIColor clearColor];  
    printString.textAlignment = UITextAlignmentCenter;  
    
    return printString;  
}  

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {  
    return 45.0;  
}  

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {  
    if (component == typeComponent) {  
        return typeComponentWidth;  
    } else {  
        return subsetComponentWidth;  
    }  
}  

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {     
    if (component == typeComponent) {
        NSString *selType = [types objectAtIndex:row];
        NSArray *array = [scrType objectForKey:selType];
        subsets = array;
        [pickerView selectRow:0 inComponent:subsetComponent animated:YES];
        [pickerView reloadComponent:subsetComponent];
    }
    
    selectedType = [pickerView selectedRowInComponent:typeComponent];  
    selectedSubset = [pickerView selectedRowInComponent:subsetComponent]; 
    self.chooseType = [types objectAtIndex:selectedType];
    self.chooseSubsets = [subsets objectAtIndex:selectedSubset];
}      

- (void)setFrame:(CGRect)rect {   
    [super setFrame:CGRectMake(0, 0, rect.size.width, 330)];  
    CGRect tScreenBounds = [[UIScreen mainScreen] applicationFrame];
    if (tScreenBounds.size.height == 1024) {
        self.center = CGPointMake(tScreenBounds.size.height/2, tScreenBounds.size.width/2); 
    }
    else {
        self.center = CGPointMake(tScreenBounds.size.width/2, tScreenBounds.size.height/2); 
    }
    
    selectPicker.frame = CGRectMake(15, 45, self.frame.size.width - 30, self.frame.size.height - 50);       
    for (UIView *view in self.subviews) { 
        //NSLog(@"%@", [[view class] description]);
        if ([[[view class] description] isEqualToString:@"UIAlertButton"]) {  
            view.frame = CGRectMake(view.frame.origin.x, self.bounds.size.height - view.frame.size.height - 15, view.frame.size.width, view.frame.size.height);  
        }  
    } 
    
    [self addSubview:selectPicker];   
    
}  
/*
- (void)layoutSubviews {     
    selectPicker.frame = CGRectMake(15, 45, self.frame.size.width - 30, self.frame.size.height - 50);       
    for (UIView *view in self.subviews) { 
        NSLog(@"%@", [[view class] description]);
        if ([[[view class] description] isEqualToString:@"UIAlertButton"]) {  
            view.frame = CGRectMake(view.frame.origin.x, self.bounds.size.height - view.frame.size.height - 15, view.frame.size.width, view.frame.size.height);  
        }  
    } 
}  
*/

@end
