//
//  ViewController.m
//  PalletteRF
//
//  Created by Oliver Hoffman on 10/3/15.
//  Copyright © 2015 Oliver Hoffman. All rights reserved.
//

#import "AppViewController.h"
#import <RobotKit/RobotKit.h>
#import <RobotUIKit/RobotUIKit.h>
@interface AppViewController ()
@property (weak, nonatomic) IBOutlet UILabel *test;
@property (strong, nonatomic) UIWindow* window;
@property (strong, nonatomic) RKConvenienceRobot* robot;
@property (strong, nonatomic) RUICalibrateGestureHandler *calibrateHandler;
@end

@implementation AppViewController

@synthesize rfduino;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    
    self.calibrateHandler = [[RUICalibrateGestureHandler alloc] initWithView:self.view];
    
    // hook up for robot state changes
    [[RKRobotDiscoveryAgent sharedAgent] addNotificationObserver:self selector:@selector(handleRobotStateChangeNotification:)];
    
    
    
    rfduino.delegate = self;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)appDidBecomeActive:(NSNotification *)n {
    [RKRobotDiscoveryAgent startDiscovery];
}

- (void)appWillResignActive:(NSNotification*)notification {
    [RKRobotDiscoveryAgent stopDiscovery];
    [RKRobotDiscoveryAgent disconnectAll];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didReceive:(NSData *)data{
    NSLog(@"HELLLOO");
}
- (void)handleRobotStateChangeNotification:(RKRobotChangedStateNotification*)n {
    switch(n.type) {
        case RKRobotConnecting:
            [self handleConnecting];
            break;
        case RKRobotOnline: {
            NSLog(@"SPHERE");
            // Do not allow the robot to connect if the application is not running
            RKConvenienceRobot *convenience = [RKConvenienceRobot convenienceWithRobot:n.robot];
            if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive) {
                [convenience disconnect];
                return;
            }
            self.robot = convenience;
            [self handleConnected];
            break;
        }
        case RKRobotDisconnected:
            [self handleDisconnected];
            self.robot = nil;
            [RKRobotDiscoveryAgent startDiscovery];
            break;
        default:
            break;
    }
}

- (void)handleConnecting {
    // Handle when a robot is connecting here
    NSLog(@"Connecting");
}

- (void)handleConnected {
    [_calibrateHandler setRobot:_robot.robot];
}

- (void)handleDisconnected {
    [_calibrateHandler setRobot:nil];
}

- (IBAction)zeroPressed:(id)sender {
    [_robot driveWithHeading:0.0 andVelocity:0.5];
}

- (IBAction)ninetyPressed:(id)sender {
    [_robot driveWithHeading:90 andVelocity:0.5];
}

- (IBAction)oneEightyPressed:(id)sender {
    [_robot driveWithHeading:180 andVelocity:0.5];
}

- (IBAction)twoSeventyPressed:(id)sender {
    [_robot driveWithHeading:270.0 andVelocity:0.5];
}

- (IBAction)stopPressed:(id)sender {
    [_robot stop];
}


@end
