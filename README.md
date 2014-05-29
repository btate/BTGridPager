# BTGridPager

[![Version](https://img.shields.io/cocoapods/v/BTGridPager.svg?style=flat)](http://cocoadocs.org/docsets/BTGridPager)
[![License](https://img.shields.io/cocoapods/l/BTGridPager.svg?style=flat)](http://cocoadocs.org/docsets/BTGridPager)
[![Platform](https://img.shields.io/cocoapods/p/BTGridPager.svg?style=flat)](http://cocoadocs.org/docsets/BTGridPager)

BTGridPager is a subclass of UIScrollView that allows you to page through an infinite number of views both vertically and horizontally.  

## Usage

Implement the datasource/delegate methods in your controller.

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


Customize wrapping directions and reset modes using these bit masks

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
    
    ex: 
    self.gridPager.gridWrappingMode = (BTGridWrappingDown | BTGridWrappingUp | BTGridWrappingRight | BTGridWrappingLeft);
    self.gridPager.gridResetMode = (BTGridResetModeNone);
    
By default 1 view is loaded on each side of the current view.  If you need more views you can adjust using

	self.gridPager.gridPadding = (some integer);

## Requirements

## Installation

BTGridPager is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "BTGridPager"

## Author

Brandon Tate, brandonntate@gmail.com

## License

BTGridPager is available under the MIT license. See the LICENSE file for more info.

