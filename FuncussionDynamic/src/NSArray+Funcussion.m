#import "NSArray+Funcussion.h"

@implementation NSArray (Funcussion)

-(void)each:(VoidArrayIteratorBlock)aBlock {
  [self eachWithIndex:^(id object, NSUInteger index) {
    aBlock(object);
  }];
}

-(void)eachWithIndex:(VoidArrayIteratorIndexedBlock)aBlock {
  [self enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
    aBlock(object,idx);
  }];
}

-(id)reduceWithAccumulator:(id)accumulator andIndexedBlock:(ObjectArrayAccumulatorIndexedBlock)aBlock {
  __block id outerAccumulator = accumulator;
  [self eachWithIndex:^(id obj, NSUInteger index) {
    outerAccumulator = aBlock(outerAccumulator, obj, index);
  }];
  return outerAccumulator;
}

-(id)reduceWithAccumulator:(id)accumulator andBlock:(ObjectArrayAccumulatorBlock)aBlock {
  return [self reduceWithAccumulator:accumulator andIndexedBlock:^id(id acc, id obj, NSUInteger index) {
    return aBlock(acc,obj);
  }];
}

-(NSArray*)map:(ObjectArrayIteratorBlock)aBlock {
  return [self reduceWithAccumulator:@[] andBlock:^id(id acc, id obj) {
    return [acc arrayByAddingObject:aBlock(obj)];
  }];
}

-(NSArray*)mapWithIndex:(ObjectArrayIteratorIndexedBlock)aBlock {
  return [self reduceWithAccumulator:@[] andIndexedBlock:^id(id acc, id obj, NSUInteger index) {
    return [acc arrayByAddingObject:aBlock(obj,index)];
  }];
}

-(NSArray*)filter:(BoolArrayIteratorBlock)aBlock {
  return [self reduceWithAccumulator:@[] andBlock:^id(id acc, id obj) {
    return aBlock(obj) ? [acc arrayByAddingObject:obj] : acc;
  }];
}

-(id)detect:(BoolArrayIteratorBlock)aBlock {
  return [[self filter:aBlock] firstObject];
}

-(BOOL)every:(BoolArrayIteratorBlock)aBlock {
  return [[self reduceWithAccumulator:@YES andBlock:^id(id acc, id obj) {
    return [NSNumber numberWithBool:([acc boolValue] ? aBlock(obj) : [acc boolValue])];
  }] boolValue];
}

-(BOOL)any:(BoolArrayIteratorBlock)aBlock {
  return [[self filter:^BOOL(id obj) {
    return aBlock(obj);
  }] count] > 0;
}

#pragma mark - convenience methods

-(NSArray*)flatten {
  return [self reduceWithAccumulator:@[] andBlock:^id(id acc, id obj) {
    if ([obj isKindOfClass:[NSArray class]]) {
      return [acc arrayByAddingObjectsFromArray:[obj flatten]];
    } else {
      return [acc arrayByAddingObject:obj];
    }
  }];
}

-(id)firstObject {
  if ([self count] > 0) {
    return [self objectAtIndex:0];
  } else {
    return nil;
  }
}

-(id)max:(ObjectArrayComparatorBlock)aBlock {
  return [self reduceWithAccumulator:[self firstObject] andBlock:^id(id max, id obj) {
    return aBlock(max,obj) == NSOrderedAscending ? obj : max;
  }];
}

-(id)min:(ObjectArrayComparatorBlock)aBlock {
  return [self reduceWithAccumulator:[self firstObject] andBlock:^id(id max, id obj) {
    return aBlock(max,obj) == NSOrderedDescending ? obj : max;
  }];
}

@end