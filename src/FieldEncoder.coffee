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
    outBuffer = new Buffer(buffer)

    switch fieldSpec.type
      when 'int8'   then outBuffer.writeInt8(obj[fieldSpec.name], fieldSpec.start)
      when 'uint8'  then outBuffer.writeUInt8(obj[fieldSpec.name], fieldSpec.start)
      when 'int16'  then outBuffer.writeInt16BE(obj[fieldSpec.name], fieldSpec.start)
      when 'uint16' then outBuffer.writeUInt16BE(obj[fieldSpec.name], fieldSpec.start)
      when 'float'  then outBuffer.writeFloatBE(obj[fieldSpec.name], fieldSpec.start)
      when 'double' then outBuffer.writeDoubleBE(obj[fieldSpec.name], fieldSpec.start)
      when 'ascii'  then outBuffer.write(obj[fieldSpec.name], fieldSpec.start, fieldSpec.length, 'ascii')
      when 'utf8'   then outBuffer.write(obj[fieldSpec.name], fieldSpec.start, fieldSpec.length, 'utf8')
      when 'uint32' then outBuffer.writeUInt32BE(obj[fieldSpec.name], fieldSpec.start)
      when 'int32'  then outBuffer.writeInt32BE(obj[fieldSpec.name], fieldSpec.start)
      when 'bit'
        if obj[fieldSpec.name] is true # protection from type problems
          outBuffer.writeUInt8(Math.pow(2, fieldSpec.position), fieldSpec.start)
        else
          outBuffer.writeUInt8(0, fieldSpec.start)

      #TODO error case

    return outBuffer

  encodeFieldLE: (buffer, obj, fieldSpec) ->
    outBuffer = new Buffer(buffer)

    switch fieldSpec.type
      when 'int8'   then outBuffer.writeInt8(obj[fieldSpec.name], fieldSpec.start)
      when 'uint8'  then outBuffer.writeUInt8(obj[fieldSpec.name], fieldSpec.start)
      when 'int16'  then outBuffer.writeInt16LE(obj[fieldSpec.name], fieldSpec.start)
      when 'uint16' then outBuffer.writeUInt16LE(obj[fieldSpec.name], fieldSpec.start)
      when 'float'  then outBuffer.writeFloatLE(obj[fieldSpec.name], fieldSpec.start)
      when 'double' then outBuffer.writeDoubleLE(obj[fieldSpec.name], fieldSpec.start)
      when 'ascii'  then outBuffer.write(obj[fieldSpec.name], fieldSpec.start, fieldSpec.length, 'ascii')
      when 'utf8'   then outBuffer.write(obj[fieldSpec.name], fieldSpec.start, fieldSpec.length, 'utf8')
      when 'uint32' then outBuffer.writeUInt32LE(obj[fieldSpec.name], fieldSpec.start)
      when 'int32'  then outBuffer.writeInt32LE(obj[fieldSpec.name], fieldSpec.start)
      when 'bit'
        if obj[fieldSpec.name] is true # protection from type problems
          outBuffer.writeUInt8(Math.pow(2, fieldSpec.position), fieldSpec.start)
        else
          outBuffer.writeUInt8(0, fieldSpec.start)
      #TODO error case

    return outBuffer


module.exports = FieldEncoder
