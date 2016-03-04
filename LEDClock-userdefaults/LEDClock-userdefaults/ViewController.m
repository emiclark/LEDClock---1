//
//  ViewController.m
//  LEDclock - save to file
//
//  Created by Emiko Clark on 1/8/16.
//  Copyright © 2016 Emiko Clark. All rights reserved.
//

#import "ViewController.h"
#import <Foundation/NSDate.h>
#import <CoreFoundation/CFRunLoop.h>
#import <CoreImage/CoreImage.h>
#import "LEDTime.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIView *h11;
@property (strong, nonatomic) IBOutlet UIView *h12;
@property (strong, nonatomic) IBOutlet UIView *h13;
@property (strong, nonatomic) IBOutlet UIView *h14;
@property (strong, nonatomic) IBOutlet UIView *h15;
@property (strong, nonatomic) IBOutlet UIView *h16;
@property (strong, nonatomic) IBOutlet UIView *h17;
@property (strong, nonatomic) IBOutlet UIView *h21;
@property (strong, nonatomic) IBOutlet UIView *h22;
@property (strong, nonatomic) IBOutlet UIView *h23;
@property (strong, nonatomic) IBOutlet UIView *h24;
@property (strong, nonatomic) IBOutlet UIView *h25;
@property (strong, nonatomic) IBOutlet UIView *h26;
@property (strong, nonatomic) IBOutlet UIView *h27;

@property (strong, nonatomic) IBOutlet UIView *separator1;

@property (strong, nonatomic) IBOutlet UIView *m11;
@property (strong, nonatomic) IBOutlet UIView *m12;
@property (strong, nonatomic) IBOutlet UIView *m13;
@property (strong, nonatomic) IBOutlet UIView *m14;
@property (strong, nonatomic) IBOutlet UIView *m15;
@property (strong, nonatomic) IBOutlet UIView *m16;
@property (strong, nonatomic) IBOutlet UIView *m17;
@property (strong, nonatomic) IBOutlet UIView *m21;
@property (strong, nonatomic) IBOutlet UIView *m22;
@property (strong, nonatomic) IBOutlet UIView *m23;
@property (strong, nonatomic) IBOutlet UIView *m24;
@property (strong, nonatomic) IBOutlet UIView *m25;
@property (strong, nonatomic) IBOutlet UIView *m26;
@property (strong, nonatomic) IBOutlet UIView *m27;

@property (strong, nonatomic) IBOutlet UIView *separator2;

@property (strong, nonatomic) IBOutlet UIView *s11;
@property (strong, nonatomic) IBOutlet UIView *s12;
@property (strong, nonatomic) IBOutlet UIView *s13;
@property (strong, nonatomic) IBOutlet UIView *s14;
@property (strong, nonatomic) IBOutlet UIView *s15;
@property (strong, nonatomic) IBOutlet UIView *s16;
@property (strong, nonatomic) IBOutlet UIView *s17;
@property (strong, nonatomic) IBOutlet UIView *s21;
@property (strong, nonatomic) IBOutlet UIView *s22;
@property (strong, nonatomic) IBOutlet UIView *s23;
@property (strong, nonatomic) IBOutlet UIView *s24;
@property (strong, nonatomic) IBOutlet UIView *s25;
@property (strong, nonatomic) IBOutlet UIView *s26;
@property (strong, nonatomic) IBOutlet UIView *s27;

@property (weak, nonatomic) IBOutlet UILabel *ampm;

@property (weak, nonatomic) IBOutlet UISegmentedControl *userPrefsButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *colorChangeButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *timeFormatButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *timeZoneButton;

@end

@implementation ViewController

- (IBAction)userPrefsButtonTapped:(UISegmentedControl *)sender {
    if (self.userPrefsButton.selectedSegmentIndex == 0) {
        //LOAD data from disk
        [self loadSettings];
        
    } else if (self.userPrefsButton.selectedSegmentIndex == 1) {
        //SAVE data to disk
        [self saveSettings];
    }
}

-(void) saveSettings{
    //get the path of our apps Document Directory(NSDocumentDirectory)
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //the path is stored in the first element
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    //append the name of our file to the path:  /path/LEDClockuserPrefs.txt
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"ledclock"];
    //store any errors
    NSError *error=nil;
    
    //save properties to dictionary
    [self.mySettings setObject:self.ledTime.NSDbackgroundColor forKey:@"NSDbackgroundColor"];
    [self.mySettings setObject:self.ledTime.NSDfontColor forKey:@"NSDfontColor"];
    [self.mySettings setObject:self.ledTime.backgroundFontButtonSetting forKey:@"backgroundFontButtonSetting"];
    [self.mySettings setObject:self.ledTime.timeFormat forKey:@"timeFormat"];
    [self.mySettings setObject:self.ledTime.timeZone forKey:@"timeZone"];
    NSLog(@"saveSettings: %@\n",self.mySettings);
    
    //Write NSMutableDictionary to Disk
    BOOL success = [self.mySettings writeToFile:filePath atomically:YES ];
    if(success){
        [self.mySettings setObject:self.ledTime.timeZone forKey:@"timeZone"];
        NSLog(@"Success: Settings Saved, path: %@\n",filePath);
    }else{
        NSLog(@"Error saving settings: %@ path: %@", filePath,[error localizedDescription]);
    }
    [self.mySettings removeAllObjects];
}

