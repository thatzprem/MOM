//
//  AppDelegate.h
//  CloudContactsStore
//
//  Created by Prem kumar on 20/03/14.
//  Copyright (c) 2014 nexTip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, readwrite) BOOL contactListNeedsUpdate;
@property (nonatomic,assign) int countToPresentInterstitialAd;

@end
