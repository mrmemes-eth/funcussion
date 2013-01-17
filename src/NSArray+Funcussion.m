#import "NSArray+Funcussion.h"

@implementation NSArray (Funcussion)

-(NSArray*)flatten {
  NSMutableArray *result = [NSMutableArray array];
  [self each:^(id obj) {
    if ([obj isKindOfClass:[NSArray class]]) {
      [result addObjectsFromArray:[obj flatten]];
    } else {
      [result addObject:obj];
    }
  }];
  return result;
}

-(id)firstObject {
  if ([self count] > 0) {
    return [self objectAtIndex:0];
  } else {
    return nil;
  }
}

-(void)each:(VoidIteratorBlock)aBlock {
  [self eachWithIndex:^(id object, NSUInteger index) {
    aBlock(object);
  }];
}

-(void)eachWithIndex:(VoidIteratorIndexedBlock)aBlock {
  [self enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
    aBlock(object,idx);
  }];
}

-(NSArray*)map:(ObjectIteratorBlock)aBlock {
  NSMutableArray *result = [NSMutableArray array];
  [self each:^(id object) {
    [result addObject:aBlock(object)];
  }];
  return result;
}

-(NSArray*)mapWithIndex:(ObjectIteratorIndexedBlock)aBlock {
  NSMutableArray *result = [NSMutableArray array];
  [self eachWithIndex:^(id object, NSUInteger idx) {
    [result addObject:aBlock(object,idx)];
  }];
  return result;
}

-(NSArray*)filter:(BoolIteratorBlock)aBlock {
  NSMutableArray *result = [NSMutableArray array];
  [self each:^(id object) {
    if (aBlock(object)) [result addObject: object];
  }];
  return result;
}

-(id)reduce:(id)accumulator withBlock:(ObjectAccumulatorBlock)aBlock {
  __block id outerAccumulator = accumulator;
  [self each:^(id obj) {
    outerAccumulator = aBlock(outerAccumulator,obj);
  }];
  return outerAccumulator;
}

-(id)detect:(BoolIteratorBlock)aBlock {
  return [[self filter:aBlock] firstObject];
}

-(BOOL)every:(BoolIteratorBlock)aBlock {
  __block BOOL evaluation = YES;
  [self each:^(id obj) {
    if (evaluation) evaluation = aBlock(obj);
  }];
  return evaluation;
}

-(BOOL)any:(BoolIteratorBlock)aBlock {
  NSArray *matches = [self filter:^BOOL(id obj) {
    return aBlock(obj);
  }];
  return [matches count] > 0;
}

@end