-(void) loadSettings {
    
    // create path to retrieve saved data from file
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"ledclock"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        //if file exists, Unarchive into nsmutabledictionary
        self.mySettings = [self.mySettings initWithContentsOfFile:filePath ];
        NSLog(@"%@",self.mySettings);
        
        //set background color
        self.ledTime.NSDbackgroundColor = [self.mySettings objectForKey:@"NSDbackgroundColor"];
        
        self.ledTime.UIbackgroundColor  = (UIColor *)[NSKeyedUnarchiver unarchiveObjectWithData:self.ledTime.NSDbackgroundColor];
        self.view.backgroundColor = self.ledTime.UIbackgroundColor;
        
        //set font color
        self.ledTime.NSDfontColor = [self.mySettings objectForKey:@"NSDfontColor"];
        
        self.ledTime.UIfontColor  = (UIColor *)[NSKeyedUnarchiver unarchiveObjectWithData:self.ledTime.NSDfontColor];
        self.currentColor = self.ledTime.UIfontColor;
        [self changeFontColor];
        
        //set background/font button settings
        self.ledTime.backgroundFontButtonSetting = [self.mySettings objectForKey:@"backgroundFontButtonSetting"];
        if ([self.ledTime.backgroundFontButtonSetting isEqualToString:@"0"]) {
            self.colorChangeButton.selectedSegmentIndex = 0;
        }else {
            self.colorChangeButton.selectedSegmentIndex = 1;
        }
        
        // check for time format 12 or 24 hr
        self.ledTime.timeFormat = [self.mySettings objectForKey:@"timeFormat"];
        
        if ([self.ledTime.timeFormat  isEqual: @"12hr" ]){
            self.timeFormatButton.selectedSegmentIndex = 0;
        }else {
            self.timeFormatButton.selectedSegmentIndex = 1;
        }
        
        // set timezone
        self.ledTime.timeZone = [self.mySettings objectForKey:@"timeZone"];
        if ([self.ledTime.timeZone isEqual: @"EST"]) {
            self.timeZoneButton.selectedSegmentIndex = 0;
        } else if ([self.ledTime.timeZone isEqual:  @"IST"]) {
            self.timeZoneButton.selectedSegmentIndex = 1;
        } else if ([self.ledTime.timeZone isEqual: @"HST"]) {
            self.timeZoneButton.selectedSegmentIndex = 2;
        } else if ([self.ledTime.timeZone isEqual: @"JST"]) {
            self.timeZoneButton.selectedSegmentIndex = 3;
        }
        
        NSLog(@"Success: Settings Saved, path: %@\n",filePath);
        //        NSLog(@"loadSettings2: %@ %@ %@ %@ CC:%@ %@ %@ %@\n",self.ledTime.NSDbackgroundColor, self.ledTime.UIbackgroundColor, self.ledTime.NSDfontColor, self.ledTime.UIfontColor, self.currentColor,self.ledTime.backgroundFontButtonSetting, self.ledTime.timeFormat,self.ledTime.timeZone );
        NSLog(@"Load from file: %@",self.mySettings);
    }
}

- (void)viewDidLoad {
    // Do any additional setup after loading the view, typically from a nib
    [super viewDidLoad];
    self.ledTime = [[LEDTime alloc]initWithValues];
    self.currentColor = [[UIColor alloc]init];
    self.ledTime.currentTime = [NSDate date];
    self.mySettings = [[NSMutableDictionary alloc]init];
    
    [self loadSettings];
    [self.ledTime setTime];
    [self updateView];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTheSeconds) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateSeparator) userInfo:nil repeats:YES];
    
}


- (IBAction)TimeFormatButtonTapped:(UISegmentedControl *)sender {
    
    if (self.timeFormatButton.selectedSegmentIndex == 0) {
        
        // Set time format to 12hr
        self.ledTime.timeFormat = @"12hr";
        
    } else if (self.timeFormatButton.selectedSegmentIndex == 1) {
        // Set time format to 24hr
        self.ledTime.timeFormat = @"24hr";
    }
    
    [self.ledTime setTime];
    [self updateTheHours];
    self.ampm.text = self.ledTime.ampm;
}

