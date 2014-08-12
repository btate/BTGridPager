//
//  GridIndex.m
//  Grid Pager
//
//  Created by Brandon Tate on 5/27/14.
//  Copyright (c) 2014 Brandon Tate. All rights reserved.
//

#import "BTGridIndex.h"

@implementation BTGridIndex


- (id) initWithRow: (int) row column: (int) column{
    self = [super init];
    
    if (self) {
        self.row = row;
        self.column = column;
    }
    
    return self;
}

- (BOOL) isEqual:(BTGridIndex *)object{
    return (self.row == object.row) && (self.column == object.column);
}

+ (BTGridIndex *) gridIndexWithRow: (int) row column: (int) column{
    return [[BTGridIndex alloc] initWithRow:row column:column];
}

- (NSString *) description{
    
    return [NSString stringWithFormat:@"(%d, %d)", self.row, self.column];
    
}


-(id) copyWithZone: (NSZone *) zone
{
    BTGridIndex *copy = [[BTGridIndex allocWithZone: zone] initWithRow:self.row column:self.column];
    
    return copy;
}

@end
