//
//  RubiksTimerCustomPickerView.h
//  RubiksTimer
//
//  Created by Jichao Li on 5/28/12.
//  Copyright (c) 2012 Sufflok University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RubiksTimerCustomPickerView : UIAlertView  <UIPickerViewDataSource, UIPickerViewDelegate> 
{  
    NSDictionary *scrType;
    NSArray *types;  
    NSArray *subsets;  
    UIPickerView *selectPicker;  
    int selectedType;  
    int selectedSubset;  
}  

@property (nonatomic) NSString *chooseType;
@property (nonatomic) NSString *chooseSubsets;

@end