- (IBAction)TimeZoneButtonTapped:(id)sender {
    
    if (self.timeZoneButton.selectedSegmentIndex == 0) {
        self.ledTime.timeZone = @"EST";
        NSLog(@"Set time zone to America/New York");
    }
    if (self.timeZoneButton.selectedSegmentIndex == 1) {
        self.ledTime.timeZone = @"IST";
        NSLog(@"Set time zone to Mombay, India Time");
    }
    if (self.timeZoneButton.selectedSegmentIndex == 2) {
        self.ledTime.timeZone = @"HST";
        NSLog(@"Set time zone to  Hawaii-Aleutian Standard ");
    }
    if (self.timeZoneButton.selectedSegmentIndex == 3) {
        self.ledTime.timeZone = @"JST";
        NSLog(@"Set time zone to Asia/Tokyo");
    }
    
    [self.ledTime setTime];
    [self updateAmpmLabel];
    [self updateView];
}


- (IBAction)BackgroundFontButtonTapped:(UISegmentedControl *)sender {
    if (self.colorChangeButton.selectedSegmentIndex == 0) {
        self.ledTime.backgroundFontButtonSetting=@"0";
        NSLog(@"Background Button Tapped");
    }
    if (self.colorChangeButton.selectedSegmentIndex == 1) {
        self.ledTime.backgroundFontButtonSetting=@"1";
        NSLog(@"Font Button Tapped");
    }
}

- (IBAction)ColorButtonTapped:(UIButton *)sender {
    
    // change background color
    if (self.colorChangeButton.selectedSegmentIndex == 0) {
        
        if (sender.tag == 1) {
            //#define myPurpleColor .6 .2 .7 1
            self.ledTime.UIbackgroundColor = [UIColor colorWithRed:[@"153" floatValue]/255.0
                                                             green:[@"51" floatValue]/255.0
                                                              blue:[@"178" floatValue]/255.0
                                                             alpha:1.0];
        } else if (sender.tag == 2) {
            //#define myOrangeColor  1 .6 .3 1
            self.ledTime.UIbackgroundColor = [UIColor colorWithRed:[@"255" floatValue]/255.0
                                                             green:[@"153" floatValue]/255.0
                                                              blue:[@"77" floatValue]/255.0
                                                             alpha:1.0];
        } else if (sender.tag == 3) {
            //#define myGreenColor  .7 1 .6 1
            self.ledTime.UIbackgroundColor = [UIColor colorWithRed:[@"178" floatValue]/255.0
                                                             green:[@"255" floatValue]/255.0
                                                              blue:[@"153" floatValue]/255.0
                                                             alpha:1.0];
        } else if (sender.tag == 4) {
            //#define myBlueColor   .2 .4 .7 1
            self.ledTime.UIbackgroundColor = [UIColor colorWithRed:[@"51" floatValue]/255.0
                                                             green:[@"102" floatValue]/255.0
                                                              blue:[@"178" floatValue]/255.0
                                                             alpha:1.0];
        } else if (sender.tag == 5) {
            //#define myWhiteColor  .99 .98 .99 1
            self.ledTime.UIbackgroundColor = [UIColor colorWithRed:[@"253" floatValue]/255.0
                                                             green:[@"250" floatValue]/255.0
                                                              blue:[@"253" floatValue]/255.0
                                                             alpha:1.0];
        } else if (sender.tag == 6) {
            //#define myBlackColor   0 0 0 1
            self.ledTime.UIbackgroundColor = [UIColor colorWithRed:[@"0" floatValue]/255.0
                                                             green:[@"0" floatValue]/255.0
                                                              blue:[@"0" floatValue]/255.0
                                                             alpha:1.0];
        }
        
        //set background color
        self.view.backgroundColor = self.ledTime.UIbackgroundColor;
        
        // Convert  UIColor -> NSData  and save in NSDbackgroundColor
        self.ledTime.NSDbackgroundColor = [NSKeyedArchiver archivedDataWithRootObject:self.ledTime.UIbackgroundColor];
        
    }else if (self.colorChangeButton.selectedSegmentIndex == 1) {
        
        //change fontColor
        if (sender.tag == 1) {
            // myPurpleColor .6 .2 .7 1
            self.ledTime.UIfontColor = [UIColor colorWithRed:[@"153" floatValue]/255.0
                                                       green:[@"51" floatValue]/255.0
                                                        blue:[@"178" floatValue]/255.0
                                                       alpha:1.0];
        } else if (sender.tag == 2) {
            // myOrangeColor  1 .6 .3 1
            self.ledTime.UIfontColor = [UIColor colorWithRed:[@"255" floatValue]/255.0
                                                       green:[@"153" floatValue]/255.0
                                                        blue:[@"77" floatValue]/255.0
                                                       alpha:1.0];
        } else if (sender.tag == 3) {
            // myGreenColor  .7 1 .6 1
            self.ledTime.UIfontColor = [UIColor colorWithRed:[@"178" floatValue]/255.0
                                                       green:[@"255" floatValue]/255.0
                                                        blue:[@"153" floatValue]/255.0
                                                       alpha:1.0];
        } else if (sender.tag == 4) {
            // myBlueColor   .2 .4 .7 1
            self.ledTime.UIfontColor = [UIColor colorWithRed:[@"51" floatValue]/255.0
                                                       green:[@"102" floatValue]/255.0
                                                        blue:[@"178" floatValue]/255.0
                                                       alpha:1.0];
        } else if (sender.tag == 5) {
            // myWhiteColor  .99 .98 .99 1
            self.ledTime.UIfontColor = [UIColor colorWithRed:[@"253" floatValue]/255.0
                                                       green:[@"250" floatValue]/255.0
                                                        blue:[@"253" floatValue]/255.0
                                                       alpha:1.0];
        } else if (sender.tag == 6) {
            // myBlackColor   0 0 0 1
            self.ledTime.UIfontColor = [UIColor colorWithRed:[@"0" floatValue]/255.0
                                                       green:[@"0" floatValue]/255.0
                                                        blue:[@"0" floatValue]/255.0
                                                       alpha:1.0];
        }
        
        //set and change fontcolor
        self.currentColor = self.ledTime.UIfontColor;
        [self changeFontColor];
        
        // Convert UIfontColor UIColor -> NSData
        self.ledTime.NSDfontColor = [NSKeyedArchiver archivedDataWithRootObject:self.ledTime.UIfontColor];
        
    }
    //    NSLog(@"Set fontColor to UI:%@, *NSDfontColor=%@",self.ledTime.UIfontColor, self.ledTime.NSDfontColor);
    //    NSLog(@"Set backgroundColor to UI:%@, *NSDbackgroundColor=%@\n",self.ledTime.UIbackgroundColor,self.ledTime.NSDbackgroundColor);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateTheSeconds{
    [self.ledTime updateSeconds];
    [self updateSecond1];
    [self updateSecond2];
    
    //update minutes at 59 seconds
    if (self.ledTime.seconds == 0)  {
        [self updateTheMinutes];
    }
}

