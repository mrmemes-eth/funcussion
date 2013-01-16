#import <SenTestingKit/SenTestingKit.h>
#import "NSArray+Funcussion.h"

@interface NSArrayFuncussionTest : SenTestCase

@end

@implementation NSArrayFuncussionTest

-(void)testFlattenOnFlatArray {
  NSArray *flatArray = [NSArray arrayWithObjects:@"one", @"two", nil];
  STAssertEqualObjects([flatArray flatten], flatArray, nil);
}

-(void)testFlattenOnNestedArray {
  NSArray *flatArray = [NSArray arrayWithObjects:@"one", @"two", nil];
  NSArray *nestedArray = [NSArray arrayWithObjects:@"microphone", @"check", flatArray, flatArray, nil];
  NSArray *flattenedArray = [NSArray arrayWithObjects:@"microphone", @"check", @"one", @"two", @"one", @"two", nil];
  STAssertEqualObjects([nestedArray flatten], flattenedArray, nil);
}

-(void)testFlattenOnDeeplyNestedArray {
  NSArray *nestedArray = [NSArray arrayWithObjects:
                          [NSArray arrayWithObjects:@"microphone", @"check", nil],
                          [NSArray arrayWithObjects:@"one",
                           [NSArray arrayWithObjects:@"two", nil],
                           nil],
                          [NSArray arrayWithObjects:@"what",
                           [NSArray arrayWithObjects:@"is",
                            [NSArray arrayWithObjects:@"this", nil],
                            nil],
                           nil],
                          nil];
  NSArray *flattenedArray = [NSArray arrayWithObjects:@"microphone", @"check", @"one", @"two", @"what", @"is", @"this", nil];
  STAssertEqualObjects([nestedArray flatten], flattenedArray, nil);
}

-(void)testNumericReduction {
  NSArray *array = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4],[NSNumber numberWithInt:5], nil];
  NSNumber *reduction = [array reduce:[NSNumber numberWithInt:0] withBlock:^id(id accumulator, id obj) {
    return [NSNumber numberWithInt:[accumulator intValue] + [obj intValue]];
  }];
  STAssertEqualObjects(reduction, [NSNumber numberWithInt:15], nil);
}

-(void)testStringReduction {
  NSArray *array = [NSArray arrayWithObjects:@"chupa", @"cabra", @"nibre", nil];
  NSString *reduction = [array reduce:@"el" withBlock:^id(id accumulator, id obj) {
    return [accumulator stringByAppendingFormat:@", %@", obj];
  }];
  STAssertEqualObjects(reduction, @"el, chupa, cabra, nibre", nil);
}

-(void)testEveryYesWithBools {
  NSArray *array = [NSArray arrayWithObjects:[NSNumber numberWithBool:YES], [NSNumber numberWithBool:YES], [NSNumber numberWithBool:YES], nil];
  BOOL every = [array every:^BOOL(id obj) {
    return [obj boolValue];
  }];
  STAssertTrue(every, nil);
}

-(void)testEveryNoWithBools {
  NSArray *array = [NSArray arrayWithObjects:[NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], nil];
  BOOL every = [array every:^BOOL(id obj) {
    return [obj boolValue];
  }];
  STAssertFalse(every, nil);
}

-(void)testEveryYes {
  NSArray *array = [NSArray arrayWithObjects:@"Cat", @"Dog", @"Duck", nil];
  BOOL every = [array every:^BOOL(NSString *obj) {
    return obj != (id)[NSNull null];
  }];
  STAssertTrue(every, nil);
}

-(void)testEveryNo {
  NSArray *array = [NSArray arrayWithObjects:@"Cat", @"Dog", @"Duck", nil];
  BOOL every = [array every:^BOOL(NSString *obj) {
    return obj == (id)[NSNull null];
  }];
  STAssertFalse(every, nil);
}

@end
