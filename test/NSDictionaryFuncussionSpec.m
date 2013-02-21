#import "Kiwi.h"
#import "NSDictionary+Funcussion.h"

SPEC_BEGIN(NSDictionaryFuncussion)

__block NSDictionary *simpleDict;
__block NSDictionary *biggerDict;

beforeEach(^{
  simpleDict = @{@"one":@1,@"two":@2};
  biggerDict = @{@"one":@1,@"two":@2,@"three":@3,@"baz":@"BAZ!!!",@"four":@4,@"boz":@[]};
});

afterEach(^{
  simpleDict = nil;
  biggerDict = nil;
});

describe(@"each:", ^{
  it(@"iterates every element", ^{
    __block NSMutableString *acc = [NSMutableString string];
    [simpleDict each:^(id key, id value) {
      [acc appendFormat:@"%@:%@:",key,value];
    }];
    [[acc should] equal:@"one:1:two:2:"];
  });
});

describe(@"map:", ^{
  it(@"returns a new dictionary", ^{
    NSDictionary *newDict = [simpleDict map:^NSDictionary *(id key, id value) {
      return @{key: value};
    }];
    // really fiddly way of comparing object id's
    [[newDict shouldNot] beIdenticalTo:simpleDict];
  });
  it(@"has access to the couplet key", ^{
    NSDictionary *newDict = [simpleDict map:^NSDictionary *(id key, id value) {
      return @{[key uppercaseString]: value};
    }];
    [[newDict should] equal:@{@"ONE":@1,@"TWO":@2}];
  });
  it(@"has access to the couplet value", ^{
    NSDictionary *newDict = [simpleDict map:^NSDictionary *(id key, id value) {
      return @{key:[NSNumber numberWithInt:([value intValue] * 2)]};
    }];
    [[newDict should] equal:@{@"one":@2,@"two":@4}];
  });
});

describe(@"mapValues:", ^{
  it(@"modifies the values of the dictionary", ^{
    NSDictionary *newDict = [simpleDict mapValues:^id(id key, id value) {
      return [key stringByAppendingFormat:@":%@",value];
    }];
    [[newDict should] equal:@{@"one":@"one:1",@"two":@"two:2"}];
  });
  it(@"does not modify the keys of the dictionary", ^{
    NSDictionary *newDict = [simpleDict mapValues:^id(id key, id value) {
      return [key stringByAppendingFormat:@":%@",value];
    }];
    [[[newDict allKeys] should] equal:[simpleDict allKeys]];
  });
});

describe(@"mapToArray:", ^{
  it(@"returns an array", ^{
    NSArray *valueArray = [simpleDict mapToArray:^id(id key, id value) {
      return [key stringByAppendingFormat:@":%@",value];
    }];
    [[valueArray should] beKindOfClass:[NSArray class]];
  });
  it(@"the array is populated with the return value of the block", ^{
    NSArray *valueArray = [simpleDict mapToArray:^id(id key, id value) {
      return [key stringByAppendingFormat:@":%@",value];
    }];
    [[valueArray should] equal:@[@"one:1",@"two:2"]];
  });
});

describe(@"filter:", ^{
  it(@"returns only elements the block evaluates to YES for", ^{
    NSDictionary *mappedDict = [simpleDict filter:^BOOL(id key, id value) {
      return [key isEqualToString:@"one"];
    }];
    [[mappedDict should] equal:@{@"one":@1}];
  });
  it(@"returns many elements the block evaluates to YES for", ^{
    NSDictionary *mappedDict = [biggerDict filter:^BOOL(id key, id value) {
      return [value isKindOfClass:[NSNumber class]];
    }];
    [[mappedDict should] equal:@{@"one":@1,@"two":@2,@"three":@3,@"four":@4}];
  });
});

describe(@"reduce:withBlock:", ^{
  it(@"reduces strings", ^{
    NSString *reduction = [simpleDict reduce:@"" withBlock:^id(id acc, id key, id value) {
      return [acc stringByAppendingFormat:@"%@:%@:",key,value];
    }];
    [[reduction should] equal:@"one:1:two:2:"];
  });
  it(@"reduces numbers", ^{
    NSNumber *reduction = [simpleDict reduce:@0 withBlock:^id(id acc, id key, id value) {
      return [NSNumber numberWithInt:([acc intValue] + [value intValue])];
    }];
    [[reduction should] equal:@3];
  });
});

describe(@"every:", ^{
  describe(@"when all elements match the block", ^{
    it(@"returns YES", ^{
      BOOL every = [simpleDict every:^BOOL(id key, id value) {
        return [key isKindOfClass:[NSString class]];
      }];
      [[theValue(every) should] beYes];
    });
  });
  describe(@"when not all elements match the block", ^{
    it(@"returns NO", ^{
      BOOL every = [biggerDict every:^BOOL(id key, id value) {
        return [value isKindOfClass:[NSString class]];
      }];
      [[theValue(every) should] beNo];
    });
  });
});

describe(@"any:", ^{
  describe(@"when any element matches the block", ^{
    it(@"returns YES", ^{
      BOOL any = [biggerDict any:^BOOL(id key, id value) {
        return [value isKindOfClass:[NSString class]];
      }];
      [[theValue(any) should] beYes];
    });
  });
  describe(@"when no element matches the block", ^{
    it(@"returns NO", ^{
      BOOL any = [biggerDict any:^BOOL(id key, id value) {
        return [key isKindOfClass:[NSArray class]];
      }];
      [[theValue(any) should] beNo];
    });
  });
});

SPEC_END