-(void)updateTheMinutes{
    [self.ledTime updateMinutes];
    [self updateMinute1];
    [self updateMinute2];
    
    //update minutes at 59 seconds
    if (self.ledTime.seconds == 0)  {
        [self updateTheHours];
    }
    NSLog(@"updateTheMinutes: %@",self.ledTime);
}

-(void)updateTheHours{
    [self updateHour1];
    [self updateHour2];
}

-(void)updateSeparator {
    
    if (self.separator1.hidden == YES) {
        [self.separator1 setHidden:NO];
        [self.separator2 setHidden:NO];
    } else{
        [self.separator1 setHidden:YES];
        [self.separator2 setHidden:YES];
    }
}

-(void)updateView{
    [self updateTheHours];
    [self updateTheMinutes];
    [self updateTheSeconds];
    [self updateSeparator];
    [self updateAmpmLabel];
    
}

-(void) updateAmpmLabel{
    self.ampm.text = self.ledTime.ampm;
    NSLog(@"timeformat: %@, updateAmpmLabel: %@",self.ledTime.timeFormat ,self.ampm.text);
}

-(void)updateHour1 {
    
    //    NSLog(@"updateHour1:HH:MM:SS: %i %i : %i %i : %i %i", self.ledTime.hour1,self.ledTime.hour2, self.ledTime.minute1,self.ledTime.minute2,self.ledTime.second1, self.ledTime.second2);
    
    switch (self.ledTime.hour1) {
        case 0:
            [self.h11 setHidden:NO];
            [self.h12 setHidden:NO];
            [self.h13 setHidden:NO];
            [self.h14 setHidden:YES];
            [self.h15 setHidden:NO];
            [self.h16 setHidden:NO];
            [self.h17 setHidden:NO];
            break;
        case 1:
            [self.h11 setHidden:YES];
            [self.h12 setHidden:YES];
            [self.h13 setHidden:NO];
            [self.h14 setHidden:YES];
            [self.h15 setHidden:YES];
            [self.h16 setHidden:NO];
            [self.h17 setHidden:YES];
            break;
        case 2:
            [self.h11 setHidden:NO];
            [self.h12 setHidden:YES];
            [self.h13 setHidden:NO];
            [self.h14 setHidden:NO];
            [self.h15 setHidden:NO];
            [self.h16 setHidden:YES];
            [self.h17 setHidden:NO];
            break;
        case 3:
            [self.h11 setHidden:NO];
            [self.h12 setHidden:YES];
            [self.h13 setHidden:NO];
            [self.h14 setHidden:NO];
            [self.h15 setHidden:YES];
            [self.h16 setHidden:NO];
            [self.h17 setHidden:NO];
            break;
        case 4:
            [self.h11 setHidden:YES];
            [self.h12 setHidden:NO];
            [self.h13 setHidden:NO];
            [self.h14 setHidden:NO];
            [self.h15 setHidden:YES];
            [self.h16 setHidden:NO];
            [self.h17 setHidden:YES];
            break;
        case 5:
            [self.h11 setHidden:NO];
            [self.h12 setHidden:NO];
            [self.h13 setHidden:YES];
            [self.h14 setHidden:NO];
            [self.h15 setHidden:YES];
            [self.h16 setHidden:NO];
            [self.h17 setHidden:NO];
            break;
        case 6:
            [self.h11 setHidden:YES];
            [self.h12 setHidden:NO];
            [self.h13 setHidden:YES];
            [self.h14 setHidden:NO];
            [self.h15 setHidden:NO];
            [self.h16 setHidden:NO];
            [self.h17 setHidden:NO];
            break;
        case 7:
            [self.h11 setHidden:NO];
            [self.h12 setHidden:YES];
            [self.h13 setHidden:NO];
            [self.h14 setHidden:YES];
            [self.h15 setHidden:YES];
            [self.h16 setHidden:NO];
            [self.h17 setHidden:YES];
            break;
        case 8:
            [self.h11 setHidden:NO];
            [self.h12 setHidden:NO];
            [self.h13 setHidden:NO];
            [self.h14 setHidden:NO];
            [self.h15 setHidden:NO];
            [self.h16 setHidden:NO];
            [self.h17 setHidden:NO];
            break;
        case 9:
            [self.h11 setHidden:NO];
            [self.h12 setHidden:NO];
            [self.h13 setHidden:NO];
            [self.h14 setHidden:NO];
            [self.h15 setHidden:YES];
            [self.h16 setHidden:NO];
            [self.h17 setHidden:YES];
        default:
            break;
    }
}


