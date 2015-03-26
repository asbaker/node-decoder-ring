class FieldDecoder
  decodeFieldBE: (buffer, fieldSpec) ->
    switch fieldSpec.type
      when 'int8'   then buffer.readInt8(fieldSpec.start)
      when 'uint8'  then buffer.readUInt8(fieldSpec.start)
      when 'int16'  then buffer.readInt16BE(fieldSpec.start)
      when 'uint16' then buffer.readUInt16BE(fieldSpec.start)
      when 'int32'  then buffer.readInt32BE(fieldSpec.start)
      when 'uint32' then buffer.readUInt32BE(fieldSpec.start)
      when 'float'  then buffer.readFloatBE(fieldSpec.start)
      when 'double' then buffer.readDoubleBE(fieldSpec.start)
      when 'ascii'  then buffer.toString('ascii', fieldSpec.start, fieldSpec.start+fieldSpec.length)
      when 'utf8'   then buffer.toString('utf8', fieldSpec.start, fieldSpec.start+fieldSpec.length)
      when 'buffer' then buffer.slice(fieldSpec.start, fieldSpec.start+fieldSpec.length)
      when 'bit'
        i = buffer.readUInt8(fieldSpec.start)
        (i & 2 ** fieldSpec.position) > 0
#TODO error case

  decodeFieldLE: (buffer, fieldSpec) ->
    switch fieldSpec.type
      when 'int8'   then buffer.readInt8(fieldSpec.start)
      when 'uint8'  then buffer.readUInt8(fieldSpec.start)
      when 'int16'  then buffer.readInt16LE(fieldSpec.start)
      when 'uint16' then buffer.readUInt16LE(fieldSpec.start)
      when 'int32'  then buffer.readInt32LE(fieldSpec.start)
      when 'uint32' then buffer.readUInt32LE(fieldSpec.start)
      when 'float'  then buffer.readFloatLE(fieldSpec.start)
      when 'double' then buffer.readDoubleLE(fieldSpec.start)
      when 'ascii'  then buffer.toString('ascii', fieldSpec.start, fieldSpec.start+fieldSpec.length)
      when 'utf8'   then buffer.toString('utf8', fieldSpec.start, fieldSpec.start+fieldSpec.length)
      when 'buffer' then buffer.slice(fieldSpec.start, fieldSpec.start+fieldSpec.length)
      when 'bit'
        i = buffer.readUInt8(fieldSpec.start)
        (i & 2 ** fieldSpec.position) > 0
#TODO error case

module.exports = FieldDecoder
