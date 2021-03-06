//
//  PDTAppDelegate.m
//  PDTSimpleCalendarDemo
//
//  Created by Jerome Miglino on 10/14/13.
//  Copyright (c) 2013 Producteev. All rights reserved.
//

#import "PDTAppDelegate.h"
#import "PDTSimpleCalendarViewController.h"
#import "PDTSimpleCalendarViewCell.h"
#import "PDTSimpleCalendarViewHeader.h"

@interface PDTAppDelegate () <PDTSimpleCalendarViewDelegate>

@property (nonatomic, strong) NSArray *customDates;
@property (nonatomic, strong) PDTSimpleCalendarViewController *customC;
@property (nonatomic, strong) UINavigationController *navC;

@end

@implementation PDTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [[UINavigationBar appearance] setTintColor:[UIColor greenColor]];
//    [[UINavigationBar appearance] setBarTintColor:[UIColor lightGrayColor]];

    [[PDTSimpleCalendarViewCell appearance] setCircleSelectedColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor greenColor];

    [PDTSimpleCalendarViewCell addHolidays:[NSDictionary dictionaryWithObjectsAndKeys:
                                            @"假", @"2015-1-2",
                                            @"班", @"2015-1-3",
                                            nil]];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd/MM/yyyy";
    _customDates = @[[dateFormatter dateFromString:@"01/05/2014"], [dateFormatter dateFromString:@"01/06/2014"], [dateFormatter dateFromString:@"01/07/2014"]];
    
    PDTSimpleCalendarViewController *calendarViewController = [[PDTSimpleCalendarViewController alloc] init];
    //This is the default behavior, will display a full year starting the first of the current month
    [calendarViewController setDelegate:self];

    PDTSimpleCalendarViewController *hebrewCalendarViewController = [[PDTSimpleCalendarViewController alloc] init];
    //Example of how you can change the default calendar
    //Other options you can try NSPersianCalendar, NSIslamicCalendar, NSIndianCalendar, NSJapaneseCalendar, NSRepublicOfChinaCalendar
    NSCalendar *hebrewCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSHebrewCalendar];
    hebrewCalendar.locale = [NSLocale currentLocale];
    [hebrewCalendarViewController setCalendar:hebrewCalendar];

    PDTSimpleCalendarViewController *dateRangeCalendarViewController = [[PDTSimpleCalendarViewController alloc] init];
    //For this calendar we're gonna allow only a selection between today and today + 3months.
    dateRangeCalendarViewController.firstDate = [NSDate date];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    offsetComponents.day = 60;
    NSDate *lastDate =[dateRangeCalendarViewController.calendar dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
    dateRangeCalendarViewController.lastDate = lastDate;

    //Set the edgesForExtendedLayout to UIRectEdgeNone
    if ([UIViewController instancesRespondToSelector:@selector(edgesForExtendedLayout)]) {
        [calendarViewController setEdgesForExtendedLayout:UIRectEdgeNone];
        [hebrewCalendarViewController setEdgesForExtendedLayout:UIRectEdgeNone];
        [dateRangeCalendarViewController setEdgesForExtendedLayout:UIRectEdgeNone];
    }

    //Create Navigation Controller
    UINavigationController *defaultNavController = [[UINavigationController alloc] initWithRootViewController:calendarViewController];
    [calendarViewController setTitle:@"SimpleCalendar"];

    UINavigationController *hebrewNavController = [[UINavigationController alloc] initWithRootViewController:hebrewCalendarViewController];
    [hebrewCalendarViewController setTitle:@"Hebrew Calendar"];
    UIViewController *cont = [UIViewController new];
    UINavigationController *dateRangeNavController = [[UINavigationController alloc] initWithRootViewController:cont];
    cont.title = @"Custom Range";
    cont.view.backgroundColor = [UIColor grayColor];
    cont.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Open" style:UIBarButtonItemStyleBordered target:self action:@selector(openCustom)];
    self.navC = dateRangeNavController;
    self.customC = dateRangeCalendarViewController;
    [dateRangeCalendarViewController setTitle:@"Custom Range"];

    //Create the Tab Bar Controller
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:@[defaultNavController, hebrewNavController, dateRangeNavController]];


    //Example of how you can now customize the calendar colors
//    [[PDTSimpleCalendarViewCell appearance] setCircleDefaultColor:[UIColor whiteColor]];
//    [[PDTSimpleCalendarViewCell appearance] setCircleSelectedColor:[UIColor orangeColor]];
//    [[PDTSimpleCalendarViewCell appearance] setCircleTodayColor:[UIColor blueColor]];
//    [[PDTSimpleCalendarViewCell appearance] setTextDefaultColor:[UIColor redColor]];
//    [[PDTSimpleCalendarViewCell appearance] setTextSelectedColor:[UIColor purpleColor]];
//    [[PDTSimpleCalendarViewCell appearance] setTextTodayColor:[UIColor magentaColor]];
//    [[PDTSimpleCalendarViewCell appearance] setTextDisabledColor:[UIColor purpleColor]];
//    [[PDTSimpleCalendarViewCell appearance] setTextDefaultFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0]];
//
//    [[PDTSimpleCalendarViewHeader appearance] setTextColor:[UIColor redColor]];
//    [[PDTSimpleCalendarViewHeader appearance] setSeparatorColor:[UIColor orangeColor]];
//    [[PDTSimpleCalendarViewHeader appearance] setTextFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:8.0]];

    [self.window setRootViewController:tabBarController];
    [self.window makeKeyAndVisible];

    return YES;
}

-(void)openCustom{
    PDTSimpleCalendarViewController *dateRangeCalendarViewController = [[PDTSimpleCalendarViewController alloc] init];
    //For this calendar we're gonna allow only a selection between today and today + 3months.
    dateRangeCalendarViewController.firstDate = [NSDate date];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    offsetComponents.day = 60;
    NSDate *lastDate =[dateRangeCalendarViewController.calendar dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
    dateRangeCalendarViewController.lastDate = lastDate;
    
//    dateRangeCalendarViewController = self.customC;
    dateRangeCalendarViewController.selectedDate = lastDate;
//    [dateRangeCalendarViewController scrollToSelectedDate:NO];
    [dateRangeCalendarViewController setTitle:@"Custom Range"];
//    [dateRangeCalendarViewController.collectionView setContentOffset:CGPointMake(0, 1800) animated:NO];

    [self.navC pushViewController:dateRangeCalendarViewController animated:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - PDTSimpleCalendarViewDelegate

- (void)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller didSelectDate:(NSDate *)date
{
    NSLog(@"Date Selected : %@",date);
}

//- (BOOL)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller shouldUseCustomColorsForDate:(NSDate *)date
//{
//    if ([self.customDates containsObject:date]) {
//        return YES;
//    }
//
//    return NO;
//}
//
//- (UIColor *)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller circleColorForDate:(NSDate *)date
//{
//    return [UIColor whiteColor];
//}
//
//- (UIColor *)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller textColorForDate:(NSDate *)date
//{
//    return [UIColor orangeColor];
//}

@end
