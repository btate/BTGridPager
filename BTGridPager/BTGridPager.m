//
//  GridPager.m
//  Grid Pager
//
//  Created by Brandon Tate on 5/27/14.
//  Copyright (c) 2014 Brandon Tate. All rights reserved.
//

#import "BTGridPager.h"

@interface BTGridPager(){
    @private
    CGPoint         _lastOffset;
    int             _numRows;
    BOOL            _initCenterFlag;
    BOOL            _canScrollToFrame;
}

/** The index for the current grid being displayed. */
@property (nonatomic, strong)   BTGridIndex   *currentIndex;


#pragma mark - Setup

/**
 *  Sets up the scroll view properties
 */
- (void) setup;

/**
 *  Sets the content size according to the number of supported views
 */
- (void) calculateContentSize;


#pragma mark - View Handling

/**
 *  Loads the views for the current index
 */
- (void) loadViewsForCurrentIndex;

/**
 *  Cacluates a frame for the grid position
 *
 *  @param  gridPosition   The grid postion to calculate the frame for.
 *
 *  @return CGRect
 */
- (CGRect) frameForGridPosition: (BTGridIndex *) gridPosition;

/**
 *  Updates the scrollview offset without animation.
 */
- (void) updateOffset;

/**
 *  Checks the given index for wrap situation.
 *
 *  @param  index   The index to wrap.
 *
 *  @return BTGridIndex
 */
- (BTGridIndex *) wrapIndex: (BTGridIndex *) index;


#pragma mark - Gestures

/**
 *  Handles tap on scroll view.
 *
 *  @param  recognizer
 */
- (void)handleTap:(UITapGestureRecognizer *)recognizer;

@end

@implementation BTGridPager

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void) awakeFromNib{
    [super awakeFromNib];
    [self setup];
}

- (void) layoutSubviews{
    [super layoutSubviews];
    
    if (!_initCenterFlag)
        [self updateOffset];
    
    _initCenterFlag = YES;
}

/**
 *  Sets up the scroll view properties
 */
- (void) setup{
    
    _initCenterFlag = NO;
    _canScrollToFrame = NO;
    
    // Setup Scroll View
    self.pagingEnabled = YES;
    self.directionalLockEnabled = YES;
    self.bounces = NO;
    self.delegate = self;
    
    // Set Defaults
    self.gridPadding = 1;
    self.gridWrappingMode = (BTGridWrappingDown | BTGridWrappingUp | BTGridWrappingRight | BTGridWrappingLeft);
    self.gridResetMode = (BTGridResetModeNone);
    _currentIndex = [BTGridIndex gridIndexWithRow:0 column:0];
    
    // Add Tap Gesture
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(handleTap:)];
    [self addGestureRecognizer:recognizer];
    
    
    // Set up views
    [self calculateContentSize];
    [self loadViewsForCurrentIndex];
    
}

/**
 *  Sets the content size according to the number of supported views
 */
