#import <Foundation/Foundation.h>

typedef void (^VoidArrayIteratorBlock)(id obj);
typedef void (^VoidArrayIteratorIndexedBlock)(id obj, NSUInteger index);
typedef BOOL (^BoolArrayIteratorBlock)(id obj);
typedef NSComparisonResult (^ObjectArrayComparatorBlock)(id obj, id otherObj);
typedef id (^ObjectArrayIteratorBlock)(id obj);
typedef id (^ObjectArrayIteratorIndexedBlock)(id obj, NSUInteger index);
typedef id (^ObjectArrayAccumulatorBlock)(id acc, id obj);
typedef id (^ObjectArrayAccumulatorIndexedBlock)(id acc, id obj, NSUInteger index);

@interface NSArray (Funcussion)

-(id)firstObject;
-(NSArray*)flatten;
-(void)each:(VoidArrayIteratorBlock)aBlock;
-(void)eachWithIndex:(VoidArrayIteratorIndexedBlock)aBlock;
-(NSArray*)map:(ObjectArrayIteratorBlock)aBlock;
-(NSArray*)mapWithIndex:(ObjectArrayIteratorIndexedBlock)aBlock;
-(NSArray*)filter:(BoolArrayIteratorBlock)aBlock;
-(id)reduceWithAccumulator:(id)accumulator andBlock:(ObjectArrayAccumulatorBlock)aBlock;
-(id)reduceWithAccumulator:(id)accumulator andIndexedBlock:(ObjectArrayAccumulatorIndexedBlock)aBlock;
-(id)detect:(BoolArrayIteratorBlock)aBlock;
-(BOOL)every:(BoolArrayIteratorBlock)aBlock;
-(BOOL)any:(BoolArrayIteratorBlock)aBlock;
-(id)max:(ObjectArrayComparatorBlock)aBlock;
-(id)min:(ObjectArrayComparatorBlock)aBlock;

@end
