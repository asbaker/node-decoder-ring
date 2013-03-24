bufferBE = new Buffer(46)
bufferBE.writeInt8(-127, 0)
bufferBE.writeUInt8(254, 1)
bufferBE.writeInt16BE(5327, 2)
bufferBE.writeUInt16BE(5328, 4)
bufferBE.writeFloatBE(-15.33, 6)
bufferBE.writeDoubleBE(-1534.98, 10)
bufferBE.write("ascii text", 18, 10,'ascii')
bufferBE.write("utf8 text", 28, 9, 'utf8')
bufferBE.writeUInt8(129, 37)
bufferBE.writeUInt32BE(79001, 38)
bufferBE.writeInt32BE(-79001, 42)

bufferLE = new Buffer(46)
bufferLE.writeInt8(-127, 0)
bufferLE.writeUInt8(254, 1)
bufferLE.writeInt16LE(5327, 2)
bufferLE.writeUInt16LE(5328, 4)
bufferLE.writeFloatLE(-15.33, 6)
bufferLE.writeDoubleLE(-1534.98, 10)
bufferLE.write("ascii text", 18, 10,'ascii')
bufferLE.write("utf8 text", 28, 9, 'utf8')
bufferLE.writeUInt8(129, 37)
bufferLE.writeUInt32LE(79002, 38)
bufferLE.writeInt32LE(-79002, 42)

bufferBESpec = {
  bigEndian: true
  fields: [
    {name: "field1", start: 0,  type: 'int8'  }
    {name: "field2", start: 1,  type: 'uint8' }
    {name: "field3", start: 2,  type: 'int16' }
    {name: "field4", start: 4,  type: 'uint16'}
    {name: "field5", start: 6,  type: 'float' }
    {name: "field6", start: 10, type: 'double'}
    {name: "field7", start: 18, type: 'ascii', length: 10 }
    {name: "field8", start: 28, type: 'utf8',  length: 9  }
    {name: "field9", start: 37, type: 'bit', position: 7}
    {name: "field10", start: 37, type: 'bit', position: 6}
    {name: "field11", start: 37, type: 'bit', position: 0}
    {name: "field12", start: 38, type: 'uint32'}
    {name: "field13", start: 42, type: 'int32'}
  ]
}

bufferLESpec = {
  bigEndian: false
  fields: [
    {name: "field1", start: 0,  type: 'int8'  }
    {name: "field2", start: 1,  type: 'uint8' }
    {name: "field3", start: 2,  type: 'int16' }
    {name: "field4", start: 4,  type: 'uint16'}
    {name: "field5", start: 6,  type: 'float' }
    {name: "field6", start: 10, type: 'double'}
    {name: "field7", start: 18, type: 'ascii', length: 10 }
    {name: "field8", start: 28, type: 'utf8',  length: 9  }
    {name: "field9", start: 37, type: 'bit', position: 7}
    {name: "field10", start: 37, type: 'bit', position: 6}
    {name: "field11", start: 37, type: 'bit', position: 0}
    {name: "field12", start: 38, type: 'uint32'}
    {name: "field13", start: 42, type: 'int32'}
  ]
}

module.exports = {
  bufferBE: bufferBE,
  bufferLE: bufferLE,
  bufferBESpec: bufferBESpec,
  bufferLESpec: bufferLESpec
}
