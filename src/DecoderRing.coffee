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

  encode: (obj, spec) ->
    size = @fieldEncoder.findSpecBufferSize(spec)
    buffer = new Buffer(size)
    buffer.fill(0)

    if spec.bigEndian
      encodeFun = @fieldEncoder.encodeFieldBE
    else
      encodeFun = @fieldEncoder.encodeFieldLE

    runningThing = {}

    for fieldSpec in spec.fields
      unless fieldSpec.type is 'bit'
        buffer = encodeFun(buffer, obj, fieldSpec)
      else
        val = if obj[fieldSpec.name] then Math.pow(2, fieldSpec.position) else 0
        currentVal = runningThing["#{fieldSpec.start}"] || 0
        runningThing["#{fieldSpec.start}"] = currentVal + val

    # encode all the bit fields that we accumulated
    for r in Object.keys(runningThing)
      buffer = encodeFun(buffer, runningThing, {name: r, start: parseInt(r), type: 'uint8'})

    return buffer

module.exports = DecoderRing
