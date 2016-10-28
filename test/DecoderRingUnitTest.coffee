expect = require("chai").expect
sinon = require("sinon")

DecoderRing = require("../src/DecoderRing")

describe "DecoderRing unit test", ->
  beforeEach ->
    @fieldDecoder = {decodeFieldBE:(->), decodeFieldLE:(->)}
    @fieldDecoderMock = sinon.mock(@fieldDecoder)

    @fieldEncoder = {encodeFieldBE:(->), encodeFieldLE:(->), findSpecBufferSize:(->)}
    @fieldEncoderMock = sinon.mock(@fieldEncoder)

    @subject = new DecoderRing(@fieldDecoder, @fieldEncoder)
    {@bufferBE, @bufferLE} = require("./Fixtures")

  afterEach ->
    @fieldDecoderMock.verify()
    @fieldEncoderMock.verify()

  describe "responds to", ->
    it "decode", ->
      expect(@subject).to.respondTo("decode")
    it "encode", ->
      expect(@subject).to.respondTo("encode")

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

  describe "#encode", ->
    it "fills the buffer with 0's", ->
      bufferSize50With0s = Buffer.alloc(50)

      spec = {bigEndian: true, fields: []}

      @fieldEncoderMock.expects("findSpecBufferSize").
        withArgs(spec).returns(50).once()

      result = @subject.encode({}, spec)

      expect(result).to.deep.equal(bufferSize50With0s)


    it "encodes big endian using the field decoder", ->
      fooBuffer = Buffer.from("foo")
      obj = {field1: 11, field2: -23}

      spec = {
        bigEndian: true
        fields: [
          {name: "field1", start: 0,  type: 'int8'  }
          {name: "field2", start: 0,  type: 'int16'  }
        ]
      }

      @fieldEncoderMock.expects("findSpecBufferSize").
        withArgs(spec).returns(50).once()

      @fieldEncoderMock.expects("encodeFieldBE").
        withArgs(sinon.match.instanceOf(Buffer), sinon.match.object, sinon.match.object).
        returns(fooBuffer).twice()

      result = @subject.encode(obj, spec)
      expect(result).to.deep.equal(fooBuffer)

    it "encodes little endian using the field decoder", ->
      fooBuffer = Buffer.from("foo")
      obj = {field1: 11, field2: -23}

      spec = {
        bigEndian: false
        fields: [
          {name: "field1", start: 0,  type: 'int8'  }
          {name: "field2", start: 0,  type: 'int16'  }
        ]
      }

      @fieldEncoderMock.expects("findSpecBufferSize").
        withArgs(spec).returns(50).once()

      @fieldEncoderMock.expects("encodeFieldLE").
        withArgs(sinon.match.instanceOf(Buffer), sinon.match.object, sinon.match.object).
        returns(fooBuffer).twice()

      result = @subject.encode(obj, spec)
      expect(result).to.deep.equal(fooBuffer)

    it "properly ands together bit fields with the same start value", ->
      oneBuffer = Buffer.alloc(1)
      oneBuffer.writeUInt8(1, 0)
      twoBuffer = Buffer.alloc(1)
      twoBuffer.writeUInt8(2, 0)
      threeBuffer = Buffer.alloc(1)
      threeBuffer.writeUInt8(3, 0)

      obj = {field1: true, field2: true}

      spec = {
        bigEndian: false
        fields: [
          {name: "field1", start: 0,  type: 'bit', position: 0  }
          {name: "field2", start: 0,  type: 'bit', position: 1  }
        ]
      }

      @fieldEncoderMock.expects("findSpecBufferSize").
        withArgs(spec).returns(1).once()

      @fieldEncoderMock.expects("encodeFieldLE").
        returns(threeBuffer).once()

      result = @subject.encode(obj, spec)
      expect(result).to.deep.equal(threeBuffer)

    it "doesn't calculate the size if a length field is in the spec", ->
      spec =
        length: 1
        fields: [
          { name: "field1", start: 0, type: 'int8' }
        ]

      @fieldEncoderMock.expects("findSpecBufferSize").never()

      @subject.encode(field1: 11, spec)