- (void) calculateContentSize{
    
    self.contentSize = CGSizeMake((self.frame.size.width * ((self.gridPadding * 2) + 1)), (self.frame.size.height * ((self.gridPadding * 2) + 1)));
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



#pragma mark - View Handling

/**
 *  Loads the views for the current index
 */
- (void) loadViewsForCurrentIndex{
    
    NSAssert([self.gridPagerDataSource respondsToSelector:@selector(gridPager:gridViewAtGridIndex:withFrame:)], @"Implement DataSource Methods!!!!!");
    NSAssert([self.gridPagerDataSource respondsToSelector:@selector(numberOfRowsInGridPager:)], @"Implement DataSource Methods!!!!!");
    NSAssert([self.gridPagerDataSource respondsToSelector:@selector(gridPager:numberOfColumnsForRow:)], @"Implement DataSource Methods!!!!!");
    
    _numRows = (int)[self.gridPagerDataSource numberOfRowsInGridPager:self];
    if (_numRows <= 0)
        return;
    
    NSArray *oldSubviews = self.subviews;
    
    // Track grid position
    int gridRow = 0;
    // One section back one section forward
    for (int r = (_currentIndex.row - self.gridPadding); r <= (_currentIndex.row + self.gridPadding); r++) {
        
        // Only need all views for current section
        if (_currentIndex.row == r) {
            
            // Track grid position
            int gridCol = 0;
            
            // One view back one grid forward
            for (int c = (_currentIndex.column - self.gridPadding); c <= (_currentIndex.column + self.gridPadding); c++) {
                
                
                // Index for view
                BTGridIndex *index = [self wrapIndex: [BTGridIndex gridIndexWithRow:r column:c]];
                
                // Check against reset mode
                if (c != _currentIndex.column && (self.gridResetMode & BTGridResetModeColumn))
                    index.row = 0;
                
                // Position in grid
                BTGridIndex *position = [BTGridIndex gridIndexWithRow:gridRow column:gridCol];
                
                CGRect frame = [self frameForGridPosition:position];
                
                
                [self addSubview:[self.gridPagerDataSource gridPager:self gridViewAtGridIndex:index withFrame:frame]];
                
                // If we've added the current view to its new position update the offset.
                if (c == _currentIndex.column) {
                    // Move to current index frame unanimated
                    [self updateOffset];
                }
                
                gridCol++;
            }
        }
        else{
            // Just get the first one for the section
            BTGridIndex *index = [self wrapIndex:[BTGridIndex gridIndexWithRow:r
                                                                        column:((self.gridResetMode & BTGridResetModeRow) ?
                                                                                0 : _currentIndex.column)]];
            
            // Position in grid
            BTGridIndex *position = [BTGridIndex gridIndexWithRow:gridRow column:self.gridPadding];
            CGRect frame = [self frameForGridPosition:position];
            [self addSubview:[self.gridPagerDataSource gridPager:self gridViewAtGridIndex:index withFrame:frame]];
        }
        
        gridRow++;
    }
    
    // Remove all old subviews
    for (UIView *subview in oldSubviews) {
        [subview removeFromSuperview];
    }

}

/**
 *  Cacluates a frame for the grid position
 *
 *  @param  gridPosition   The grid postion to calculate the frame for.
 *
 *  @return CGRect
 */
- (CGRect) frameForGridPosition: (BTGridIndex *) gridPosition{
    
    return CGRectMake((self.frame.size.width * gridPosition.column),
                      (self.frame.size.height * gridPosition.row),
                      self.frame.size.width, self.frame.size.height);
    
}


/**
 *  Resets the scrollview offset without animation.
 */
- (void) updateOffset{
    
    CGPoint newOffset = CGPointMake((self.frame.size.width * self.gridPadding), (self.frame.size.height * self.gridPadding));
    
    [self setContentOffset:newOffset animated:NO];
}


/**
 *  Checks the given index for wrap situation.
 *
 *  @param  index   The index to wrap.
 *
 *  @return BTGridIndex
 */
- (BTGridIndex *) wrapIndex: (BTGridIndex *) index{
    
    NSAssert([self.gridPagerDataSource respondsToSelector:@selector(gridPager:numberOfColumnsForRow:)], @"Implement DataSource Methods!!!!!");
    
    if (index.row >= _numRows)
        index.row = 0 + (index.row - _numRows);
    else if(index.row < 0)
        index.row = _numRows - (0 - index.row);
    
    int numCols = (int)[self.gridPagerDataSource gridPager:self numberOfColumnsForRow: index.row];
    
    if (index.column >= numCols )
        index.column = 0 + (index.column - numCols);
    else if(index.column < 0)
        index.column = numCols - (0 - index.column);
    
    return index;
    
}

/**
 *  Reloads the views.
 *
 *  @param resetIndex Flag for whether to reset the current index when reloading.
 */
- (void) reloadData: (BOOL) resetIndex{
    
    if (resetIndex) {
        _currentIndex.row = 0;
        _currentIndex.column = 0;
    }
    
    [self loadViewsForCurrentIndex];
    
}


/**
 *  Scrolls to a specific grid index.
 *
 *  @param gridIndex The grid index to scroll through.
 *  @param animated Flag for animation
 */
- (void) scrollToIndex: (BTGridIndex *) gridIndex animated: (BOOL) animated{
    
    NSAssert([self.gridPagerDataSource respondsToSelector:@selector(gridPager:gridViewAtGridIndex:withFrame:)], @"Implement DataSource Methods!!!!!");
    
    
    _canScrollToFrame = YES;
    
    
    // Figure out left, right, etc.
    BTGridIndex *gridPosition = [[BTGridIndex alloc] initWithRow:self.gridPadding column:self.gridPadding];
    
    // Figure out row direction
    if (gridIndex.row > _currentIndex.row) {
        gridPosition.row += 1;
    }
    else if(gridIndex.row < _currentIndex.row){
        gridPosition.row -= 1;
    }
    
    // Figure out column direction
    if (gridIndex.column > _currentIndex.column) {
        gridPosition.column += 1;
    }
    else if(gridIndex.column < _currentIndex.column){
        gridPosition.column -= 1;
    }
    
    // Update the view I'm scrolling to
    CGRect frame = [self frameForGridPosition:gridPosition];
    [self addSubview:[self.gridPagerDataSource gridPager:self gridViewAtGridIndex:[self wrapIndex:gridIndex] withFrame:frame]];
    
    
    // Move it
    _currentIndex = [self wrapIndex:gridIndex];
    [self scrollRectToVisible:[self frameForGridPosition:gridPosition] animated:animated];
    
    if (!animated)
        [self loadViewsForCurrentIndex];
}

#pragma mark - Gestures

/**
 *  Handles tap on scroll view.
 *
 *  @param  recognizer
 */
- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    
    if ([self.gridPagerDelegate respondsToSelector:@selector(gridPager:didSelectViewAtGridIndex:)]) {
        [self.gridPagerDelegate gridPager:self didSelectViewAtGridIndex: [_currentIndex copy]];
    }
    
}


