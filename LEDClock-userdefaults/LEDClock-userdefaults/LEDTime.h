//
//  LEDTime.h
//  LEDclock - save to file
//
//  Created by Emiko Clark on 1/8/16.
//  Copyright © 2016 Emiko Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEDTime : NSObject <NSCoding>

@property  (nonatomic) NSDate *currentTime;
@property  (nonatomic) NSDate *destinationTime;
@property  (nonatomic) NSInteger destinationGMTOffset;

@property (nonatomic) NSCalendar * gregorian;
@property (nonatomic) NSDateComponents *components;

// properties to encode and archive
@property (nonatomic) NSData   * NSDbackgroundColor;
@property (nonatomic) UIColor  * UIbackgroundColor;
@property (nonatomic) NSData   * NSDfontColor;
@property  (nonatomic)UIColor  * UIfontColor;
@property (nonatomic) NSString * backgroundFontButtonSetting;
@property (nonatomic) NSString * timeFormat;
@property (nonatomic) NSString * timeZone;


//values of time to set individual digits
@property (nonatomic) int hours;
@property (nonatomic) int minutes;
@property (nonatomic) int seconds;
@property (nonatomic) int hour1;
@property (nonatomic) int hour2;
@property (nonatomic) int minute1;
@property (nonatomic) int minute2;
@property (nonatomic) int second1;
@property (nonatomic) int second2;
@property (nonatomic) NSString *ampm;

-(id) initWithValues;
-(void) setTime;
-(void) updateMinutes;
-(void) updateSeconds;
-(void) encodeWithCoder:(NSCoder *)coder;
-(id) initWithCoder:(NSCoder *)decoder;


@end