-(void)updateHour2 {
    
    switch (self.ledTime.hour2) {
        case 0:
            [self.h21 setHidden:NO];
            [self.h22 setHidden:NO];
            [self.h23 setHidden:NO];
            [self.h24 setHidden:YES];
            [self.h25 setHidden:NO];
            [self.h26 setHidden:NO];
            [self.h27 setHidden:NO];
            break;
        case 1:
            [self.h21 setHidden:YES];
            [self.h22 setHidden:YES];
            [self.h23 setHidden:NO];
            [self.h24 setHidden:YES];
            [self.h25 setHidden:YES];
            [self.h26 setHidden:NO];
            [self.h27 setHidden:YES];
            break;
        case 2:
            [self.h21 setHidden:NO];
            [self.h22 setHidden:YES];
            [self.h23 setHidden:NO];
            [self.h24 setHidden:NO];
            [self.h25 setHidden:NO];
            [self.h26 setHidden:YES];
            [self.h27 setHidden:NO];
            break;
        case 3:
            [self.h21 setHidden:NO];
            [self.h22 setHidden:YES];
            [self.h23 setHidden:NO];
            [self.h24 setHidden:NO];
            [self.h25 setHidden:YES];
            [self.h26 setHidden:NO];
            [self.h27 setHidden:NO];
            break;
        case 4:
            [self.h21 setHidden:YES];
            [self.h22 setHidden:NO];
            [self.h23 setHidden:NO];
            [self.h24 setHidden:NO];
            [self.h25 setHidden:YES];
            [self.h26 setHidden:NO];
            [self.h27 setHidden:YES];
            break;
        case 5:
            [self.h21 setHidden:NO];
            [self.h22 setHidden:NO];
            [self.h23 setHidden:YES];
            [self.h24 setHidden:NO];
            [self.h25 setHidden:YES];
            [self.h26 setHidden:NO];
            [self.h27 setHidden:NO];
            break;
        case 6:
            [self.h21 setHidden:YES];
            [self.h22 setHidden:NO];
            [self.h23 setHidden:YES];
            [self.h24 setHidden:NO];
            [self.h25 setHidden:NO];
            [self.h26 setHidden:NO];
            [self.h27 setHidden:NO];
            break;
        case 7:
            [self.h21 setHidden:NO];
            [self.h22 setHidden:YES];
            [self.h23 setHidden:NO];
            [self.h24 setHidden:YES];
            [self.h25 setHidden:YES];
            [self.h26 setHidden:NO];
            [self.h27 setHidden:YES];
            break;
        case 8:
            [self.h21 setHidden:NO];
            [self.h22 setHidden:NO];
            [self.h23 setHidden:NO];
            [self.h24 setHidden:NO];
            [self.h25 setHidden:NO];
            [self.h26 setHidden:NO];
            [self.h27 setHidden:NO];
            break;
        case 9:
            [self.h21 setHidden:NO];
            [self.h22 setHidden:NO];
            [self.h23 setHidden:NO];
            [self.h24 setHidden:NO];
            [self.h25 setHidden:YES];
            [self.h26 setHidden:NO];
            [self.h27 setHidden:YES];
        default:
            break;
    }
    
    
}
-(void)updateMinute1 {
    
    switch (self.ledTime.minute1) {
        case 0:
            [self.m11 setHidden:NO];
            [self.m12 setHidden:NO];
            [self.m13 setHidden:NO];
            [self.m14 setHidden:YES];
            [self.m15 setHidden:NO];
            [self.m16 setHidden:NO];
            [self.m17 setHidden:NO];
            break;
        case 1:
            [self.m11 setHidden:YES];
            [self.m12 setHidden:YES];
            [self.m13 setHidden:NO];
            [self.m14 setHidden:YES];
            [self.m15 setHidden:YES];
            [self.m16 setHidden:NO];
            [self.m17 setHidden:YES];
            break;
        case 2:
            [self.m11 setHidden:NO];
            [self.m12 setHidden:YES];
            [self.m13 setHidden:NO];
            [self.m14 setHidden:NO];
            [self.m15 setHidden:NO];
            [self.m16 setHidden:YES];
            [self.m17 setHidden:NO];
            break;
        case 3:
            [self.m11 setHidden:NO];
            [self.m12 setHidden:YES];
            [self.m13 setHidden:NO];
            [self.m14 setHidden:NO];
            [self.m15 setHidden:YES];
            [self.m16 setHidden:NO];
            [self.m17 setHidden:NO];
            break;
        case 4:
            [self.m11 setHidden:YES];
            [self.m12 setHidden:NO];
            [self.m13 setHidden:NO];
            [self.m14 setHidden:NO];
            [self.m15 setHidden:YES];
            [self.m16 setHidden:NO];
            [self.m17 setHidden:YES];
            break;
        case 5:
            [self.m11 setHidden:NO];
            [self.m12 setHidden:NO];
            [self.m13 setHidden:YES];
            [self.m14 setHidden:NO];
            [self.m15 setHidden:YES];
            [self.m16 setHidden:NO];
            [self.m17 setHidden:NO];
            break;
        case 6:
            [self.m11 setHidden:YES];
            [self.m12 setHidden:NO];
            [self.m13 setHidden:YES];
            [self.m14 setHidden:NO];
            [self.m15 setHidden:NO];
            [self.m16 setHidden:NO];
            [self.m17 setHidden:NO];
            break;
        case 7:
            [self.m11 setHidden:NO];
            [self.m12 setHidden:YES];
            [self.m13 setHidden:NO];
            [self.m14 setHidden:YES];
            [self.m15 setHidden:YES];
            [self.m16 setHidden:NO];
            [self.m17 setHidden:YES];
            break;
        case 8:
            [self.m11 setHidden:NO];
            [self.m12 setHidden:NO];
            [self.m13 setHidden:NO];
            [self.m14 setHidden:NO];
            [self.m15 setHidden:NO];
            [self.m16 setHidden:NO];
            [self.m17 setHidden:NO];
            break;
        case 9:
            [self.m11 setHidden:NO];
            [self.m12 setHidden:NO];
            [self.m13 setHidden:NO];
            [self.m14 setHidden:NO];
            [self.m15 setHidden:YES];
            [self.m16 setHidden:NO];
            [self.m17 setHidden:YES];
        default:
            break;
    }
    
}
-(void)updateMinute2 {
    
    switch (self.ledTime.minute2) {
        case 0:
            [self.m21 setHidden:NO];
            [self.m22 setHidden:NO];
            [self.m23 setHidden:NO];
            [self.m24 setHidden:YES];
            [self.m25 setHidden:NO];
            [self.m26 setHidden:NO];
            [self.m27 setHidden:NO];
            break;
        case 1:
            [self.m21 setHidden:YES];
            [self.m22 setHidden:YES];
            [self.m23 setHidden:NO];
            [self.m24 setHidden:YES];
            [self.m25 setHidden:YES];
            [self.m26 setHidden:NO];
            [self.m27 setHidden:YES];
            break;
        case 2:
            [self.m21 setHidden:NO];
            [self.m22 setHidden:YES];
            [self.m23 setHidden:NO];
            [self.m24 setHidden:NO];
            [self.m25 setHidden:NO];
            [self.m26 setHidden:YES];
            [self.m27 setHidden:NO];
            break;
        case 3:
            [self.m21 setHidden:NO];
            [self.m22 setHidden:YES];
            [self.m23 setHidden:NO];
            [self.m24 setHidden:NO];
            [self.m25 setHidden:YES];
            [self.m26 setHidden:NO];
            [self.m27 setHidden:NO];
            break;
        case 4:
            [self.m21 setHidden:YES];
            [self.m22 setHidden:NO];
            [self.m23 setHidden:NO];
            [self.m24 setHidden:NO];
            [self.m25 setHidden:YES];
            [self.m26 setHidden:NO];
            [self.m27 setHidden:YES];
            break;
        case 5:
            [self.m21 setHidden:NO];
            [self.m22 setHidden:NO];
            [self.m23 setHidden:YES];
            [self.m24 setHidden:NO];
            [self.m25 setHidden:YES];
            [self.m26 setHidden:NO];
            [self.m27 setHidden:NO];
            break;
        case 6:
            [self.m21 setHidden:YES];
            [self.m22 setHidden:NO];
            [self.m23 setHidden:YES];
            [self.m24 setHidden:NO];
            [self.m25 setHidden:NO];
            [self.m26 setHidden:NO];
            [self.m27 setHidden:NO];
            break;
        case 7:
            [self.m21 setHidden:NO];
            [self.m22 setHidden:YES];
            [self.m23 setHidden:NO];
            [self.m24 setHidden:YES];
            [self.m25 setHidden:YES];
            [self.m26 setHidden:NO];
            [self.m27 setHidden:YES];
            break;
        case 8:
            [self.m21 setHidden:NO];
            [self.m22 setHidden:NO];
            [self.m23 setHidden:NO];
            [self.m24 setHidden:NO];
            [self.m25 setHidden:NO];
            [self.m26 setHidden:NO];
            [self.m27 setHidden:NO];
            break;
        case 9:
            [self.m21 setHidden:NO];
            [self.m22 setHidden:NO];
            [self.m23 setHidden:NO];
            [self.m24 setHidden:NO];
            [self.m25 setHidden:YES];
            [self.m26 setHidden:NO];
            [self.m27 setHidden:YES];
        default:
            break;
    }
    
}
-(void)updateSecond1 {
    
    switch (self.ledTime.second1) {
        case 0:
            [self.s11 setHidden:NO];
            [self.s12 setHidden:NO];
            [self.s13 setHidden:NO];
            [self.s14 setHidden:YES];
            [self.s15 setHidden:NO];
            [self.s16 setHidden:NO];
            [self.s17 setHidden:NO];
            break;
        case 1:
            [self.s11 setHidden:YES];
            [self.s12 setHidden:YES];
            [self.s13 setHidden:NO];
            [self.s14 setHidden:YES];
            [self.s15 setHidden:YES];
            [self.s16 setHidden:NO];
            [self.s17 setHidden:YES];
            break;
        case 2:
            [self.s11 setHidden:NO];
            [self.s12 setHidden:YES];
            [self.s13 setHidden:NO];
            [self.s14 setHidden:NO];
            [self.s15 setHidden:NO];
            [self.s16 setHidden:YES];
            [self.s17 setHidden:NO];
            break;
        case 3:
            [self.s11 setHidden:NO];
            [self.s12 setHidden:YES];
            [self.s13 setHidden:NO];
            [self.s14 setHidden:NO];
            [self.s15 setHidden:YES];
            [self.s16 setHidden:NO];
            [self.s17 setHidden:NO];
            break;
        case 4:
            [self.s11 setHidden:YES];
            [self.s12 setHidden:NO];
            [self.s13 setHidden:NO];
            [self.s14 setHidden:NO];
            [self.s15 setHidden:YES];
            [self.s16 setHidden:NO];
            [self.s17 setHidden:YES];
            break;
        case 5:
            [self.s11 setHidden:NO];
            [self.s12 setHidden:NO];
            [self.s13 setHidden:YES];
            [self.s14 setHidden:NO];
            [self.s15 setHidden:YES];
            [self.s16 setHidden:NO];
            [self.s17 setHidden:NO];
            break;
        case 6:
            [self.s11 setHidden:YES];
            [self.s12 setHidden:NO];
            [self.s13 setHidden:YES];
            [self.s14 setHidden:NO];
            [self.s15 setHidden:NO];
            [self.s16 setHidden:NO];
            [self.s17 setHidden:NO];
            break;
        case 7:
            [self.s11 setHidden:NO];
            [self.s12 setHidden:YES];
            [self.s13 setHidden:NO];
            [self.s14 setHidden:YES];
            [self.s15 setHidden:YES];
            [self.s16 setHidden:NO];
            [self.s17 setHidden:YES];
            break;
        case  8:
            [self.s11 setHidden:NO];
            [self.s12 setHidden:NO];
            [self.s13 setHidden:NO];
            [self.s14 setHidden:NO];
            [self.s15 setHidden:NO];
            [self.s16 setHidden:NO];
            [self.s17 setHidden:NO];
            break;
        case 9:
            [self.s11 setHidden:NO];
            [self.s12 setHidden:NO];
            [self.s13 setHidden:NO];
            [self.s14 setHidden:NO];
            [self.s15 setHidden:YES];
            [self.s16 setHidden:NO];
            [self.s17 setHidden:YES];
        default:
            if (self.ledTime.seconds == 59)  {
                //update minutes
                [self.ledTime updateSeconds];
                [self.ledTime updateMinutes];
            }
            break;
    }
    
}
-(void)updateSecond2 {
    
    switch (self.ledTime.second2) {
        case 0:
            [self.s21 setHidden:NO];
            [self.s22 setHidden:NO];
            [self.s23 setHidden:NO];
            [self.s24 setHidden:YES];
            [self.s25 setHidden:NO];
            [self.s26 setHidden:NO];
            [self.s27 setHidden:NO];
            break;
        case 1:
            [self.s21 setHidden:YES];
            [self.s22 setHidden:YES];
            [self.s23 setHidden:NO];
            [self.s24 setHidden:YES];
            [self.s25 setHidden:YES];
            [self.s26 setHidden:NO];
            [self.s27 setHidden:YES];
            break;
        case 2:
            [self.s21 setHidden:NO];
            [self.s22 setHidden:YES];
            [self.s23 setHidden:NO];
            [self.s24 setHidden:NO];
            [self.s25 setHidden:NO];
            [self.s26 setHidden:YES];
            [self.s27 setHidden:NO];
            break;
        case 3:
            [self.s21 setHidden:NO];
            [self.s22 setHidden:YES];
            [self.s23 setHidden:NO];
            [self.s24 setHidden:NO];
            [self.s25 setHidden:YES];
            [self.s26 setHidden:NO];
            [self.s27 setHidden:NO];
            break;
        case 4:
            [self.s21 setHidden:YES];
            [self.s22 setHidden:NO];
            [self.s23 setHidden:NO];
            [self.s24 setHidden:NO];
            [self.s25 setHidden:YES];
            [self.s26 setHidden:NO];
            [self.s27 setHidden:YES];
            break;
        case 5:
            [self.s21 setHidden:NO];
            [self.s22 setHidden:NO];
            [self.s23 setHidden:YES];
            [self.s24 setHidden:NO];
            [self.s25 setHidden:YES];
            [self.s26 setHidden:NO];
            [self.s27 setHidden:NO];
            break;
        case 6:
            [self.s21 setHidden:YES];
            [self.s22 setHidden:NO];
            [self.s23 setHidden:YES];
            [self.s24 setHidden:NO];
            [self.s25 setHidden:NO];
            [self.s26 setHidden:NO];
            [self.s27 setHidden:NO];
            break;
        case 7:
            [self.s21 setHidden:NO];
            [self.s22 setHidden:YES];
            [self.s23 setHidden:NO];
            [self.s24 setHidden:YES];
            [self.s25 setHidden:YES];
            [self.s26 setHidden:NO];
            [self.s27 setHidden:YES];
            break;
        case 8:
            [self.s21 setHidden:NO];
            [self.s22 setHidden:NO];
            [self.s23 setHidden:NO];
            [self.s24 setHidden:NO];
            [self.s25 setHidden:NO];
            [self.s26 setHidden:NO];
            [self.s27 setHidden:NO];
            break;
        case 9:
            [self.s21 setHidden:NO];
            [self.s22 setHidden:NO];
            [self.s23 setHidden:NO];
            [self.s24 setHidden:NO];
            [self.s25 setHidden:YES];
            [self.s26 setHidden:NO];
            [self.s27 setHidden:YES];
        default:
//            if (self.ledTime.seconds == 59)  {
//                //update minutes
//                [self.ledTime updateSeconds];
//                [self.ledTime updateMinutes];
//            }
            break;
    }
}

