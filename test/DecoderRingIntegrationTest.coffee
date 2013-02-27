expect = require("chai").expect

# DecoderRing = require("../src/DecoderRing") # coffeescript
DecoderRing = require("../lib/DecoderRing") # compiled javascript
# DecoderRing = require("decoder-ring") # package

describe "BinaryDecoderRing Integration Test", ->
  beforeEach ->
    @subject = new DecoderRing
    {@bufferBE, @bufferLE} = require("./Fixtures")

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
          {name: "field12", start: 38, type: 'uint32'}
          {name: "field13", start: 42, type: 'int32'}
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
      expect(result.field12).to.equal(79001)
      expect(result.field13).to.equal(-79001)

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
          {name: "field9", start: 37, type: 'bit', position: 7}
          {name: "field10", start: 37, type: 'bit', position: 6}
          {name: "field11", start: 37, type: 'bit', position: 0}
          {name: "field12", start: 38, type: 'uint32'}
          {name: "field13", start: 42, type: 'int32'}
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
      expect(result.field9).to.be.true
      expect(result.field10).to.be.false
      expect(result.field11).to.be.true
      expect(result.field12).to.equal(79002)
      expect(result.field13).to.equal(-79002)

