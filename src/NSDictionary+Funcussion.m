#import "NSDictionary+Funcussion.h"

@implementation NSDictionary (Funcussion)

-(void)each:(VoidDictIteratorBlock)aBlock {
  [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    aBlock(key,obj);
  }];
}

-(NSDictionary*)map:(DictionaryDictIteratorBlock)aBlock {
  NSMutableDictionary *result = [NSMutableDictionary dictionary];
  [self each:^(id key, id value) {
    [result addEntriesFromDictionary:aBlock(key,value)];
  }];
  return result;
}

-(NSDictionary*)mapValues:(ObjectDictIteratorBlock)aBlock {
  return [self map:^NSDictionary *(id key, id value) {
    return [NSDictionary dictionaryWithObject:aBlock(key,value) forKey:key];
  }];
}

-(NSArray*)mapToArray:(ObjectDictIteratorBlock)aBlock {
  NSMutableArray *result = [NSMutableArray array];
  [self each:^(id key, id value) {
    [result addObject:aBlock(key,value)];
  }];
  return result;
}

-(NSDictionary*)filter:(BoolDictIteratorBlock)aBlock {
  NSMutableDictionary *result = [NSMutableDictionary dictionary];
  [self each:^(id key, id value) {
    if (aBlock(key,value)) [result setObject:value forKey:key];
  }];
  return result;
}

-(id)reduce:(id)accumulator withBlock:(ObjectAcumulatorDictBlock)aBlock {
  __block id outerAccumulator = accumulator;
  [self each:^(id key, id value) {
    outerAccumulator = aBlock(outerAccumulator, key, value);
  }];
  return outerAccumulator;
}

-(BOOL)every:(BoolDictIteratorBlock)aBlock {
  __block BOOL evaluation = YES;
  [self each:^(id obj, id value) {
    if (evaluation) evaluation = aBlock(obj,value);
  }];
  return evaluation;
}

-(BOOL)any:(BoolDictIteratorBlock)aBlock {
  NSDictionary *matches = [self filter:^BOOL(id key, id value) {
    return aBlock(key,value);
  }];
  return [matches count] > 0;
}

@end