-(void) changeFontColor {
    
    self.h11.backgroundColor =  self.currentColor;
    self.h12.backgroundColor =  self.currentColor;
    self.h13.backgroundColor =  self.currentColor;
    self.h14.backgroundColor =  self.currentColor;
    self.h15.backgroundColor =  self.currentColor;
    self.h16.backgroundColor =  self.currentColor;
    self.h17.backgroundColor =  self.currentColor;
    
    self.h21.backgroundColor =  self.currentColor;
    self.h22.backgroundColor =  self.currentColor;
    self.h23.backgroundColor =  self.currentColor;
    self.h24.backgroundColor =  self.currentColor;
    self.h25.backgroundColor =  self.currentColor;
    self.h26.backgroundColor =  self.currentColor;
    self.h27.backgroundColor =  self.currentColor;
    
    self.separator1.backgroundColor =  self.currentColor;
    
    self.m11.backgroundColor =  self.currentColor;
    self.m12.backgroundColor =  self.currentColor;
    self.m13.backgroundColor =  self.currentColor;
    self.m14.backgroundColor =  self.currentColor;
    self.m15.backgroundColor =  self.currentColor;
    self.m16.backgroundColor =  self.currentColor;
    self.m17.backgroundColor =  self.currentColor;
    
    self.m21.backgroundColor =  self.currentColor;
    self.m22.backgroundColor =  self.currentColor;
    self.m23.backgroundColor =  self.currentColor;
    self.m24.backgroundColor =  self.currentColor;
    self.m25.backgroundColor =  self.currentColor;
    self.m26.backgroundColor =  self.currentColor;
    self.m27.backgroundColor =  self.currentColor;
    
    self.separator2.backgroundColor =  self.currentColor;
    
    self.s11.backgroundColor =  self.currentColor;
    self.s12.backgroundColor =  self.currentColor;
    self.s13.backgroundColor =  self.currentColor;
    self.s14.backgroundColor =  self.currentColor;
    self.s15.backgroundColor =  self.currentColor;
    self.s16.backgroundColor =  self.currentColor;
    self.s17.backgroundColor =  self.currentColor;
    
    self.s21.backgroundColor =  self.currentColor;
    self.s22.backgroundColor =  self.currentColor;
    self.s23.backgroundColor =  self.currentColor;
    self.s24.backgroundColor =  self.currentColor;
    self.s25.backgroundColor =  self.currentColor;
    self.s26.backgroundColor =  self.currentColor;
    self.s27.backgroundColor =  self.currentColor;
    
    self.ampm.textColor =  self.currentColor;
    
}


@end
