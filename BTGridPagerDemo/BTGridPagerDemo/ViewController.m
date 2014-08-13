//
//  ViewController.m
//  BTGridPagerDemo
//
//  Created by Brandon Tate on 5/29/14.
//  Copyright (c) 2014 Brandon Tate. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - GridPagerDelegate

/**
 *  Tells the delegate that a grid was selected
 *
 *  @param  gridPager   The grid pager
 *  @param  gridIndex   The index of the grid that was selected.
 *
 *  @return UIView  The view for the grid.
 */
- (void) gridPager: (BTGridPager *) gridPager didSelectViewAtGridIndex: (BTGridIndex *) gridIndex{
    NSLog(@"selected %@", gridIndex);
}

/**
 *  Tells the delegate that the grid pager will change pages.
 *
 *  @param gridPager The grid pager
 *  @param newIndex  The page index
 */
- (void) gridPager: (BTGridPager *) gridPager willChangePage: (BTGridIndex *) newIndex{
    NSLog(@"will change pages %@", newIndex);
}

/**
 *  Tells the delegate that the grid pager changed pages.
 *
 *  @param gridPager The grid pager
 *  @param newIndex  The page index
 */
- (void) gridPager: (BTGridPager *) gridPager didChangePage: (BTGridIndex *) newIndex{
    NSLog(@"on new page %@", newIndex);
}

#pragma mark - GridPagerDataSource

/**
 *  The number of sections (rows) for this grid pager
 *
 *  @param  gridPager   The grid pager
 *
 *  @return NSInteger  The number of sections in the grid pager.
 */
- (NSInteger) numberOfRowsInGridPager: (BTGridPager *) gridPager{
    return 4;
}

/**
 *  The number of grids for the section
 *
 *  @param  gridPager   The grid pager
 *  @param  section The section to get grids for
 *
 *  @return NSInteger  The number of grids in the section.
 */
- (NSInteger) gridPager: (BTGridPager *) gridPager numberOfColumnsForRow: (NSInteger) section{
    return 3;
}


/**
 *  The grid to display in the given grid index
 *
 *  @param  gridPager   The grid pager
 *  @param  gridIndex   The index to get the grid for.
 *  @param  frame       The frame for the view
 *
 *  @return UIView  The view for the grid.
 */
- (UIView *) gridPager: (BTGridPager *) gridPager gridViewAtGridIndex: (BTGridIndex *) gridIndex withFrame: (CGRect) frame{
    
    UILabel *view = [[UILabel alloc] initWithFrame:frame];
    view.textAlignment = NSTextAlignmentCenter;
    
    switch (gridIndex.column) {
        case 0:
            view.backgroundColor = [UIColor yellowColor];
            break;
        case 1:
            view.backgroundColor = [UIColor redColor];
            break;
        case 2:
            view.backgroundColor = [UIColor greenColor];
            break;
        case 3:
            view.backgroundColor = [UIColor blueColor];
            break;
        default:
            view.backgroundColor = [UIColor whiteColor];
            break;
    }
    view.text = [NSString stringWithFormat:@"View %@", gridIndex];
    
    return view;
}

@end
