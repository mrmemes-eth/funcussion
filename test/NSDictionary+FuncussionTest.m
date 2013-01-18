#import <SenTestingKit/SenTestingKit.h>
#import "NSDictionary+Funcussion.h"

@interface NSDictionaryFuncussionTest : SenTestCase
@property NSDictionary *simpleDict;
@property NSDictionary *biggerDict;
@end

@implementation NSDictionaryFuncussionTest

@synthesize simpleDict;

-(void)setUp {
  [self setSimpleDict:[NSDictionary dictionaryWithObjectsAndKeys:
                       [NSNumber numberWithInt:1], @"one",
                       [NSNumber numberWithInt:2], @"two", nil]];
  [self setBiggerDict:[NSDictionary dictionaryWithObjectsAndKeys:
                       [NSNumber numberWithInt:1], @"one",
                       [NSNumber numberWithInt:2], @"two",
                       [NSNumber numberWithInt:3], @"three",
                       @"BAZ!!!", @"baz",
                       [NSNumber numberWithInt:1], @"four",
                       [NSArray array], @"boz", nil]];
}

-(void)testEachIteration {
  __block NSMutableString *accumulator = [NSMutableString string];
  [self.simpleDict each:^(id key, id value) {
    [accumulator appendFormat:@"%@:%@:",key,value];
  }];
  STAssertEqualObjects(@"one:1:two:2:", accumulator, nil);
}

-(void)testMap {
  NSDictionary *mappedDict = [self.simpleDict map:^id(id key, id value) {
    return [NSDictionary dictionaryWithObject:[key stringByAppendingFormat:@":%@",value] forKey:key] ;
  }];
  NSDictionary *comparisonDict = [NSDictionary dictionaryWithObjectsAndKeys:@"one:1",@"one",@"two:2",@"two", nil];
  STAssertEqualObjects(mappedDict, comparisonDict, nil);
}

-(void)testMapValues {
  NSDictionary *mappedDict = [self.simpleDict mapValues:^id(id key, id value) {
    return [key stringByAppendingFormat:@":%@",value];
  }];
  NSDictionary *comparisonDict = [NSDictionary dictionaryWithObjectsAndKeys:@"one:1",@"one",@"two:2",@"two", nil];
  STAssertEqualObjects(mappedDict, comparisonDict, nil);
}

-(void)testMapToArray {
  NSArray *mappedDict = [self.simpleDict mapToArray:^id(id key, id value) {
    return [key stringByAppendingFormat:@":%@",value];
  }];
  NSArray *comparisonArray = [NSArray arrayWithObjects:@"one:1",@"two:2",nil];
  STAssertEqualObjects(mappedDict, comparisonArray, nil);
}

-(void)testFilter {
  NSDictionary *mappedDict = [self.simpleDict filter:^BOOL(id key, id value) {
    return [key isEqualToString:@"one"];
  }];
  NSDictionary *comparisonDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithUnsignedInteger:1] forKey:@"one"];
  STAssertEqualObjects(mappedDict, comparisonDict, nil);
}

-(void)testFilterMany {
  NSDictionary *mappedDict = [self.biggerDict filter:^BOOL(id key, id value) {
    return [value isKindOfClass:[NSNumber class]];
  }];
  NSDictionary *comparisonDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithInt:1], @"one",
                                  [NSNumber numberWithInt:2], @"two",
                                  [NSNumber numberWithInt:3], @"three",
                                  [NSNumber numberWithInt:1], @"four", nil];
  STAssertEqualObjects(mappedDict, comparisonDict, nil);
}

-(void)testNumericReduction {
  NSNumber *accumulator = [NSNumber numberWithInt:0];
  NSNumber *reduction = [self.simpleDict reduce:accumulator withBlock:^id(id accumulator, id key, id value) {
    return [NSNumber numberWithInt:([accumulator intValue] + [value intValue])];
  }];
  STAssertEqualObjects(reduction, [NSNumber numberWithInt:3], nil);
}

-(void)testStringReduction {
  NSString *accumulator = @"";
  NSNumber *reduction = [self.simpleDict reduce:accumulator withBlock:^id(id accumulator, id key, id value) {
    return [accumulator stringByAppendingFormat:@"%@:%@:",key,value];
  }];
  STAssertEqualObjects(reduction, @"one:1:two:2:", nil);
}

-(void)testEveryYes {
  BOOL everyYes = [self.simpleDict every:^BOOL(id key, id value) {
    return [key isKindOfClass:[NSString class]];
  }];
  STAssertTrue(everyYes, nil);
}

-(void)testEveryNo {
  BOOL everyNo = [self.simpleDict every:^BOOL(id key, id value) {
    return [value isKindOfClass:[NSString class]];
  }];
  STAssertFalse(everyNo, nil);
}

-(void)testAnyYes {
  BOOL anyYes = [self.biggerDict any:^BOOL(id key, id value) {
    return [value isKindOfClass:[NSArray class]];
  }];
  STAssertTrue(anyYes, nil);
}

-(void)testAnyNo {
  BOOL anyNo = [self.biggerDict any:^BOOL(id key, id value) {
    return [key isKindOfClass:[NSArray class]];
  }];
  STAssertFalse(anyNo, nil);
}

@end