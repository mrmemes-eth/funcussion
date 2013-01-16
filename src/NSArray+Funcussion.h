#import <Foundation/Foundation.h>

@interface NSArray (Funcussion)

-(id)firstObject;
-(NSArray*)flatten;
-(NSArray*)map:(id(^)(id obj))aBlock;
-(NSArray*)mapWithIndex:(id(^)(id obj, NSUInteger index))aBlock;
-(NSArray*)filter:(BOOL(^)(id obj))aBlock;
-(id)reduce:(id)accumulator withBlock:(id(^)(id accumulator, id obj))aBlock;
-(id)detect:(BOOL(^)(id obj))aBlock;
-(void)each:(void(^)(id obj))aBlock;
-(void)eachWithIndex:(void(^)(id obj, NSUInteger index))aBlock;
-(BOOL)every:(BOOL(^)(id obj))aBlock;
-(BOOL)any:(BOOL(^)(id obj))aBlock;

@end
