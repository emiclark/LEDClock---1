//
//  LEDTime.m
//  LEDclock - save to file
//
//  Created by Emiko Clark on 1/8/16.
//  Copyright © 2016 Emiko Clark. All rights reserved.
//

#import "LEDTime.h"
#import <Foundation/NSDate.h>
#import <CoreFoundation/CFRunLoop.h>

@implementation LEDTime


-(id) initWithValues{
    //initialize variables with default values
    
    if ( self = [super init] ) {
        
        //set backgroundColor
        _UIbackgroundColor = [UIColor colorWithRed:[@"253" floatValue]/255.0
                                             green:[@"250" floatValue]/255.0
                                              blue:[@"253" floatValue]/255.0
                                             alpha:1.0];
        //  UIColor->NSData
        _NSDbackgroundColor = [NSKeyedArchiver archivedDataWithRootObject:_UIbackgroundColor];
        
        // set fontColor
        _UIfontColor = [UIColor colorWithRed:[@"51" floatValue]/255.0
                                       green:[@"102" floatValue]/255.0
                                        blue:[@"178" floatValue]/255.0
                                       alpha:1.0];
        //  UIColor->NSData
        _NSDfontColor = [NSKeyedArchiver archivedDataWithRootObject:_UIfontColor];
        
        NSLog(@"initWithValues: NSDb%@, NSDf%@\nUIb:%@, UIf:%@",_NSDbackgroundColor,_NSDfontColor, _UIbackgroundColor,_UIfontColor );
        
        _backgroundFontButtonSetting = @"0";
        _timeFormat = @"12hr";
        _timeZone = @"EST";
    }
    return self;
}

-(void) setTime{
    
    //check and set time format
    _gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [_gregorian setTimeZone:[NSTimeZone timeZoneWithName:_timeZone]];
    _components = [_gregorian components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:_currentTime];
    
    _hours = (int)[_components hour];
    _minutes = (int)[_components minute];
    _seconds = (int)[_components second];
    
    
    _second1 = _seconds%100/10;
    _second2 = _seconds%10;
    _minute1 = _minutes%100/10;
    _minute2 = _minutes%10;
    
    //set hour1 and hour2 digits to component.hour for 12hr & 24hr format
    if ([_timeFormat isEqualToString: @"12hr"]) {
        
        if (_components.hour == 0) {
            _components.hour = 12;
            _hour1 = _components.hour%100/10;
            _hour2 = _components.hour%10;
            _ampm = @"AM";
        } else if (_components.hour == 12){
            _hour1 = _components.hour%100/10;
            _hour2 = _components.hour%10;
            _ampm = @"PM";
        } else if (_components.hour >= 0 && _components.hour<=12 ) {
            _hour1 = _components.hour%100/10;
            _hour2 = _components.hour%10;
            _ampm = @"AM";
        } else if (_components.hour >= 12 && _components.hour <= 24) {
            _hour1 = (_components.hour-12)%100/10;
            _hour2 = (_components.hour-12)%10;
            _ampm = @"PM";
        }
        
    } else if ([_timeFormat isEqualToString: @"24hr"]) {
        // Set time format to 24hr
        _hour1 = _components.hour%100/10;
        _hour2 = _components.hour%10;
        
        _ampm = @"";
        
    }
    
    NSLog(@"setTime: [%d:%d:%i]   %i %i : %i %i : %i %i : ampm:%@ ", _hours, _minutes, _seconds, _hour1,_hour2, _minute1, _minute2, _second1, _second2, _ampm);
}

-(void) updateMinutes{
    NSDate * destinationTime = [[NSDate alloc] initWithTimeIntervalSinceNow:_destinationGMTOffset];
    _currentTime =  destinationTime;
    _components = [_gregorian components: NSCalendarUnitMinute fromDate:_currentTime];
    _minutes = (int)[_components minute];
    _minute1 = _minutes%100/10;
    _minute2 = _minutes%10;
    
}
-(void) updateSeconds{
    NSDate * destinationTime = [[NSDate alloc] initWithTimeIntervalSinceNow:_destinationGMTOffset];
    _currentTime =  destinationTime;
    _components = [_gregorian components: NSCalendarUnitSecond fromDate:_currentTime];
    _seconds = (int)[_components second];
    _second1 = _seconds%100/10;
    _second2 = _seconds%10;
    NSLog(@"updateSeconds: [%d:%d:%i]   %i %i : %i %i : %i %i : ampm:%@ ", _hours, _minutes, _seconds, _hour1,_hour2, _minute1, _minute2, _second1, _second2, _ampm);
}

-(void) encodeWithCoder:(NSCoder *)coder{
    
    [coder encodeObject:self.NSDbackgroundColor forKey:@"NSDbackgroundColor"];
    //    [coder encodeObject:self.UIbackgroundColor forKey:@"UIbackgroundColor"];
    //    [coder encodeObject:self.UIfontColor forKey:@"UIfontColor"];
    [coder encodeObject:self.NSDfontColor forKey:@"NSDfontColor"];
    [coder encodeObject:self.backgroundFontButtonSetting forKey:@"backgroundFontButtonSetting"];
    [coder encodeObject:self.timeFormat forKey:@"timeFormat"];
    [coder encodeObject:self.timeZone forKey:@"timeZone"];
    
}

-(id) initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.NSDbackgroundColor  = [decoder decodeObjectForKey:@"NSDbackgroundColor"];
    //    self.UIbackgroundColor  = [decoder decodeObjectForKey:@"UIbackgroundColor"];
    //    self.UIfontColor = [decoder decodeObjectForKey:@"UIfontColor" ];
    self.NSDfontColor = [decoder decodeObjectForKey:@"NSDfontColor" ];
    self.backgroundFontButtonSetting = [decoder decodeObjectForKey:@"backgroundFontButtonSetting" ];
    self.timeFormat = [decoder decodeObjectForKey:@"timeFormat"];
    self.timeZone = [decoder decodeObjectForKey:@"timeZone"];
    return self;
}


@end

