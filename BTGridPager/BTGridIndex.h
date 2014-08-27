//
//  GridIndex.h
//  Grid Pager
//
//  Created by Brandon Tate on 5/27/14.
//  Copyright (c) 2014 Brandon Tate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTGridIndex : NSObject<NSCopying>

/** The index row. */
@property (nonatomic)   NSInteger   row;

/** The index column. */
@property (nonatomic)   NSInteger   column;

/**
 *  Initializer with row column properties.
 *
 *  @param row    The index row
 *  @param column The index column
 *
 *  @return The grid index
 */
- (id) initWithRow: (NSInteger) row column: (NSInteger) column;

/**
 *  Class method for creating a grid index.
 *
 *  @param row    The index row
 *  @param column The index column
 *
 *  @return The grid index
 */
+ (BTGridIndex *) gridIndexWithRow: (NSInteger) row column: (NSInteger) column;

@end
