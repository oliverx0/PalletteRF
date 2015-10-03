//
//  ViewController.h
//  PalletteRF
//
//  Created by Oliver Hoffman on 10/3/15.
//  Copyright © 2015 Oliver Hoffman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RFduinoDelegate.h"
#import "RFduino.h"

@interface AppViewController : UIViewController<RFduinoDelegate>

@property(nonatomic, strong) RFduino *rfduino;

@end


