expect = require("chai").expect

FieldEncoder = require("../src/FieldEncoder")

describe "FieldEncoder unit test", ->
  beforeEach ->
    @subject = new FieldEncoder
    {_, _, @bufferBESpec, @bufferLESpec} = require("./Fixtures")

  describe "responds to", ->
    it "encodeFieldBE", ->
      expect(@subject).to.respondTo("encodeFieldBE")

    it "findSpecBufferSize", ->
      expect(@subject).to.respondTo("findSpecBufferSize")

    it "findFieldLength", ->
      expect(@subject).to.respondTo("findFieldLength")

    it "encodeFieldLE", ->
      expect(@subject).to.respondTo("encodeFieldLE")

  describe "#encodeFieldBE", ->
    it "encodes an int8 field", ->
      expectedBuffer = new Buffer(2)
      expectedBuffer.fill(0)
      expectedBuffer.writeInt8(-11, 1)

      outBuffer = new Buffer(2)
      outBuffer.fill(0)

      obj = {field1: -11}
      fieldSpec = {name: "field1", start: 1, type: 'int8'}

      result = @subject.encodeFieldBE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes an uint8 field", ->
      expectedBuffer = new Buffer(2)
      expectedBuffer.fill(0)
      expectedBuffer.writeUInt8(11, 1)

      outBuffer = new Buffer(2)
      outBuffer.fill(0)

      obj = {field2: 11}
      fieldSpec = {name: "field2", start: 1, type: 'uint8'}

      result = @subject.encodeFieldBE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes an int16 field", ->
      expectedBuffer = new Buffer(3)
      expectedBuffer.fill(0)
      expectedBuffer.writeInt16BE(-305, 1)

      outBuffer = new Buffer(3)
      outBuffer.fill(0)

      obj = {field3: -305}
      fieldSpec = {name: "field3", start: 1, type: 'int16'}

      result = @subject.encodeFieldBE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes an uint16 field", ->
      expectedBuffer = new Buffer(3)
      expectedBuffer.fill(0)
      expectedBuffer.writeUInt16BE(305, 1)

      outBuffer = new Buffer(3)
      outBuffer.fill(0)

      obj = {field4: 305}
      fieldSpec = {name: "field4", start: 1, type: 'uint16'}

      result = @subject.encodeFieldBE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes an float field", ->
      expectedBuffer = new Buffer(10)
      expectedBuffer.fill(0)
      expectedBuffer.writeFloatBE(305.11, 1)

      outBuffer = new Buffer(10)
      outBuffer.fill(0)

      obj = {field5: 305.11}
      fieldSpec = {name: "field5", start: 1, type: 'float'}

      result = @subject.encodeFieldBE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes an double field", ->
      expectedBuffer = new Buffer(10)
      expectedBuffer.fill(0)
      expectedBuffer.writeDoubleBE(30005.11, 1)

      outBuffer = new Buffer(10)
      outBuffer.fill(0)

      obj = {field6: 30005.11}
      fieldSpec = {name: "field6", start: 1, type: 'double'}

      result = @subject.encodeFieldBE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes an ascii field", ->
      expectedBuffer = new Buffer(15)
      expectedBuffer.fill(0)
      expectedBuffer.write("ascii text", 1, 10, 'ascii')

      outBuffer = new Buffer(15)
      outBuffer.fill(0)

      obj = {field7: "ascii text"}
      fieldSpec = {name: "field7", start: 1, type: 'ascii', length: 10}

      result = @subject.encodeFieldBE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes an utf8 field", ->
      expectedBuffer = new Buffer(15)
      expectedBuffer.fill(0)
      expectedBuffer.write("utf8 text", 1, 9, 'utf8')

      outBuffer = new Buffer(15)
      outBuffer.fill(0)

      obj = {field8: "utf8 text"}
      fieldSpec = {name: "field8", start: 1, type: 'utf8', length: 9}

      result = @subject.encodeFieldBE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes a uint32 field", ->
      expectedBuffer = new Buffer(9)
      expectedBuffer.fill(0)
      expectedBuffer.writeUInt32BE(103423, 1)

      outBuffer = new Buffer(9)
      outBuffer.fill(0)

      obj = {field9: 103423}
      fieldSpec = {name: "field9", start: 1, type: 'uint32'}

      result = @subject.encodeFieldBE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes a int32 field", ->
      expectedBuffer = new Buffer(9)
      expectedBuffer.fill(0)
      expectedBuffer.writeInt32BE(-103423, 1)

      outBuffer = new Buffer(9)
      outBuffer.fill(0)

      obj = {field10: -103423}
      fieldSpec = {name: "field10", start: 1, type: 'int32'}

      result = @subject.encodeFieldBE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes a bit field", ->
      expectedBuffer = new Buffer(2)
      expectedBuffer.fill(0)
      expectedBuffer.writeInt8(4, 1)

      outBuffer = new Buffer(2)
      outBuffer.fill(0)

      obj = {field11: true}
      fieldSpec = {name: "field11", start: 1, type: 'bit', position: 2}

      result = @subject.encodeFieldBE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

  describe "#encodeFieldLE", ->
    it "encodes an int8 field", ->
      expectedBuffer = new Buffer(2)
      expectedBuffer.fill(0)
      expectedBuffer.writeInt8(-11, 1)

      outBuffer = new Buffer(2)
      outBuffer.fill(0)

      obj = {field1: -11}
      fieldSpec = {name: "field1", start: 1, type: 'int8'}

      result = @subject.encodeFieldLE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes an uint8 field", ->
      expectedBuffer = new Buffer(2)
      expectedBuffer.fill(0)
      expectedBuffer.writeUInt8(11, 1)

      outBuffer = new Buffer(2)
      outBuffer.fill(0)

      obj = {field2: 11}
      fieldSpec = {name: "field2", start: 1, type: 'uint8'}

      result = @subject.encodeFieldLE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes an int16 field", ->
      expectedBuffer = new Buffer(3)
      expectedBuffer.fill(0)
      expectedBuffer.writeInt16LE(-305, 1)

      outBuffer = new Buffer(3)
      outBuffer.fill(0)

      obj = {field3: -305}
      fieldSpec = {name: "field3", start: 1, type: 'int16'}

      result = @subject.encodeFieldLE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes an uint16 field", ->
      expectedBuffer = new Buffer(3)
      expectedBuffer.fill(0)
      expectedBuffer.writeUInt16LE(305, 1)

      outBuffer = new Buffer(3)
      outBuffer.fill(0)

      obj = {field4: 305}
      fieldSpec = {name: "field4", start: 1, type: 'uint16'}

      result = @subject.encodeFieldLE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes an float field", ->
      expectedBuffer = new Buffer(10)
      expectedBuffer.fill(0)
      expectedBuffer.writeFloatLE(305.11, 1)

      outBuffer = new Buffer(10)
      outBuffer.fill(0)

      obj = {field5: 305.11}
      fieldSpec = {name: "field5", start: 1, type: 'float'}

      result = @subject.encodeFieldLE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes an double field", ->
      expectedBuffer = new Buffer(10)
      expectedBuffer.fill(0)
      expectedBuffer.writeDoubleLE(30005.11, 1)

      outBuffer = new Buffer(10)
      outBuffer.fill(0)

      obj = {field6: 30005.11}
      fieldSpec = {name: "field6", start: 1, type: 'double'}

      result = @subject.encodeFieldLE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes an ascii field", ->
      expectedBuffer = new Buffer(15)
      expectedBuffer.fill(0)
      expectedBuffer.write("ascii text", 1, 10, 'ascii')

      outBuffer = new Buffer(15)
      outBuffer.fill(0)

      obj = {field7: "ascii text"}
      fieldSpec = {name: "field7", start: 1, type: 'ascii', length: 10}

      result = @subject.encodeFieldLE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes an utf8 field", ->
      expectedBuffer = new Buffer(15)
      expectedBuffer.fill(0)
      expectedBuffer.write("utf8 text", 1, 9, 'utf8')

      outBuffer = new Buffer(15)
      outBuffer.fill(0)

      obj = {field8: "utf8 text"}
      fieldSpec = {name: "field8", start: 1, type: 'utf8', length: 9}

      result = @subject.encodeFieldLE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes a uint32 field", ->
      expectedBuffer = new Buffer(9)
      expectedBuffer.fill(0)
      expectedBuffer.writeUInt32LE(103423, 1)

      outBuffer = new Buffer(9)
      outBuffer.fill(0)

      obj = {field9: 103423}
      fieldSpec = {name: "field9", start: 1, type: 'uint32'}

      result = @subject.encodeFieldLE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes a int32 field", ->
      expectedBuffer = new Buffer(9)
      expectedBuffer.fill(0)
      expectedBuffer.writeInt32LE(-103423, 1)

      outBuffer = new Buffer(9)
      outBuffer.fill(0)

      obj = {field10: -103423}
      fieldSpec = {name: "field10", start: 1, type: 'int32'}

      result = @subject.encodeFieldLE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes a bit field", ->
      expectedBuffer = new Buffer(2)
      expectedBuffer.fill(0)
      expectedBuffer.writeInt8(4, 1)

      outBuffer = new Buffer(2)
      outBuffer.fill(0)

      obj = {field11: true}
      fieldSpec = {name: "field11", start: 1, type: 'bit', position: 2}

      result = @subject.encodeFieldLE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

  describe "#findFieldLength", ->
    it "works for int8's", ->
      field = {name: "field1", start: 2,  type: 'int8'  }

      result = @subject.findFieldLength(field)
      expect(result).to.equal(3)

    it "works for uint8's", ->
      field = {name: "field1", start: 2,  type: 'uint8'  }

      result = @subject.findFieldLength(field)
      expect(result).to.equal(3)

    it "works for int16's ", ->
      field = {name: "field1", start: 2,  type: 'uint16'  }

      result = @subject.findFieldLength(field)
      expect(result).to.equal(4)

    it "works for float's", ->
      field = {name: "field1", start: 2,  type: 'float'  }

      result = @subject.findFieldLength(field)
      expect(result).to.equal(6)

    it "works for double's", ->
      field = {name: "field1", start: 2,  type: 'double'  }

      result = @subject.findFieldLength(field)
      expect(result).to.equal(10)

    it "works for ascii's", ->
      field = {name: "field1", start: 2,  type: 'ascii', length: 55  }

      result = @subject.findFieldLength(field)
      expect(result).to.equal(57)

    it "works for utf8's", ->
      field = {name: "field1", start: 2,  type: 'utf8', length: 59  }

      result = @subject.findFieldLength(field)
      expect(result).to.equal(61)

    it "works for uint32's", ->
      field = {name: "field1", start: 2,  type: 'uint32' }

      result = @subject.findFieldLength(field)
      expect(result).to.equal(6)

    it "works for int32's", ->
      field = {name: "field1", start: 2,  type: 'int32' }

      result = @subject.findFieldLength(field)
      expect(result).to.equal(6)

    it "works for bit's", ->
      field = {name: "field1", start: 2,  type: 'bit', position: 3 }

      result = @subject.findFieldLength(field)
      expect(result).to.equal(3)

  describe "#findSpecBufferSize", ->
    it "finds the max size of a buffer", ->
      result = @subject.findSpecBufferSize(@bufferLESpec)
      expect(result).to.equal(46)


