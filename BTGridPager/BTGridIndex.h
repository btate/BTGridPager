//
//  GridIndex.h
//  Grid Pager
//
//  Created by Brandon Tate on 5/27/14.
//  Copyright (c) 2014 Brandon Tate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTGridIndex : NSObject<NSCopying>

@property (nonatomic)   int   row;
@property (nonatomic)   int   column;

- (id) initWithRow: (int) row column: (int) column;
+ (BTGridIndex *) gridIndexWithRow: (int) row column: (int) column;

@end
