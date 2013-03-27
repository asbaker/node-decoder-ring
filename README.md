node-decoder-ring
=================

[![Build Status](https://travis-ci.org/asbaker/node-decoder-ring.png)](https://travis-ci.org/asbaker/node-decoder-ring])

*IMPORTANT: This module only works with node v0.6.0 and later.*

Decoder Ring allows you to use a Javascript object as a specification to decode [Node.js Buffers](http://nodejs.org/api/buffer.html) into a Javascript object.

## Installation

	npm install decoder-ring

##  Usage


### Javascript Object Specification

The Javascript object specification is used to specify endianness and a description of the fields present in the buffer.
```javascript
{
    bigEndian: true,
    fields: [
        {name: "field1", start: 0,  type: 'int8'  },
        {name: "field2", start: 1,  type: 'uint8' },
        {name: "field3", start: 2,  type: 'int16' },
        {name: "field4", start: 4,  type: 'uint16'},
        {name: "field5", start: 6,  type: 'float' },
        {name: "field6", start: 10, type: 'double'},
        {name: "field7", start: 18, type: 'ascii', length: 10 },
        {name: "field8", start: 28, type: 'utf8',  length: 9  },
        {name: "field9", start: 37, type: 'bit', position: 7},
        {name: "field10", start: 37, type: 'bit', position: 6},
        {name: "field11", start: 37, type: 'bit', position: 0},
        {name: "field12", start: 38, type: 'uint32'},
        {name: "field13", start: 42, type: 'int32'}
        {name: "field14", start: 46, type: 'int8', default: 42 }
    ]
}


```

All fields must have a name, a starting byte, and a type. The name is used for assigning the property in the resulting javascript object. Additionally, fields can have a default value which is used when encoding an object's properties that have null or undefined values.

#### Types
* **int8** - Signed 8-bit integer
* **uint8** - Unsigned 8-bit integer
* **int16** - Signed 16-bit integer
* **uint16** - Unsigned 16-bit integer
* **int32** - Signed 32-bit integer
* **uint32** - Unsigned 32-bit integer
* **float** - 4-bit floating point number
* **double** - 8-bit double precision floating point number
* **ascii** - 8-bit per character ASCII encoded text

	This field type must also have a length property which is a count of the number of characters.
* **utf8** - 8-bit per character UTF8 encoded text

	This field type must also have a length property which is a count of the number of characters.
* **bit** - true/false values

	Bit fields are pieces of a 1-byte unsigned integer. Given a big endian, unsigned integer of 129, it will appear as the following when broken down into bits:


  | 128(2^7) | 64(2^6) | 32(2^5) | 16(2^4) | 8(2^3) | 4(2^2) | 2(2^1) | 1(2^0) |
  | :--:	 | :--:	| :--:	| :--:	| :--:   | :--:   | :--:   | :--:   |
  | 1		| 0	   | 0	   | 0	   | 0	  | 0	  | 0	  | 1	  |

	Bit fields must have a position property which is used to check if a specific bit is on or off in the 1-byte unsigned integer.
	The position of the bit of interest, is defined as which power of two the bit falls in the integer. For the bit in the 128th's place, the position would be 7, for the bit in the 1's place the position would be 0.


### Example

```javascript
var DecoderRing = require("decoder-ring")
var decoderRing = new DecoderRing();

var bufferBE = new Buffer(47)
bufferBE.fill(0)
bufferBE.writeInt8(-127, 0)
bufferBE.writeUInt8(254, 1)
bufferBE.writeInt16BE(5327, 2)
bufferBE.writeUInt16BE(5328, 4)
bufferBE.writeFloatBE(-15.33, 6)
bufferBE.writeDoubleBE(-1534.98, 10)
bufferBE.write("ascii", 18, 10,'ascii')
bufferBE.write("utf8 text", 28, 9, 'utf8')
bufferBE.writeUInt8(129, 37)
bufferBE.writeUInt32BE(79001, 38)
bufferBE.writeInt32BE(-79001, 42)
bufferBE.writeInt8(1, 46)

var spec = {
  bigEndian: true,
  fields: [
    { name: "field1", start: 0,   type: 'int8'  },
    { name: "field2", start: 1,   type: 'uint8' },
    { name: "field3", start: 2,   type: 'int16' },
    { name: "field4", start: 4,   type: 'uint16'},
    { name: "field5", start: 6,   type: 'float' },
    { name: "field6", start: 10,  type: 'double'},
    { name: "field7", start: 18,  type: 'ascii',length: 10 },
    { name: "field8", start: 28,  type: 'utf8', length: 9  },
    { name: "field9", start: 37,  type: 'bit', position: 7 },
    { name: "field10", start: 37, type: 'bit', position: 6 },
    { name: "field11", start: 37, type: 'bit', position: 0 },
    { name: "field12", start: 38, type: 'uint32' },
    { name: "field13", start: 42, type: 'int32' },
    { name: "field14", start: 46, type: 'int8', default: 42 }
  ]
}

// Decode the buffer into a javascript object
var result = decoderRing.decode(bufferBE, spec)
console.log(result)

// Assign field14 to undefined to test default value on encoding
result.field14 = undefined

// Encode the object to a buffer
var buffer = decoderRing.encode(result, spec)
console.log(buffer)

// Decode buffer to object and check field14 for default value
var resultWithDefaultValue = decoderRing.decode(buffer, spec)
console.log("Field14 default value: " + resultWithDefaultValue.field14)
```

Result of the above example

```javascript
{ field1: -127,
  field2: 254,
  field3: 5327,
  field4: 5328,
  field5: -15.329999923706055,
  field6: -1534.98,
  field7: 'ascii\u0000\u0000\u0000\u0000\u0000',
  field8: 'utf8 text',
  field9: true,
  field10: false,
  field11: true,
  field12: 79001,
  field13: -79001,
  field14: 1 }

<Buffer 81 fe 14 cf 14 d0 c1 75 47 ae c0 97 fb eb 85 1e b8 52 61 73 63 69 69 20 20 20 20 20 75 74 66 38 20 74 65 78 74 81 00 01 34 99 ff fe cb 67 2a>

Field14 42
```

## Development

### Running tests
	npm test

### Testing the package locally
	npm pack
	npm install decoder-ring-0.4.0.tgz
	node example.js


