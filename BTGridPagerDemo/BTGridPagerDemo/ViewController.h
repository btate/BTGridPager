//
//  ViewController.h
//  BTGridPagerDemo
//
//  Created by Brandon Tate on 5/29/14.
//  Copyright (c) 2014 Brandon Tate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTGridPager.h"

@interface ViewController : UIViewController<BTGridPagerDataSource, BTGridPagerDelegate>

@property (nonatomic, strong)   IBOutlet    BTGridPager   *gridPager;

@end
