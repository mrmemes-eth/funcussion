#import <SenTestingKit/SenTestingKit.h>
#import "NSArray+Funcussion.h"

@interface NSArrayFuncussionTest : SenTestCase
@property NSArray *simpleArray;
@property NSArray *nestedArray;
@property NSArray *repetitiveArray;
@end

@implementation NSArrayFuncussionTest

@synthesize simpleArray, nestedArray;

-(void)setUp {
  [self setSimpleArray:[NSArray arrayWithObjects:@"one",@"two",nil]];
  [self setNestedArray:[NSArray arrayWithObjects:@"microphone", @"check", self.simpleArray, self.simpleArray, nil]];
  [self setRepetitiveArray:[NSArray arrayWithObjects:@"one", @"one", @"won", @"wonder" @"wunder", nil]];
}

-(void)tearDown {
  [self setSimpleArray:nil];
  [self setNestedArray:nil];
}

-(void)testFlattenOnFlatArray {
  STAssertEqualObjects([self.simpleArray flatten], self.simpleArray, nil);
}

-(void)testFlattenOnNestedArray {
  NSArray *flattenedArray = [NSArray arrayWithObjects:@"microphone", @"check", @"one", @"two", @"one", @"two", nil];
  STAssertEqualObjects([self.nestedArray flatten], flattenedArray, nil);
}

-(void)testFlattenOnDeeplyNestedArray {
  NSArray *deeplyNestedArray = [NSArray arrayWithObjects:
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
  STAssertEqualObjects([deeplyNestedArray flatten], flattenedArray, nil);
}

-(void)testFirstObjectRetrieval {
  STAssertEqualObjects([self.simpleArray firstObject], @"one", nil);
}

-(void)testEachIteration {
  __block NSUInteger count = 0;
  __block NSMutableString *accumulator = [NSMutableString string];
  [self.simpleArray each:^(id obj) {
    count += 1;
    [accumulator appendString:obj];
  }];
  STAssertEquals([self.simpleArray count], count, nil);
  STAssertEqualObjects(@"onetwo", accumulator, nil);
}

-(void)testEachWithIndexIteration {
  __block NSMutableString *accumulator = [NSMutableString string];
  [self.simpleArray eachWithIndex:^(id obj, NSUInteger index) {
    [accumulator appendFormat:@"%d",index];
  }];
  STAssertEqualObjects(@"01", accumulator, nil);
}

-(void)testMap {
  NSArray *mappedArray = [self.simpleArray map:^id(id obj) {
    return [obj uppercaseString];
  }];
  NSArray *resultArray = [NSArray arrayWithObjects:@"ONE",@"TWO", nil];
  STAssertEqualObjects(mappedArray, resultArray, nil);
}

-(void)testMapWithIndex {
  NSArray *mappedArray = [self.simpleArray mapWithIndex:^id(id obj, NSUInteger index) {
    return [[obj uppercaseString] stringByAppendingFormat:@"%d", index];
  }];
  NSArray *resultArray = [NSArray arrayWithObjects:@"ONE0",@"TWO1", nil];
  STAssertEqualObjects(mappedArray, resultArray, nil);
}

-(void)testFilter {
  NSArray *mappedArray = [self.simpleArray filter:^BOOL(id obj) {
    return [obj isEqualToString:@"two"];
  }];
  NSArray *resultArray = [NSArray arrayWithObject:@"two"];
  STAssertEqualObjects(mappedArray, resultArray, nil);
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

-(void)testDetection {
  __block	NSPredicate *containPred = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", @"won"];
  NSString *detectedString = [self.repetitiveArray detect:^BOOL(id obj) {
    return [containPred evaluateWithObject:obj];
  }];
  STAssertEqualObjects(detectedString, @"won", nil);
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
  BOOL every = [self.simpleArray every:^BOOL(NSString *obj) {
    return obj != (id)[NSNull null];
  }];
  STAssertTrue(every, nil);
}

-(void)testEveryNo {
  BOOL every = [self.simpleArray every:^BOOL(NSString *obj) {
    return obj == (id)[NSNull null];
  }];
  STAssertFalse(every, nil);
}

-(void)testAnyYes {
  BOOL any = [self.simpleArray any:^BOOL(id obj) {
    return [obj isEqualToString:@"two"];
  }];
  STAssertTrue(any, nil);
}

-(void)testAnyNo {
  BOOL any = [self.simpleArray any:^BOOL(id obj) {
    return [obj isEqualToString:@"three"];
  }];
  STAssertFalse(any, nil);
}

@end
