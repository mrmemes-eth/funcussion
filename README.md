# Funcussion

More functional than your standard concussion!

## What is it?

Funcussion provides convenience methods on standard Objective-C objects that
help you write Objective-C in a functional style. Operations performed on a
collection always return a new collection. This is in stark opposition to the
mutable approach encouraged by a lot of Objective-C builtin analogs to the
methods provided here. Most common functional idioms for collecitons are
supported and there's a bit of sugar thrown in for good measure.

## NSArray Extensions

A bit of sugar to sweeten your common interactions with NSArray.

### firstObject

Returns the first object in the array; a shortcut for `[array objectAtIndex:0]`.

    -(id)firstObject;

_Example:_

    NSArray *array = [NSArray arrayWithObjects:@"Foo", @"Bar", @"Baz", nil];
    [array firstObject]; // => @"Foo"

### flatten

Recursively flattens array's into a single-dimensional array. Objects are
inserted into the returned array as they're encountered.

    -(NSArray*)flatten;

_Example:_

    NSArray *simpleArray = [NSArray arrayWithObjects:@"one", @"two", nil];
    NSArray *nestedArray = [NSArray arrayWithObjects:@"microphone",
                                                     @"check",
                                                     simpleArray,
                                                     simpleArray, nil];
    [nestedArray flatten];
    // => [NSArray arrayWithObjects:@"microphone", @"check",
    //                              @"one", @"two",
    //                              @"one", @"two", nil];

## NSArray functional operations

Core methods for applying functional approaches to handling instances of
`NSArray`.

### each:

Iterate every element in an `NSArray` with a supplied function.

    -(void)each:(VoidArrayIteratorBlock)aBlock;

_Example:_

    [simpleArray each:^(id obj) {
      NSLog(@"element: %@",obj);
    }];


### eachWithIndex:

Iterate every element in an `NSArray` while yielding the element and an index to
the supplied function.

    -(void)eachWithIndex:(VoidArrayIteratorIndexedBlock)aBlock;

_Example:_

    [simpleArray eachWithIndex:^(id obj, NSUInteger index) {
      NSLog(@"element: %@ index: %d", obj, index);
    }];

### map:

Apply a function to every element of an `NSArray`. Returns a new array
containing the result of the applied functions.

    -(NSArray*)map:(ObjectArrayIteratorBlock)aBlock;

_Example:_

    [simpleArray map:^(id obj) {
      return [obj uppercaseString];
    }];
    // => [NSArray arrayWithObjects:@"ONE", @"TWO", nil]

### mapWithIndex:

Apply a function to every element of an `NSArray` while additionally yielding
an index to the function. Returns a new array containing the result of the
applied functions.

    -(NSArray*)mapWithIndex:(ObjectArrayIteratorIndexedBlock)aBlock;

_Example:_

    [simpleArray mapWithIndex:^(id obj, NSUInteger index) {
      return [[obj stringByAppendingFormat:@":%d", index] uppercaseString];
    }];
    // => [NSArray arrayWithObjects:@"ONE:0", @"TWO:1", nil]

### filter:

Applies the supplied function and returns a new `NSArray` containing all
elements the supplied function evaluates to true for.

    -(NSArray*)filter:(BoolArrayIteratorBlock)aBlock;

_Example:_

    NSArray *mixedArray = [NSArray arrayWithObjects:
                           [NSNumber numberWithInt:0],
                           [NSNumber numberWithInt:1], @"zero", @"one", nil];
    [mixedArray filter:^BOOL(id obj) {
      return [obj isKindOfClass:[NSNumber class]];
    }];
    // => [NSArray arrayWithObjects:[NSNumber numberWithInt:0],
    //                              [NSNumber numberWithInt:0], nil];

### reduceWithAccumulator:andBlock:

Applies the supplied function to reduce all values in the `NSArray` down to a
single value. Initialize it with an accumulator of the same type you will
reduce to.

    -(id)reduceWithAccumulator:(id)accumulator andBlock:(ObjectArrayAccumulatorBlock)aBlock;

_Example:_

    NSArray *numericArray = [NSArray arrayWithObjects:
                             [NSNumber numberWithInt:22],
                             [NSNumber numberWithInt:20], nil];
    NSNumber *accumulator = [NSNumber numberWithInt:0];
    [numericArray reduceWithAccumulator:accumulator andBlock:^id(id acc, id obj) {
      return [NSNumber numberWithInt:[acc intValue] + [obj intValue]];
    }]; // => [NSNumber numberWithInt:42]

### detect:

Returns the first element of the array that matches the BOOL function passed it.

    -(id)detect:(BoolArrayIteratorBlock)aBlock;

_Example:_

    NSArray *mixedArray = [NSArray arrayWithObjects:
                           [NSNumber numberWithInt:0],
                           [NSNumber numberWithInt:1], @"zero", @"one", nil];
    [mixedArray detect:^BOOL(id obj) {
      return [obj isKindOfClass:[NSString class]];
    }]; // => @"zero"

### every:

Applies the supplied BOOL function to every element in the array and returns a
BOOL value indicating whether the function is true for all elements.

    -(BOOL)every:(BoolArrayIteratorBlock)aBlock;

_Example:_

    NSArray *mixedArray = [NSArray arrayWithObjects:
                           [NSNumber numberWithInt:0],
                           [NSNumber numberWithInt:1], @"zero", @"one", nil];
    [mixedArray every:^BOOL(id obj) {
      return [obj isKindOfClass:[NSString class]];
    }]; // => NO

    [mixedArray every:^BOOL(id obj) {
      return [obj isKindOfClass:[NSObject class]];
    }]; // => YES

