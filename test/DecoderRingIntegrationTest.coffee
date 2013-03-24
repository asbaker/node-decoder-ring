expect = require("chai").expect

DecoderRing = require("../src/DecoderRing") # coffeescript
# DecoderRing = require("../lib/DecoderRing") # compiled javascript

# DecoderRing = require("decoder-ring") # package

describe "BinaryDecoderRing Integration Test", ->
  beforeEach ->
    @subject = new DecoderRing
    {@bufferBE, @bufferLE, @bufferBESpec, @bufferLESpec} = require("./Fixtures")

  describe "#decode", ->
    it "decodes big endian specifications", ->

      result = @subject.decode(@bufferBE, @bufferBESpec)

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
      expect(result.field12).to.equal(79001)
      expect(result.field13).to.equal(-79001)

    it "decodes little endian specifications", ->
      result = @subject.decode(@bufferLE, @bufferLESpec)

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
      expect(result.field12).to.equal(79002)
      expect(result.field13).to.equal(-79002)

  describe "#encode", ->
    it "encodes big endian specifications", ->
      decoded = @subject.decode(@bufferBE, @bufferBESpec)
      encoded = @subject.encode(decoded, @bufferBESpec)
      expect(encoded).to.deep.equal(@bufferBE)


    it "encodes little endian specifications", ->
      decoded = @subject.decode(@bufferLE, @bufferLESpec)
      encoded = @subject.encode(decoded, @bufferLESpec)
      expect(encoded).to.deep.equal(@bufferLE)

    it "encodes bit fields by anding them together", ->
      spec = {
        bigEndian: false
        fields: [
          {name: "field1", start: 0,  type: 'bit', position: 0  }
          {name: "field2", start: 0,  type: 'bit', position: 1  }
          {name: "field3", start: 1,  type: 'bit', position: 2  }
          {name: "field4", start: 1,  type: 'bit', position: 3  }
        ]
      }

      obj = {
        field1: true
        field2: true
        field3: false
        field4: true
      }

      decoded = @subject.encode(obj, spec)
      shouldBe = new Buffer(2)
      shouldBe.writeInt8(3,0)
      shouldBe.writeInt8(8,1)
      expect(decoded).to.deep.equal(shouldBe)

