FieldDecoder = require("./FieldDecoder")

class DecoderRing
  constructor: (@fieldDecoder = new FieldDecoder) ->

  decode: (buffer, spec) ->
    o = {}
    if spec.bigEndian
      decodeFun = @fieldDecoder.decodeFieldBE
    else
      decodeFun = @fieldDecoder.decodeFieldLE

    for field in spec.fields
      o[field.name] = decodeFun(buffer, field)

    return o

module.exports = DecoderRing
