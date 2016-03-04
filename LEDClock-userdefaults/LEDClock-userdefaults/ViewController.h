//
//  ViewController.h
//  LEDclock - save to file
//
//  Created by Emiko Clark on 1/8/16.
//  Copyright © 2016 Emiko Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/NSDate.h>
#import "LEDTime.h"

@interface ViewController : UIViewController <NSCoding>

@property (nonatomic) LEDTime *ledTime;
@property (nonatomic) UIColor *currentColor;
@property (nonatomic) NSMutableDictionary *mySettings;


-(void)updateHour1;
-(void)updateHour2;
-(void)updateMinute1;
-(void)updateMinute2;
-(void)updateSecond1;
-(void)updateSecond2;
-(void)updateSeparator;

-(void)updateView;
-(void)updateTheHours;
-(void)updateTheMinutes;
-(void)updateTheSeconds;
-(void) updateAmpmLabel;
-(void)changeFontColor;

-(void) saveSettings;
-(void) loadSettings;


@end