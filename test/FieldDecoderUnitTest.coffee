expect = require("chai").expect

FieldDecoder = require("../src/FieldDecoder")

describe "FieldDecoder unit test", ->
  beforeEach ->
    @subject = new FieldDecoder
    {@bufferBE, @bufferLE} = require("./Fixtures")

  describe "responds to", ->
    it "decodeFieldBE", ->
      expect(@subject).to.respondTo("decodeFieldBE")

    it "decodeFieldLE", ->
      expect(@subject).to.respondTo("decodeFieldLE")

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

    it "decodes a uint32 field", ->
      fieldSpec = {name: "foo", start: 38, type: 'uint32'}
      result = @subject.decodeFieldBE(@bufferBE, fieldSpec)
      expect(result).to.equal(79001)

    it "decodes a int32 field", ->
      fieldSpec = {name: "foo", start: 42, type: 'int32'}
      result = @subject.decodeFieldBE(@bufferBE, fieldSpec)
      expect(result).to.equal(-79001)


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

    it "decodes a uint32 field", ->
      fieldSpec = {name: "foo", start: 38, type: 'uint32'}
      result = @subject.decodeFieldLE(@bufferLE, fieldSpec)
      expect(result).to.equal(79002)

    it "decodes a int32 field", ->
      fieldSpec = {name: "foo", start: 42, type: 'int32'}
      result = @subject.decodeFieldLE(@bufferLE, fieldSpec)
      expect(result).to.equal(-79002)

