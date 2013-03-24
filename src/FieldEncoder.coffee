class FieldEncoder
  findSpecBufferSize: (spec) ->
    sizes = []

    for f in spec.fields
      sizes.push(@findFieldLength(f))

    sizes.reduce((a,b) -> Math.max(a,b))

  findFieldLength: (field) ->
    type = field.type

    if type is 'int8' or type is 'uint8' or type is 'bit'
      length = 1
    else if type is 'int16' or type is 'uint16'
      length = 2
    else if type is 'float'
      length = 4
    else if type is 'double'
      length = 8
    else if type is 'ascii' or type is 'utf8'
      length = field.length
    else if type is 'uint32' or type is 'int32'
      length = 4

    field.start + length


  encodeFieldBE: (buffer, obj, fieldSpec) ->
    # buffer argument is never mutated
    outBuffer = new Buffer(buffer)
    type = fieldSpec.type

    if type is 'int8'
      outBuffer.writeInt8(obj[fieldSpec.name], fieldSpec.start)
    else if type is 'uint8'
      outBuffer.writeUInt8(obj[fieldSpec.name], fieldSpec.start)
    else if type is 'int16'
      outBuffer.writeInt16BE(obj[fieldSpec.name], fieldSpec.start)
    else if type is 'uint16'
      outBuffer.writeUInt16BE(obj[fieldSpec.name], fieldSpec.start)
    else if type is 'float'
      outBuffer.writeFloatBE(obj[fieldSpec.name], fieldSpec.start)
    else if type is 'double'
      outBuffer.writeDoubleBE(obj[fieldSpec.name], fieldSpec.start)
    else if type is 'ascii'
      outBuffer.write(obj[fieldSpec.name], fieldSpec.start, fieldSpec.length, 'ascii')
    else if type is 'utf8'
      outBuffer.write(obj[fieldSpec.name], fieldSpec.start, fieldSpec.length, 'utf8')
    else if type is 'uint32'
      outBuffer.writeUInt32BE(obj[fieldSpec.name], fieldSpec.start)
    else if type is 'int32'
      outBuffer.writeInt32BE(obj[fieldSpec.name], fieldSpec.start)
    else if type is 'bit'
      if obj[fieldSpec.name] is true # protection from type problems
        outBuffer.writeUInt8(Math.pow(2, fieldSpec.position), fieldSpec.start)
      else
        outBuffer.writeUInt8(0, fieldSpec.start)

    return outBuffer

  encodeFieldLE: (buffer, obj, fieldSpec) ->
    # buffer argument is never mutated
    outBuffer = new Buffer(buffer)
    type = fieldSpec.type

    if type is 'int8'
      outBuffer.writeInt8(obj[fieldSpec.name], fieldSpec.start)
    else if type is 'uint8'
      outBuffer.writeUInt8(obj[fieldSpec.name], fieldSpec.start)
    else if type is 'int16'
      outBuffer.writeInt16LE(obj[fieldSpec.name], fieldSpec.start)
    else if type is 'uint16'
      outBuffer.writeUInt16LE(obj[fieldSpec.name], fieldSpec.start)
    else if type is 'float'
      outBuffer.writeFloatLE(obj[fieldSpec.name], fieldSpec.start)
    else if type is 'double'
      outBuffer.writeDoubleLE(obj[fieldSpec.name], fieldSpec.start)
    else if type is 'ascii'
      outBuffer.write(obj[fieldSpec.name], fieldSpec.start, fieldSpec.length, 'ascii')
    else if type is 'utf8'
      outBuffer.write(obj[fieldSpec.name], fieldSpec.start, fieldSpec.length, 'utf8')
    else if type is 'uint32'
      outBuffer.writeUInt32LE(obj[fieldSpec.name], fieldSpec.start)
    else if type is 'int32'
      outBuffer.writeInt32LE(obj[fieldSpec.name], fieldSpec.start)
    else if type is 'bit'
      if obj[fieldSpec.name] is true # protection from type problems
        outBuffer.writeUInt8(Math.pow(2, fieldSpec.position), fieldSpec.start)
      else
        outBuffer.writeUInt8(0, fieldSpec.start)

    return outBuffer


module.exports = FieldEncoder
