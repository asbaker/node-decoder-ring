expect = require("chai").expect
# BinaryDecoderRing = require("decoder-ring")
BinaryDecoderRing = require("../lib/index")

describe "BinaryDecoderRing", ->
  beforeEach ->
    @subject = new BinaryDecoderRing

    @bufferBE = new Buffer(38)
    @bufferBE.writeInt8(-127, 0)
    @bufferBE.writeUInt8(254, 1)
    @bufferBE.writeInt16BE(5327, 2)
    @bufferBE.writeUInt16BE(5328, 4)
    @bufferBE.writeFloatBE(-15.33, 6)
    @bufferBE.writeDoubleBE(-1534.98, 10)
    @bufferBE.write("ascii text", 18, 10,'ascii')
    @bufferBE.write("utf8 text", 28, 9, 'utf8')
    @bufferBE.writeUInt8(129, 37)

    @bufferLE = new Buffer(38)
    @bufferLE.writeInt8(-127, 0)
    @bufferLE.writeUInt8(254, 1)
    @bufferLE.writeInt16LE(5327, 2)
    @bufferLE.writeUInt16LE(5328, 4)
    @bufferLE.writeFloatLE(-15.33, 6)
    @bufferLE.writeDoubleLE(-1534.98, 10)
    @bufferLE.write("ascii text", 18, 10,'ascii')
    @bufferLE.write("utf8 text", 28, 9, 'utf8')
    @bufferLE.writeUInt8(129, 37)

  describe "responds to", ->
    it "decode", ->
      expect(@subject).to.respondTo("decode")

    it "decodeFieldBE", ->
      expect(@subject).to.respondTo("decodeFieldBE")

    it "decodeFieldLE", ->
      expect(@subject).to.respondTo("decodeFieldLE")

  describe "#decode", ->
    it "decodes big endian specifications", ->
      spec = {
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
        ]
      }

      result = @subject.decode(@bufferBE, spec)

      expect(result.field1).to.equal(-127)
      expect(result.field2).to.equal(254)
      expect(result.field3).to.equal(5327)
      expect(result["field4"]).to.equal(5328)
      expect(result.field5).to.be.closeTo(-15.33, 0.01)
      expect(result.field6).to.be.closeTo(-1534.98, 0.01)
      expect(result.field7).to.equal("ascii text")
      expect(result.field8).to.equal("utf8 text")
      expect(result.field9).to.be.true
      expect(result.field10).to.be.false
      expect(result.field11).to.be.true

    it "decodes little endian specifications", ->
      spec = {
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
        ]
      }

      result = @subject.decode(@bufferLE, spec)

      expect(result.field1).to.equal(-127)
      expect(result.field2).to.equal(254)
      expect(result.field3).to.equal(5327)
      expect(result["field4"]).to.equal(5328)
      expect(result.field5).to.be.closeTo(-15.33, 0.01)
      expect(result.field6).to.be.closeTo(-1534.98, 0.01)
      expect(result.field7).to.equal("ascii text")
      expect(result.field8).to.equal("utf8 text")

  describe "#decodeFieldBE", ->
    it "decodes an int8 field", ->
      fieldSpec = {name: "foo", start: 0, type: 'int8'}
      result = @subject.decodeFieldBE(@bufferBE, fieldSpec)
      expect(result).to.equal(-127)

    it "decodes an uint8 field", ->
      fieldSpec = {name: "foo", start: 1, type: 'uint8'}
      result = @subject.decodeFieldBE(@bufferBE, fieldSpec)
      expect(result).to.equal(254)

    it "decodes an int16 field", ->
      fieldSpec = {name: "foo", start: 2, type: 'int16'}
      result = @subject.decodeFieldBE(@bufferBE, fieldSpec)
      expect(result).to.equal(5327)

    it "decodes an uint16 field", ->
      fieldSpec = {name: "foo", start: 4, type: 'uint16'}
      result = @subject.decodeFieldBE(@bufferBE, fieldSpec)
      expect(result).to.equal(5328)

    it "decodes an float field", ->
      fieldSpec = {name: "foo", start: 6, type: 'float'}
      result = @subject.decodeFieldBE(@bufferBE, fieldSpec)
      expect(result).to.be.closeTo(-15.33, 0.01)

    it "decodes an double field", ->
      fieldSpec = {name: "foo", start: 10, type: 'double'}
      result = @subject.decodeFieldBE(@bufferBE, fieldSpec)
      expect(result).to.be.closeTo(-1534.98, 0.01)

    it "decodes an ascii field", ->
      fieldSpec = {name: "foo", start: 18, length: 10, type: 'ascii'}
      result = @subject.decodeFieldBE(@bufferBE, fieldSpec)
      expect(result).to.equal("ascii text")

    it "decodes an utf8 field", ->
      fieldSpec = {name: "foo", start: 28, length: 9, type: 'utf8'}
      result = @subject.decodeFieldBE(@bufferBE, fieldSpec)
      expect(result).to.equal("utf8 text")

    it "decodes a bit field", ->
      fieldSpec = {name: "foo", start: 37, type: 'bit', position: 7}
      result = @subject.decodeFieldBE(@bufferBE, fieldSpec)
      expect(result).to.be.true


  describe "#decodeFieldLE", ->
    it "decodes an int8 field", ->
      fieldSpec = {name: "foo", start: 0, type: 'int8'}
      result = @subject.decodeFieldLE(@bufferLE, fieldSpec)
      expect(result).to.equal(-127)

    it "decodes an uint8 field", ->
      fieldSpec = {name: "foo", start: 1, type: 'uint8'}
      result = @subject.decodeFieldLE(@bufferLE, fieldSpec)
      expect(result).to.equal(254)

    it "decodes an int16 field", ->
      fieldSpec = {name: "foo", start: 2, type: 'int16'}
      result = @subject.decodeFieldLE(@bufferLE, fieldSpec)
      expect(result).to.equal(5327)

    it "decodes an uint16 field", ->
      fieldSpec = {name: "foo", start: 4, type: 'uint16'}
      result = @subject.decodeFieldLE(@bufferLE, fieldSpec)
      expect(result).to.equal(5328)

    it "decodes an float field", ->
      fieldSpec = {name: "foo", start: 6, type: 'float'}
      result = @subject.decodeFieldLE(@bufferLE, fieldSpec)
      expect(result).to.be.closeTo(-15.33, 0.01)

    it "decodes an double field", ->
      fieldSpec = {name: "foo", start: 10, type: 'double'}
      result = @subject.decodeFieldLE(@bufferLE, fieldSpec)
      expect(result).to.be.closeTo(-1534.98, 0.01)

    it "decodes an ascii field", ->
      fieldSpec = {name: "foo", start: 18, length: 10, type: 'ascii'}
      result = @subject.decodeFieldLE(@bufferLE, fieldSpec)
      expect(result).to.equal("ascii text")

    it "decodes an utf8 field", ->
      fieldSpec = {name: "foo", start: 28, length: 9, type: 'utf8'}
      result = @subject.decodeFieldLE(@bufferLE, fieldSpec)
      expect(result).to.equal("utf8 text")

    it "decodes a bit field", ->
      fieldSpec = {name: "foo", start: 37, type: 'bit', position: 7}
      result = @subject.decodeFieldLE(@bufferLE, fieldSpec)
      expect(result).to.be.true

