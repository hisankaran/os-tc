Getting started:
---
1. Make sure Node.js and NPM installed.
2. Run `npm install` to install project dependencies.
3. Run `grunt`, to run the tests.

Documentation:
---
####StringParser
An Object that is extended from Javascript's built-in String. That means all String functions will also be available on a StringParser Object. StringParser object can be constructed using string or a promise that will eventually resolve to a string. StringParser will also return a Promise Object if it is instantiated with a Promise Object. In success callback of the returned promise you can use StringParser methods.
```
// Instantiating using String
var stringParser = new StringParser('Test');
// Instantiating with a promise
new StringParser(promiseObject).then(function(stringParser) {
    // stringParser object
}).fail(function() {
    // source promise object got rejected
});
```
####StringParser.getOccurrence(search_character, insensitive_mode=false)
This method returns the occurrence of the given character `search_character`, you can optionally set `insensitive_mode` to true to do a case insensitive search of the character.
```
stringParser.getOccurrence('t') // returns 1
stringParser.getOccurrence('t', true) // returns 2
```
####StringParser.getMostOccurred(insensitive_mode=false)
This method returns the array of most occurred character in the source string. you can optionally set `insensitive_mode` to true to do a case insensitive search.
```

// returns {occurrencesCount: 4, characters: ['T', 'e', 's', 't']}
stringParser.getMostOccurred();
// returns {occurrencesCount: 2, characters: ['t']}
stringParser.getMostOccurred(true);
```
####StringParser.getLeastOccurred(insensitive_mode=false)
This method returns the array of least occurred character in the source string. you can optionally set `insensitive_mode` to true to do a case insensitive search.
```

// returns {occurrencesCount: 1, characters: ['T', 'e', 's', 't']}
stringParser.getLeastOccurred();
// returns {occurrencesCount: 1, characters: ['e', 's']}
stringParser.getLeastOccurred(true);
```