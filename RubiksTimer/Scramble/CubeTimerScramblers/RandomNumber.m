//
//  RandomNumber.m
//  CubeTimer Scramblers

#import "RandomNumber.h"

BOOL isiOS5OrLater() {
    static int value = -1;
    if (value == -1) {
        value = (([[[UIDevice currentDevice] systemVersion] compare:@"5.0" options:NSNumericSearch] != NSOrderedAscending)) ? 1 : 0;
    }
    return (BOOL) value;
    

}

int randomnumber(int upperBound) {
    return (isiOS5OrLater() ? arc4random_uniform(upperBound) : arc4random() % (upperBound));
}