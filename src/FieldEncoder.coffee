class FieldEncoder
  findSpecBufferSize: (spec) ->
    sizes = []

    for f in spec.fields
      sizes.push(@findFieldLength(f))

    sizes.reduce((a,b) -> Math.max(a,b))

  findFieldLength: (field) ->
    length = switch field.type
      when 'int8', 'uint8', 'bit'     then 1
      when 'int16', 'uint16'          then 2
      when 'uint32', 'int32', 'float' then 4
      when 'double'                   then 8
      when 'ascii', 'utf8'            then field.length

    return field.start + length


  encodeFieldBE: (buffer, obj, fieldSpec) ->
    val = obj[fieldSpec.name]

    if !val? and fieldSpec.default?
      val = fieldSpec.default

    if val?
      switch fieldSpec.type
        when 'int8'   then buffer.writeInt8(val, fieldSpec.start)
        when 'uint8'  then buffer.writeUInt8(val, fieldSpec.start)
        when 'int16'  then buffer.writeInt16BE(val, fieldSpec.start)
        when 'uint16' then buffer.writeUInt16BE(val, fieldSpec.start)
        when 'float'  then buffer.writeFloatBE(val, fieldSpec.start)
        when 'double' then buffer.writeDoubleBE(val, fieldSpec.start)
        when 'ascii'  then buffer.write(val, fieldSpec.start, fieldSpec.length, 'ascii')
        when 'utf8'   then buffer.write(val, fieldSpec.start, fieldSpec.length, 'utf8')
        when 'uint32' then buffer.writeUInt32BE(val, fieldSpec.start)
        when 'int32'  then buffer.writeInt32BE(val, fieldSpec.start)
        when 'bit'
          if val is true # protection from type problems
            buffer.writeUInt8(Math.pow(2, fieldSpec.position), fieldSpec.start)
          else
            buffer.writeUInt8(0, fieldSpec.start)
        #TODO error case

    return buffer

  encodeFieldLE: (buffer, obj, fieldSpec) ->
    val = obj[fieldSpec.name]

    if !val? and fieldSpec.default?
      val = fieldSpec.default

    if val?
      switch fieldSpec.type
        when 'int8'   then buffer.writeInt8(val, fieldSpec.start)
        when 'uint8'  then buffer.writeUInt8(val, fieldSpec.start)
        when 'int16'  then buffer.writeInt16LE(val, fieldSpec.start)
        when 'uint16' then buffer.writeUInt16LE(val, fieldSpec.start)
        when 'float'  then buffer.writeFloatLE(val, fieldSpec.start)
        when 'double' then buffer.writeDoubleLE(val, fieldSpec.start)
        when 'ascii'  then buffer.write(val, fieldSpec.start, fieldSpec.length, 'ascii')
        when 'utf8'   then buffer.write(val, fieldSpec.start, fieldSpec.length, 'utf8')
        when 'uint32' then buffer.writeUInt32LE(val, fieldSpec.start)
        when 'int32'  then buffer.writeInt32LE(val, fieldSpec.start)
        when 'bit'
          if val is true # protection from type problems
            buffer.writeUInt8(Math.pow(2, fieldSpec.position), fieldSpec.start)
          else
            buffer.writeUInt8(0, fieldSpec.start)
        #TODO error case

    return buffer

module.exports = FieldEncoder
