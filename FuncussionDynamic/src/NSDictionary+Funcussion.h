#import <Foundation/Foundation.h>

typedef void (^VoidDictIteratorBlock)(id key, id value);
typedef id (^ObjectDictIteratorBlock)(id key, id value);
typedef NSDictionary* (^DictionaryDictIteratorBlock)(id key, id value);
typedef BOOL (^BoolDictIteratorBlock)(id key, id value);
typedef id (^ObjectAcumulatorDictBlock)(id acc, id key, id value);

@interface NSDictionary (Funcussion)
-(void)each:(VoidDictIteratorBlock)aBlock;
-(NSDictionary*)map:(DictionaryDictIteratorBlock)aBlock;
-(NSDictionary*)mapValues:(ObjectDictIteratorBlock)aBlock;
-(NSArray*)mapToArray:(ObjectDictIteratorBlock)aBlock;
-(NSDictionary*)filter:(BoolDictIteratorBlock)aBlock;
-(id)reduceWithAccumulator:(id)accumulator andBlock:(ObjectAcumulatorDictBlock)aBlock;
-(BOOL)every:(BoolDictIteratorBlock)aBlock;
-(BOOL)any:(BoolDictIteratorBlock)aBlock;
@end