### any:

Applies the supplied BOOL function to every element in the array and returns a
BOOL value indicating whether the function is true for any element.

    -(BOOL)any:(BoolArrayIteratorBlock)aBlock;

_Example:_

    NSArray *mixedArray = [NSArray arrayWithObjects:
                           [NSNumber numberWithInt:0],
                           [NSNumber numberWithInt:1], @"zero", @"one", nil];
    [mixedArray any:^BOOL(id obj) {
      return [obj isKindOfClass:[NSString class]];
    }]; // => YES

    [mixedArray any:^BOOL(id obj) {
      return [obj isKindOfClass:[NSException class]];
    }]; // => NO

## NSDictionary functional operations

Core methods for applying functional approaches to handling instances of
`NSDictionary`.

### each:

Iterate every couplet in an `NSDictionary` with a supplied function.

    -(void)each:(VoidDictIteratorBlock)aBlock;

_Example:_

    NSDictionary *simpleDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithInt:1], @"one",
                                [NSNumber numberWithInt:2], @"two", nil];
    [simpleDict each:^(id key, id value) {
      NSLog(@"couplet: %@ => %@", key, value);
    }];

### map:

Applies a function that returns an NSDictionary to every couplet of an
`NSDictionary`. Returns a new dictionary containing the result of the applied
functions.

    -(NSDictionary*)map:(DictionaryDictIteratorBlock)aBlock;

_Example:_

    [simpleDict map:^(id key, id value) {
      return [NSDictionary dictionaryWithObject:
              [key stringByAppendingFormat:@":%@",value]
                                         forKey:[key uppercaseString]];
    }];
    // => [NSDictionary dictionaryWithObjectsAndKeys:
    //     @"ONE", @"one:1",
    //     @"TWO", @"two:2", nil];

### mapValues:

Applies a function that returns an object to every couplet of an
`NSDictionary`. Returns a new dictionary containing the result of the applied
functions assigned as the value.

    -(NSDictionary*)mapValues:(ObjectDictIteratorBlock)aBlock;

_Example:_

    [simpleDict mapValues:^id(id key, id value) {
      return [key stringByAppendingFormat:@":%@",value]
    }];
    // => [NSDictionary dictionaryWithObjectsAndKeys:
    //     @"one", @"one:1",
    //     @"two", @"two:2", nil];

### mapToArray:

Applies a function that returns an object to every couplet of an
`NSDictionary`. Returns an array containing the result of the applied
functions.

    -(NSArray*)mapToArray:(ObjectDictIteratorBlock)aBlock;


_Example:_

    [simpleDict mapToArray:^id(id key, id value) {
      return [key stringByAppendingFormat:@":%@",value]
    }];
    // => [NSArray arrayWithObjects:@"one:1", @"two:2", nil];

### filter:

Applies the supplied function to every couplet of an `NSDictionary` and
returns a new `NSDictionary` containing all couplets the supplied function
evaluates to true for.

    -(NSDictionary*)filter:(BoolDictIteratorBlock)aBlock;

_Example:_

    __block NSPredicate *containPred = [NSPredicate predicateWithFormat:
                                        @"SELF contains[cd] %@", @"one"];
    [simpleDict filter:^BOOL(id key, id value) {
      return [containPred evaluateWithObject:key];
    }]; // => [NSDictionary dictionaryWithObjectsAndKeys:@"one", @"one:1", nil];

### reduceWithAccumulator:andBlock:

Applies the supplied function to reduce all couplets in the `NSDictionary`
down to a single value. Initialize it with an accumulator of the same type you
will reduce to.

    -(id)reduceWithAccumulator:(id)accumulator andBlock:(ObjectAcumulatorDictBlock)aBlock;

_Example:_

    NSNumber *accumulator = [NSNumber numberWithInt:0];
    [simpleDict reduceWithAccumulator:accumulator andBlock:^id(id acc, id key, id value) {
      return [NSNumber numberWithInt:[acc intValue] + [value intValue]];
    }]; // => [NSNumber numberWithInt:3]

### every:

Applies the supplied BOOL function to every element in an `NSDictionary` and
returns a BOOL value indicating whether the function is true for all elements.

    -(BOOL)every:(BoolDictIteratorBlock)aBlock;

_Example:_

    [simpleDict every:^BOOL(id key, id value) {
      return [key isKindOfClass:[NSString class]];
    }]; // => YES

    [simpleDict every:^BOOL(id key, id value) {
      return [value intValue] < 2;
    }]; // => NO

### any:

Applies the supplied BOOL function to every element in an `NSDictionary` and
returns a BOOL value indicating whether the function is true for any element.

    -(BOOL)any:(BoolDictIteratorBlock)aBlock;

_Example:_

    [simpleDict any:^BOOL(id key, id value) {
      return [key isKindOfClass:[NSNumber class]];
    }]; // => NO

    [simpleDict any:^BOOL(id key, id value) {
      return [value intValue] < 2;
    }]; // => YES

# Contributing

Contributions are welcome, just fork the project make your changes and submit
a pull request. Please ensure the SenTesting suite has coverage for any
additions you make and that it still passes after you make any modifications.

# License

As with all my software, Funcussion uses the [WTFPL](http://www.wtfpl.net/) so
you can just do what the fuck you want to with it.
