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
    if obj[fieldSpec.name]?
      switch fieldSpec.type
        when 'int8'   then buffer.writeInt8(obj[fieldSpec.name], fieldSpec.start)
        when 'uint8'  then buffer.writeUInt8(obj[fieldSpec.name], fieldSpec.start)
        when 'int16'  then buffer.writeInt16BE(obj[fieldSpec.name], fieldSpec.start)
        when 'uint16' then buffer.writeUInt16BE(obj[fieldSpec.name], fieldSpec.start)
        when 'float'  then buffer.writeFloatBE(obj[fieldSpec.name], fieldSpec.start)
        when 'double' then buffer.writeDoubleBE(obj[fieldSpec.name], fieldSpec.start)
        when 'ascii'  then buffer.write(obj[fieldSpec.name], fieldSpec.start, fieldSpec.length, 'ascii')
        when 'utf8'   then buffer.write(obj[fieldSpec.name], fieldSpec.start, fieldSpec.length, 'utf8')
        when 'uint32' then buffer.writeUInt32BE(obj[fieldSpec.name], fieldSpec.start)
        when 'int32'  then buffer.writeInt32BE(obj[fieldSpec.name], fieldSpec.start)
        when 'bit'
          if obj[fieldSpec.name] is true # protection from type problems
            buffer.writeUInt8(Math.pow(2, fieldSpec.position), fieldSpec.start)
          else
            buffer.writeUInt8(0, fieldSpec.start)
        #TODO error case

    return buffer

  encodeFieldLE: (buffer, obj, fieldSpec) ->
    if obj[fieldSpec.name]?
      switch fieldSpec.type
        when 'int8'   then buffer.writeInt8(obj[fieldSpec.name], fieldSpec.start)
        when 'uint8'  then buffer.writeUInt8(obj[fieldSpec.name], fieldSpec.start)
        when 'int16'  then buffer.writeInt16LE(obj[fieldSpec.name], fieldSpec.start)
        when 'uint16' then buffer.writeUInt16LE(obj[fieldSpec.name], fieldSpec.start)
        when 'float'  then buffer.writeFloatLE(obj[fieldSpec.name], fieldSpec.start)
        when 'double' then buffer.writeDoubleLE(obj[fieldSpec.name], fieldSpec.start)
        when 'ascii'  then buffer.write(obj[fieldSpec.name], fieldSpec.start, fieldSpec.length, 'ascii')
        when 'utf8'   then buffer.write(obj[fieldSpec.name], fieldSpec.start, fieldSpec.length, 'utf8')
        when 'uint32' then buffer.writeUInt32LE(obj[fieldSpec.name], fieldSpec.start)
        when 'int32'  then buffer.writeInt32LE(obj[fieldSpec.name], fieldSpec.start)
        when 'bit'
          if obj[fieldSpec.name] is true # protection from type problems
            buffer.writeUInt8(Math.pow(2, fieldSpec.position), fieldSpec.start)
          else
            buffer.writeUInt8(0, fieldSpec.start)
        #TODO error case

    return buffer

module.exports = FieldEncoder
