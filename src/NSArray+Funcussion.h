#import <Foundation/Foundation.h>

typedef void (^VoidArrayIteratorBlock)(id obj);
typedef void (^VoidArrayIteratorIndexedBlock)(id obj, NSUInteger index);
typedef BOOL (^BoolArrayIteratorBlock)(id obj);
typedef id (^ObjectArrayIteratorBlock)(id obj);
typedef id (^ObjectArrayIteratorIndexedBlock)(id obj, NSUInteger index);
typedef id (^ObjectArrayAccumulatorBlock)(id acc, id obj);

@interface NSArray (Funcussion)

-(id)firstObject;
-(NSArray*)flatten;
-(void)each:(VoidArrayIteratorBlock)aBlock;
-(void)eachWithIndex:(VoidArrayIteratorIndexedBlock)aBlock;
-(NSArray*)map:(ObjectArrayIteratorBlock)aBlock;
-(NSArray*)mapWithIndex:(ObjectArrayIteratorIndexedBlock)aBlock;
-(NSArray*)filter:(BoolArrayIteratorBlock)aBlock;
-(id)reduce:(id)accumulator withBlock:(ObjectArrayAccumulatorBlock)aBlock;
-(id)detect:(BoolArrayIteratorBlock)aBlock;
-(BOOL)every:(BoolArrayIteratorBlock)aBlock;
-(BOOL)any:(BoolArrayIteratorBlock)aBlock;

@end
