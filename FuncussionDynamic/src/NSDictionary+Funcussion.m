#import "NSDictionary+Funcussion.h"

@implementation NSDictionary (Funcussion)

-(void)each:(VoidDictIteratorBlock)aBlock {
  [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    aBlock(key,obj);
  }];
}

-(id)reduceWithAccumulator:(id)accumulator andBlock:(ObjectAcumulatorDictBlock)aBlock {
  __block id outerAccumulator = accumulator;
  [self each:^(id key, id value) {
    outerAccumulator = aBlock(outerAccumulator, key, value);
  }];
  return outerAccumulator;
}

-(NSDictionary*)map:(DictionaryDictIteratorBlock)aBlock {
  return [self reduceWithAccumulator:[NSMutableDictionary dictionary]
                            andBlock:^id(id acc, id key, id value) {
    [acc addEntriesFromDictionary:aBlock(key,value)];
    return acc;
  }];
}

-(NSDictionary*)mapValues:(ObjectDictIteratorBlock)aBlock {
  return [self map:^NSDictionary *(id key, id value) {
    return [NSDictionary dictionaryWithObject:aBlock(key,value) forKey:key];
  }];
}

-(NSArray*)mapToArray:(ObjectDictIteratorBlock)aBlock {
  return [self reduceWithAccumulator:@[] andBlock:^id(id acc, id key, id value) {
    return [acc arrayByAddingObject:aBlock(key,value)];
  }];
}

-(NSDictionary*)filter:(BoolDictIteratorBlock)aBlock {
  return [self reduceWithAccumulator:[NSMutableDictionary dictionary]
                            andBlock:^id(id acc, id key, id value) {
    if(aBlock(key,value)) [acc setObject:value forKey:key];
    return acc;
  }];
}

-(BOOL)every:(BoolDictIteratorBlock)aBlock {
  return [[self reduceWithAccumulator:@YES andBlock:^id(id acc, id key, id value) {
    return [acc boolValue] ? [NSNumber numberWithBool:aBlock(key,value)] : acc;
  }] boolValue];
}

-(BOOL)any:(BoolDictIteratorBlock)aBlock {
 return [[self filter:^BOOL(id key, id value) {
    return aBlock(key,value);
  }] count] > 0;
}

@end