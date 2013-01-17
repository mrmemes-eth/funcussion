#import <Foundation/Foundation.h>

typedef void (^VoidIteratorBlock)(id obj);
typedef void (^VoidIteratorIndexedBlock)(id obj, NSUInteger index);
typedef BOOL (^BoolIteratorBlock)(id obj);
typedef id (^ObjectIteratorBlock)(id obj);
typedef id (^ObjectIteratorIndexedBlock)(id obj, NSUInteger index);
typedef id (^ObjectAccumulatorBlock)(id acc, id obj);

@interface NSArray (Funcussion)

-(id)firstObject;
-(NSArray*)flatten;
-(void)each:(VoidIteratorBlock)aBlock;
-(void)eachWithIndex:(VoidIteratorIndexedBlock)aBlock;
-(NSArray*)map:(ObjectIteratorBlock)aBlock;
-(NSArray*)mapWithIndex:(ObjectIteratorIndexedBlock)aBlock;
-(NSArray*)filter:(BoolIteratorBlock)aBlock;
-(id)reduce:(id)accumulator withBlock:(id(^)(id accumulator, id obj))aBlock;
-(id)detect:(BoolIteratorBlock)aBlock;
-(BOOL)every:(BoolIteratorBlock)aBlock;
-(BOOL)any:(BoolIteratorBlock)aBlock;

@end
