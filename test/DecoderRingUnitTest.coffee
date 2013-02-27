expect = require("chai").expect
sinon = require("sinon")

# DecoderRing = require("../src/DecoderRing") # coffeescript
DecoderRing = require("../lib/DecoderRing") # compiled javascript

describe "DecoderRing unit test", ->
  beforeEach ->
    @fieldDecoder = {decodeFieldBE:(->), decodeFieldLE:(->)}
    @fieldDecoderMock = sinon.mock(@fieldDecoder)

    @subject = new DecoderRing(@fieldDecoder)
    {@bufferBE, @bufferLE} = require("./Fixtures")

  afterEach ->
    @fieldDecoderMock.verify()

  describe "responds to", ->
    it "decode", ->
      expect(@subject).to.respondTo("decode")

  describe "#decode", ->
    it "decodes big endian using the field decoder", ->
      spec = {
        bigEndian: true
        fields: [
          {name: "field1", start: 0,  type: 'int8'  }
          {name: "field2", start: 0,  type: 'int16'  }
        ]
      }

      @fieldDecoderMock.expects("decodeFieldBE").
      withArgs(@bufferBE, sinon.match.object).returns({result: "foo"}).twice()

      result = @subject.decode(@bufferBE, spec)
      expect(result.field1).to.deep.equal({result: "foo"})
      expect(result.field2).to.deep.equal({result: "foo"})

    it "decodes little endian using the field decoder", ->
      spec = {
        bigEndian: false
        fields: [
          {name: "field1", start: 0,  type: 'int8'  }
          {name: "field2", start: 0,  type: 'int16'  }
        ]
      }

      @fieldDecoderMock.expects("decodeFieldLE").
      withArgs(@bufferLE, sinon.match.object).returns({result: "foo"}).twice()

      result = @subject.decode(@bufferLE, spec)
      expect(result.field1).to.deep.equal({result: "foo"})
      expect(result.field2).to.deep.equal({result: "foo"})


