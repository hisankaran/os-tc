Q = require 'kew'

class StringParser extends String

  constructor: (@val='')->
    if @val.then and @val.fail
      deferred = Q.defer()
      @val.then((result)=>
        @val = result
        super
        deferred.resolve(this)
      ).fail(()->
        deferred.reject(arguments)
      )
      return deferred.promise
    else
      super

  getOccurrence: (search, insensitive=false)->
    re = new RegExp(search, if insensitive then 'gi' else 'g')
    (this.match(re) || []).length

  getMostOccurred: (insensitive=false)->
    occurrences = @getComputed(insensitive)
    maxCount = Math.max.apply(null, Object.keys(occurrences))
    {occurrencesCount: maxCount, characters: occurrences[maxCount]}

  getLeastOccurred: (insensitive=false)->
    occurrences = @getComputed(insensitive)
    minCount = Math.min.apply(null, Object.keys(occurrences))
    {occurrencesCount: minCount, characters: occurrences[minCount]}

  getComputed: (insensitive=false)->
    computed = if insensitive then @iOccurrences else @occurrences
    if not computed
      @computeOccurrences(insensitive)
      computed = @getComputed(insensitive)
    computed

  computeOccurrences: (insensitive=false)->
    strArray = if insensitive then this.toLowerCase().split('') else this.split('')
    occurrences = strArray.reduce((result, character)->
      result[character] = (result[character] + 1) or 1
      result
    , {})
    @[if insensitive then 'iOccurrences' else 'occurrences'] = Object.keys(occurrences).reduce((result, character)->
      if result[occurrences[character]] then result[occurrences[character]].push(character)
      else result[occurrences[character]] = [character]
      result
    , {})

  toString: -> @val
  valueOf: -> @val

module.exports = StringParser