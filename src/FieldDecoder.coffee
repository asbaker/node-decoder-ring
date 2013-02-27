class FieldDecoder
  constructor: ->

  decodeFieldBE: (buffer, fieldSpec) ->
    if fieldSpec.type is 'int8'
      buffer.readInt8(fieldSpec.start)
    else if fieldSpec.type is 'uint8'
      buffer.readUInt8(fieldSpec.start)
    else if fieldSpec.type is 'int16'
      buffer.readInt16BE(fieldSpec.start)
    else if fieldSpec.type is 'uint16'
      buffer.readUInt16BE(fieldSpec.start)
    else if fieldSpec.type is 'float'
      buffer.readFloatBE(fieldSpec.start)
    else if fieldSpec.type is 'double'
      buffer.readDoubleBE(fieldSpec.start)
    else if fieldSpec.type is 'ascii'
      buffer.toString('ascii', fieldSpec.start, fieldSpec.start+fieldSpec.length)
    else if fieldSpec.type is 'utf8'
      buffer.toString('utf8', fieldSpec.start, fieldSpec.start+fieldSpec.length)
    else if fieldSpec.type is 'bit'
      i = buffer.readUInt8(fieldSpec.start)
      (i & Math.pow(2, fieldSpec.position)) > 0
    else if fieldSpec.type is 'uint32'
      buffer.readUInt32BE(fieldSpec.start)
    else if fieldSpec.type is 'int32'
      buffer.readInt32BE(fieldSpec.start)

  decodeFieldLE: (buffer, fieldSpec) ->
    if fieldSpec.type is 'int8'
      buffer.readInt8(fieldSpec.start)
    else if fieldSpec.type is 'uint8'
      buffer.readUInt8(fieldSpec.start)
    else if fieldSpec.type is 'int16'
      buffer.readInt16LE(fieldSpec.start)
    else if fieldSpec.type is 'uint16'
      buffer.readUInt16LE(fieldSpec.start)
    else if fieldSpec.type is 'float'
      buffer.readFloatLE(fieldSpec.start)
    else if fieldSpec.type is 'double'
      buffer.readDoubleLE(fieldSpec.start)
    else if fieldSpec.type is 'ascii'
      buffer.toString('ascii', fieldSpec.start, fieldSpec.start+fieldSpec.length)
    else if fieldSpec.type is 'utf8'
      buffer.toString('utf8', fieldSpec.start, fieldSpec.start+fieldSpec.length)
    else if fieldSpec.type is 'bit'
      i = buffer.readUInt8(fieldSpec.start)
      (i & Math.pow(2, fieldSpec.position)) > 0
    else if fieldSpec.type is 'uint32'
      buffer.readUInt32LE(fieldSpec.start)
    else if fieldSpec.type is 'int32'
      buffer.readInt32LE(fieldSpec.start)

module.exports = FieldDecoder
