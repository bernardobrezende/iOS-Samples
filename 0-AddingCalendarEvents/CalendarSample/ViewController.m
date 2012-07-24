//
//  ViewController.m
//  CalendarSample
//
//  Created by Bernardo Rezende on 23/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import <EventKit/EventKit.h>

@interface ViewController ()
 
@end

@implementation ViewController

@synthesize calendarID;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Creating EventStore and Fetching Calendar Source Type
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    EKCalendar *calendar = [EKCalendar calendarWithEventStore:eventStore];
    calendar.title = @"My New Calendar";
    
    EKSource *iCloudSrc = nil;
    EKSource *localSource = nil;
    for (EKSource *src in eventStore.sources) {
        if (src.sourceType == EKSourceTypeCalDAV && [src.title isEqualToString:@"iCloud"]) {
            iCloudSrc = src;
            break;
        }
        else if (src.sourceType == EKSourceTypeLocal) {
            localSource = src;
        }
    }
    // First we prior to use iCloud. If iCloud is not configured, we fall back to local calendar :)
    calendar.source = iCloudSrc != nil ? iCloudSrc : localSource;
    
    if (!calendar.source) {
        NSLog(@"Unable to find calendar source.");
        return;
    }
    
    // Saving calendar
    NSError* error = nil;
    BOOL result = [eventStore saveCalendar:calendar commit:YES error:&error];
    if (result) {
        self.calendarID = calendar.calendarIdentifier;
    }
    else {
        NSLog(@"Error saving calendar!");
    }
    
    // Creating and saving event
    EKEvent *myTestEvent = [EKEvent eventWithEventStore:eventStore];
    EKCalendar *eventCalendar = [eventStore calendarWithIdentifier:self.calendarID];
    myTestEvent.calendar = eventCalendar;
    myTestEvent.title = @"iCloud!!!";
    myTestEvent.startDate = [NSDate date];
    myTestEvent.endDate = [myTestEvent.startDate dateByAddingTimeInterval:86400];
    
    NSError *eventError = nil;
    BOOL rslt = [eventStore saveEvent:myTestEvent span:EKSpanThisEvent commit:YES error:&eventError];
    
    if (!rslt) {
        NSLog(@"Unable to save new event!");
    }
    else {
        NSLog(@"Success!");
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
