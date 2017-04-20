padEnd = require('lodash.padend')

class FieldEncoder
  findSpecBufferSize: (spec) ->
    sizes = []

    for f in spec.fields
      sizes.push(@findFieldLength(f))

    sizes.reduce((a, b) -> Math.max(a, b))

  findFieldLength: (field) ->
    length = switch field.type
      when 'int8', 'uint8', 'bit'     then 1
      when 'int16', 'uint16'          then 2
      when 'uint32', 'int32', 'float' then 4
      when 'double'                   then 8
      when 'ascii', 'utf8', 'buffer'  then field.length

    return field.start + length


  encodeFieldBE: (buffer, obj, fieldSpec, noAssert, padding) ->
    val = obj[fieldSpec.name]

    if !val? and fieldSpec.default?
      val = fieldSpec.default

    if val?
      switch fieldSpec.type
        when 'int8'   then buffer.writeInt8(val, fieldSpec.start, noAssert)
        when 'uint8'  then buffer.writeUInt8(val, fieldSpec.start, noAssert)
        when 'int16'  then buffer.writeInt16BE(val, fieldSpec.start, noAssert)
        when 'uint16' then buffer.writeUInt16BE(val, fieldSpec.start, noAssert)
        when 'float'  then buffer.writeFloatBE(val, fieldSpec.start, noAssert)
        when 'double' then buffer.writeDoubleBE(val, fieldSpec.start, noAssert)
        when 'uint32' then buffer.writeUInt32BE(val, fieldSpec.start, noAssert)
        when 'int32'  then buffer.writeInt32BE(val, fieldSpec.start, noAssert)
        when 'buffer' then val.copy(buffer, fieldSpec.start, 0, fieldSpec.length)

        when 'ascii', 'utf8'
          if padding?
            val = padEnd(val, fieldSpec.length, padding)

          buffer.write(val, fieldSpec.start, fieldSpec.length, fieldSpec.type)

        when 'bit'
          if val is true # protection from type problems
            buffer.writeUInt8(2 ** fieldSpec.position, fieldSpec.start, noAssert)
          else
            buffer.writeUInt8(0, fieldSpec.start, noAssert)

    return buffer

  encodeFieldLE: (buffer, obj, fieldSpec, noAssert, padding) ->
    val = obj[fieldSpec.name]

    if !val? and fieldSpec.default?
      val = fieldSpec.default

    if val?
      switch fieldSpec.type
        when 'int8'   then buffer.writeInt8(val, fieldSpec.start, noAssert)
        when 'uint8'  then buffer.writeUInt8(val, fieldSpec.start, noAssert)
        when 'int16'  then buffer.writeInt16LE(val, fieldSpec.start, noAssert)
        when 'uint16' then buffer.writeUInt16LE(val, fieldSpec.start, noAssert)
        when 'float'  then buffer.writeFloatLE(val, fieldSpec.start, noAssert)
        when 'double' then buffer.writeDoubleLE(val, fieldSpec.start, noAssert)
        when 'uint32' then buffer.writeUInt32LE(val, fieldSpec.start, noAssert)
        when 'int32'  then buffer.writeInt32LE(val, fieldSpec.start, noAssert)
        when 'buffer' then val.copy(buffer, fieldSpec.start, 0, fieldSpec.length)

        when 'ascii', 'utf8'
          if padding?
            val = padEnd(val, fieldSpec.length, padding)

          buffer.write(val, fieldSpec.start, fieldSpec.length, fieldSpec.type)

        when 'bit'
          if val is true # protection from type problems
            buffer.writeUInt8(2 ** fieldSpec.position, fieldSpec.start, noAssert)
          else
            buffer.writeUInt8(0, fieldSpec.start, noAssert)

    return buffer

module.exports = FieldEncoder
