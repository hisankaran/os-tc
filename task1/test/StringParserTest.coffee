chai = require 'chai'
Q = require 'kew'
StringParser = require '../stringParser'

should = chai.should()

describe 'StringParser', ->

  stringParser = new StringParser('Test')

  describe 'Get Occurrences', ->
    describe 'Case sensitive', ->
      it 'should report character occurrences', ->
        stringParser.getOccurrence('t').should.equal 1
    describe 'Case sensitive', ->
      it 'should report character occurrences', ->
        stringParser.getOccurrence('t', true).should.equal 2

  describe 'Most Occurred Character', ->
    describe 'Case sensitive', ->
      mostOccurred = stringParser.getMostOccurred()
      it 'report correct occurrences', ->
        mostOccurred.occurrencesCount.should.equal 1
      it 'array of characters that has same occurrence should match the count', ->
        mostOccurred.characters.length.should.equal 4
      it 'report all the characters that has same number of occurrence', ->
        mostOccurred.characters.should.deep.equal ['T', 'e', 's', 't']
    describe 'Case insensitive', ()->
      mostOccurred = stringParser.getMostOccurred(true)
      it 'report correct occurrences', ->
        mostOccurred.occurrencesCount.should.equal 2
      it 'array of characters that has same occurrence should match the count', ->
        mostOccurred.characters.length.should.equal 1
      it 'report all the characters that has same number of occurrence', ->
        mostOccurred.characters.should.deep.equal ['t']

  describe 'Least Occurred Character', ->
    describe 'Case sensitive', ->
      leastOccurred = stringParser.getLeastOccurred()
      it 'report correct occurrences', ->
        leastOccurred.occurrencesCount.should.equal 1
      it 'array of characters that has same occurrence should match the count', ->
        leastOccurred.characters.length.should.equal 4
      it 'report all the characters that has same number of occurrence', ->
        leastOccurred.characters.should.deep.equal ['T', 'e', 's', 't']
    describe 'Case insensitive', ()->
      leastOccurred = stringParser.getLeastOccurred(true)
      it 'report correct occurrences', ->
        leastOccurred.occurrencesCount.should.equal 1
      it 'array of characters that has same occurrence should match the count', ->
        leastOccurred.characters.length.should.equal 2
      it 'report all the characters that has same number of occurrence', ->
        leastOccurred.characters.should.deep.equal ['e', 's']

  describe 'Methods should be directly callable', ->
    it 'should report character occurrences [sensitive]', ->
      directCall = StringParser.prototype.getOccurrence.call('Test', 't')
      directCall.should.equal 1
    it 'should report character occurrences [insensitive]', ->
      directCall = StringParser.prototype.getOccurrence.call('Test', 't', true)
      directCall.should.equal 2

  describe 'Basic string functions should be available', ->
    it 'should lowercase the string', ->
      directCall = StringParser.prototype.toLowerCase.call('Test')
      directCall.should.equal 'test'
    it 'should uppercase the string', ->
      directCall = StringParser.prototype.toUpperCase.call('Test')
      directCall.should.equal 'TEST'

  describe 'Promisified StringParser', ->
    describe 'Successful promise', ->
      deferred = Q.defer()
      stringParserPromise = new StringParser(deferred.promise)
      setTimeout ( ->
        deferred.resolve('Test')
      ), 1500
      it 'should return a promise object', ->
        stringParserPromise.should.have.property 'then'
      it 'should return the StringParser object on resolving', ->
        stringParserPromise.then((result)->
          leastOccurred = result.getLeastOccurred()
          leastOccurred.characters.should.deep.equal ['T', 'e', 's', 't']
        )
    describe 'Failed promise', ->
      deferred = Q.defer()
      stringParserPromise = new StringParser(deferred.promise)
      setTimeout ( ->
        deferred.reject()
      ), 1500
      it 'should return a promise object', ->
        stringParserPromise.should.have.property 'fail'
      it 'should return the fail callback', ->
        stringParserPromise.fail((error)->
          error.should.exist
        )