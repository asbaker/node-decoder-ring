FieldDecoder = require("./FieldDecoder")
FieldEncoder = require("./FieldEncoder")

class DecoderRing
  constructor: (@fieldDecoder = new FieldDecoder, @fieldEncoder = new FieldEncoder) ->

  decode: (buffer, spec) ->
    obj = {}

    if spec.bigEndian
      decodeFun = @fieldDecoder.decodeFieldBE
    else
      decodeFun = @fieldDecoder.decodeFieldLE

    for field in spec.fields
      obj[field.name] = decodeFun(buffer, field)

    return obj

  encode: (obj, spec, checkMissingFields = false) ->
    size = spec.length ? @fieldEncoder.findSpecBufferSize(spec)
    buffer = new Buffer(size)
    buffer.fill(0)

    if checkMissingFields
      @checkForMissingSpecFields(obj, spec)

    if spec.bigEndian
      encodeFun = @fieldEncoder.encodeFieldBE
    else
      encodeFun = @fieldEncoder.encodeFieldLE

    bitFieldAccumulator = {}

    for fieldSpec in spec.fields
      if fieldSpec.type is 'bit'
        val = if obj[fieldSpec.name] then 2 ** fieldSpec.position else 0
        currentVal = bitFieldAccumulator["#{fieldSpec.start}"] || 0
        bitFieldAccumulator["#{fieldSpec.start}"] = currentVal + val
      else
        buffer = encodeFun(buffer, obj, fieldSpec)

    # encode all the bit fields that we accumulated
    for r in Object.keys(bitFieldAccumulator)
      buffer = encodeFun(buffer, bitFieldAccumulator, { name: r, start: parseInt(r), type: 'uint8' })

    return buffer

  checkForMissingSpecFields: (obj, spec) ->
    for key in Object.keys(obj)
      if !spec[key]?
        throw new Error("Key #{key} was not found in spec")

module.exports = DecoderRing
