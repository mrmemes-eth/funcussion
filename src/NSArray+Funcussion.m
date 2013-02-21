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

-(id)reduceWithAccumulator:(id)accumulator andBlock:(ObjectArrayAccumulatorBlock)aBlock {
  __block id outerAccumulator = accumulator;
  [self each:^(id obj) {
    outerAccumulator = aBlock(outerAccumulator,obj);
  }];
  return outerAccumulator;
}

-(NSArray*)map:(ObjectArrayIteratorBlock)aBlock {
  return [self reduceWithAccumulator:@[] andBlock:^id(id acc, id obj) {
    return [acc arrayByAddingObject:aBlock(obj)];
  }];
}

-(NSArray*)mapWithIndex:(ObjectArrayIteratorIndexedBlock)aBlock {
  NSMutableArray *result = [NSMutableArray array];
  [self eachWithIndex:^(id object, NSUInteger idx) {
    [result addObject:aBlock(object,idx)];
  }];
  return result;
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

@end