//
//  GridPager.h
//  Grid Pager
//
//  Created by Brandon Tate on 5/27/14.
//  Copyright (c) 2014 Brandon Tate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTGridIndex.h"

/**
 *  Sets mode for wrapping.
 *
 *  Default: (BTGridWrappingDown | BTGridWrappingUp | BTGridWrappingRight | BTGridWrappingLeft)
 */
enum {
    BTGridWrappingNone                     = 0,
    BTGridWrappingUp                       = 1 << 0,
    BTGridWrappingDown                     = 1 << 1,
    BTGridWrappingLeft                     = 1 << 2,
    BTGridWrappingRight                    = 1 << 3
};
typedef NSUInteger BTGridWrappingMode;


/**
 *  Sets mode for resetting to beginning of row/column
 *
 *  BTGridResetModeRow          Resets to first column on row change
 *  BTGridResetModeColumn       Resets to first row on column change
 *
 *  Default: BTGridResetModeNone
 */
enum {
    BTGridResetModeNone                       = 0,
    BTGridResetModeRow                        = 1 << 0,
    BTGridResetModeColumn                     = 1 << 1
};
typedef NSUInteger BTGridResetMode;

@protocol BTGridPagerDelegate;
@protocol BTGridPagerDataSource;

@interface BTGridPager : UIScrollView<UIScrollViewDelegate>{
    @private
    __strong    BTGridIndex     *_currentIndex;
}

/** Data Source for the grid pager. */
@property (nonatomic, weak) IBOutlet    id<BTGridPagerDataSource>     gridPagerDataSource;

/** Delegate for grid pager actions. */
@property (nonatomic, weak) IBOutlet    id<BTGridPagerDelegate>       gridPagerDelegate;

/** The current index being displayed. */
@property (nonatomic, readonly)         BTGridIndex                   *currentIndex;

/** Number of views to load on each side of currently viewed slide.
 *  Defaults to 1
 */
@property (nonatomic)                   int                           gridPadding;

/** An integer bitmask that determines how directional wrapping is handled. */
@property (nonatomic)                   BTGridWrappingMode                gridWrappingMode;

/** An integer bitmask that determines how column and row resetting is handled. */
@property (nonatomic)                   BTGridResetMode               gridResetMode;


/**
 *  Reloads the views.
 *
 *  @param resetIndex Flag for whether to reset the current index when reloading.
 */
- (void) reloadData: (BOOL) resetIndex;


/**
 *  Scrolls to a specific grid index.
 *
 *  @param gridIndex The grid index to scroll through.
 *  @param animated Flag for animation
 */
- (void) scrollToIndex: (BTGridIndex *) gridIndex animated: (BOOL) animated;


@end


/**
 *  Protocol for handling grid pager events.
 */
@protocol BTGridPagerDelegate <NSObject>

@optional
/**
 *  Tells the delegate that a grid was selected
 *
 *  @param  gridPager   The grid pager
 *  @param  gridIndex   The index of the grid that was selected.
 *
 *  @return UIView  The view for the grid.
 */
- (void) gridPager: (BTGridPager *) gridPager didSelectViewAtGridIndex: (BTGridIndex *) gridIndex;

/**
 *  Tells the delegate that the grid pager will change pages.
 *
 *  @param gridPager The grid pager
 *  @param newIndex  The page index
 */
- (void) gridPager: (BTGridPager *) gridPager willChangePage: (BTGridIndex *) newIndex;

/**
 *  Tells the delegate that the grid pager changed pages.
 *
 *  @param gridPager The grid pager
 *  @param newIndex  The page index
 */
- (void) gridPager: (BTGridPager *) gridPager didChangePage: (BTGridIndex *) newIndex;

@end

/**
 *  Protocol for providing grid data.
 */
@protocol BTGridPagerDataSource <NSObject>

@required

/**
 *  The number of sections (rows) for this grid pager
 *
 *  @param  gridPager   The grid pager
 *
 *  @return NSInteger  The number of sections in the grid pager.
 */
- (NSInteger) numberOfRowsInGridPager: (BTGridPager *) gridPager;

/**
 *  The number of grids for the section
 *
 *  @param  gridPager   The grid pager
 *  @param  section The section to get grids for
 *
 *  @return NSInteger  The number of grids in the section.
 */
- (NSInteger) gridPager: (BTGridPager *) gridPager numberOfColumnsForRow: (NSInteger) section;


/**
 *  The grid to display in the given grid index
 *
 *  @param  gridPager   The grid pager
 *  @param  gridIndex   The index to get the grid for.
 *  @param  frame       The frame for the view
 *
 *  @return UIView  The view for the grid section.
 */
- (UIView *) gridPager: (BTGridPager *) gridPager gridViewAtGridIndex: (BTGridIndex *) gridIndex withFrame: (CGRect) frame;


@end