#pragma mark - Overrides

- (void) scrollRectToVisible:(CGRect)rect animated:(BOOL)animated{
    if (_canScrollToFrame) {
        [super scrollRectToVisible:rect animated:animated];
    }
    
    _canScrollToFrame = NO;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    [self loadViewsForCurrentIndex];
    
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // Calculate page changes
    int pageX = floor((scrollView.contentOffset.x - _lastOffset.x) / self.frame.size.width);
    int pageY = floor((scrollView.contentOffset.y - _lastOffset.y) / self.frame.size.height);
    
    // Don't waste resources for no page change
    if (pageX == 0 && pageY == 0)
        return;
    
    // Update current index with page changes
    _currentIndex.column += pageX;
    _currentIndex.row += pageY;
    
    // Reset to the beginning of the new row
    if (pageY != 0 && (self.gridResetMode & BTGridResetModeRow)) {
        _currentIndex.column = 0;
    }
    
    // Reset to the beginning of the new column
    if (pageX != 0 && (self.gridResetMode & BTGridResetModeColumn)) {
        _currentIndex.row = 0;
    }
    
    _currentIndex = [self wrapIndex:_currentIndex];
    
    [self loadViewsForCurrentIndex];
    
}


// This is all about killing diagonal scrolls
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    // Set start offset here to kill it on diagonal
    _lastOffset = scrollView.contentOffset;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSAssert([self.gridPagerDataSource respondsToSelector:@selector(gridPager:numberOfColumnsForRow:)], @"Implement DataSource Methods!!!!!");
    
    float xDiff = scrollView.contentOffset.x - _lastOffset.x;
    float yDiff = scrollView.contentOffset.y - _lastOffset.y;
    BOOL lockScroll = NO;
    
    if (scrollView.isDragging) {
        // Stop diagonal
        if (xDiff != 0 && yDiff != 0)
            lockScroll = YES;
        
        // Just need to figure this out then I'm done
        // Check Row Wrapping
        if (_currentIndex.row == 0 && yDiff < 0){
            if(~self.gridWrappingMode & BTGridWrappingUp)
                lockScroll = YES;
        }
        else if (_currentIndex.row == (_numRows - 1) && yDiff > 0){
            if(~self.gridWrappingMode & BTGridWrappingDown)
                lockScroll = YES;
        }
        
        // Check Column Wrapping
        int numCols = (int)[self.gridPagerDataSource gridPager:self numberOfColumnsForRow:_currentIndex.row];
        if (_currentIndex.column == 0 && xDiff < 0){
            if(~self.gridWrappingMode & BTGridWrappingLeft)
                lockScroll = YES;
        }
        else if (_currentIndex.column == (numCols - 1) && xDiff > 0){
            if(~self.gridWrappingMode & BTGridWrappingRight)
                lockScroll = YES;
        }
    }
    
    if (lockScroll) {
        // Reset and kill scrolling
        [scrollView setContentOffset:_lastOffset animated:NO];
        scrollView.scrollEnabled = NO;
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    // Make sure scrolling is back on.
    scrollView.scrollEnabled = YES;
    
}

@end
