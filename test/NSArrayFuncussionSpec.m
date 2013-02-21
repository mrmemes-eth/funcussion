#import "Kiwi.h"
#import "NSArray+Funcussion.h"

SPEC_BEGIN(NSArrayFuncussion)

__block NSArray *simpleArray;
__block NSArray *nestedArray;
__block NSArray *repetitiveArray;
__block NSArray *numericArray;

beforeEach(^{
  simpleArray = @[@"one",@"two"];
  nestedArray = @[@"microphone",@"check",simpleArray,simpleArray];
  repetitiveArray = @[@"one",@"one",@"won",@"wonder",@"wunder"];
  numericArray = @[@1,@2,@3,@4,@5];
});

afterEach(^{
  simpleArray = nil;
  nestedArray = nil;
  repetitiveArray = nil;
});

describe(@"flatten", ^{
  it(@"does not change flat arrays", ^{
    [[[simpleArray flatten] should] equal:simpleArray];
  });

  it(@"flattens nested arrays", ^{
    NSArray *flattenedArray = @[@"microphone",@"check",@"one",@"two",@"one",@"two"];
    [[[nestedArray flatten] should] equal:flattenedArray];
  });

  it(@"flattens deeply nested arrays", ^{
    NSArray *deeplyNestedArray = @[@[@"microphone",@"check"],@[@"one",@[@"two"]],@[@"what",@[@"is",@[@"this"]]]];
    NSArray *flattenedArray = @[@"microphone",@"check",@"one",@"two",@"what",@"is",@"this"];
    [[[deeplyNestedArray flatten] should] equal:flattenedArray];
  });
});

describe(@"firstObject", ^{
  it(@"returns the first object", ^{
    [[[simpleArray firstObject] should] equal:@"one"];
  });
});

describe(@"each:", ^{
  __block NSUInteger count;
  __block NSMutableString *accumulator;

  beforeEach(^{
    count = 0;
    accumulator = [NSMutableString string];
    [simpleArray each:^(id obj) {
      count += 1;
      [accumulator appendString:obj];
    }];
  });

  it(@"iterates the correct number of times", ^{
    [[theValue(count) should] equal:theValue(2)];
  });

  it(@"yields consecutive objects to the block", ^{
    [[accumulator should] equal:@"onetwo"];
  });
});

describe(@"eachWithIndex:", ^{
  it(@"yields the object and an index to the block", ^{
    __block NSMutableString *accumulator = [NSMutableString string];
    [simpleArray eachWithIndex:^(id obj, NSUInteger index) {
      [accumulator appendFormat:@"%d:%@:",index, obj];
    }];
    [[accumulator should] equal:@"0:one:1:two:"];
  });
});

describe(@"map:", ^{
  it(@"returns a new array with the function applied to each element", ^{
    NSArray *mappedArray = [simpleArray map:^id(id obj) {
      return [obj uppercaseString];
    }];
    [[mappedArray should] equal:@[@"ONE",@"TWO"]];
  });
});

describe(@"mapWithIndex:", ^{
  it(@"returns a new array with the function applied to each element, passes index", ^{
    NSArray *mappedArray = [simpleArray mapWithIndex:^id(id obj, NSUInteger index) {
      return [[obj uppercaseString] stringByAppendingFormat:@":%d",index];
    }];
    [[mappedArray should] equal:@[@"ONE:0",@"TWO:1"]];
  });
});

describe(@"filter:", ^{
  it(@"returns only elements the block evaluates to YES for", ^{
    NSArray *filteredArray = [simpleArray filter:^BOOL(id obj) {
      return [obj isEqualToString:@"two"];
    }];
    [[filteredArray should] equal:@[@"two"]];
  });
  it(@"returns an empty array in case of no evaluations to YES", ^{
    [[[simpleArray filter:^BOOL(id obj) { return NO; }] should] equal:@[]];
  });
});

describe(@"reduceWithAccumulator:andIndexedBlock:", ^{
  it(@"handles numeric reduction", ^{
    NSNumber *reduction = [numericArray reduceWithAccumulator:@0 andIndexedBlock:^id(id acc, id obj, NSUInteger index) {
      return [NSNumber numberWithInt:([acc intValue] + [obj intValue] + index)];
    }];
    [[reduction should] equal:@25];
  });
  it(@"handles string reduction", ^{
    NSArray *array = @[@"chupa",@"cabra",@"nibre"];
    NSString *reduction = [array reduceWithAccumulator:@"el" andIndexedBlock:^id(id acc, id obj, NSUInteger index) {
      return [acc stringByAppendingFormat:@", %@:%d",obj,index];
    }];
    [[reduction should] equal:@"el, chupa:0, cabra:1, nibre:2"];
  });
});

describe(@"reduceWithAccumulator:andBlock:", ^{
  it(@"handles numeric reduction", ^{
    NSNumber *reduction = [numericArray reduceWithAccumulator:@0 andBlock:^id(id acc, id obj) {
      return [NSNumber numberWithInt:[acc intValue] + [obj intValue]];
    }];
    [[reduction should] equal:@15];
  });
  it(@"handles string reduction", ^{
    NSArray *array = @[@"chupa",@"cabra",@"nibre"];
    NSString *reduction = [array reduceWithAccumulator:@"el" andBlock:^id(id acc, id obj) {
      return [acc stringByAppendingFormat:@", %@",obj];
    }];
    [[reduction should] equal:@"el, chupa, cabra, nibre"];
  });
});

describe(@"detect:", ^{
  __block	NSPredicate *containPred = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", @"won"];
  NSString *detectedString = [repetitiveArray detect:^BOOL(id obj) {
    return [containPred evaluateWithObject:obj];
  }];
  [[detectedString should] equal:@"won"];
});

describe(@"every:", ^{
  describe(@"when all elements match", ^{
    it(@"returns BOOL YES", ^{
      BOOL result = [numericArray every:^BOOL(id obj) {
        return [obj isKindOfClass:[NSNumber class]];
      }];
      [[theValue(result) should] equal:theValue(YES)];
    });
  });

  describe(@"when not all elements match", ^{
    it(@"returns BOOL NO", ^{
      BOOL result = [numericArray every:^BOOL(id obj) {
        return [obj intValue] > 1;
      }];
      [[theValue(result) should] equal:theValue(NO)];
    });
  });
});


describe(@"any:", ^{
  describe(@"when any element matches", ^{
    it(@"returns BOOL YES", ^{
      BOOL result = [numericArray any:^BOOL(id obj) {
        return [obj intValue] > 1;
      }];
      [[theValue(result) should] equal:theValue(YES)];
    });
  });
  describe(@"when no element matches", ^{
    it(@"returns BOOL NO", ^{
      BOOL result = [numericArray any:^BOOL(id obj) {
        return [obj isKindOfClass:[NSString class]];
      }];
      [[theValue(result) should] equal:theValue(NO)];
    });
  });
});
SPEC_END