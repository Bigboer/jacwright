////////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2009 Jacob Wright
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
////////////////////////////////////////////////////////////////////////////////
package jac.utils {
	
	import flash.utils.getDefinitionByName;
	
	public class JSON {
		
		public static function decode(st:String, objectHook:Function = null, arrayHook:Function = null):Object {
			var d:JSONDecoder = new JSONDecoder(st, objectHook, arrayHook);
			return d.getObject();
		}
		
		public static function encode(o:Object, readable:Boolean = false):String {
			var e:JSONEncoder = new JSONEncoder(o, readable);
			return e.getString();
		}
		
		
		private static var ArrayCollection:Object;
		private	static var ObjectProxy:Object;
		public static function decodeForProvider(st:String):Object {
			ArrayCollection = getDefinitionByName("mx.collections.ArrayCollection");
			ObjectProxy = getDefinitionByName("mx.utils.ObjectProxy");
			var d:JSONDecoder = new JSONDecoder(st, convertToObjectProxy, convertToArrayCollection);
			return d.getObject();
		}
		
		private static function convertToObjectProxy(array:Array):Object
		{
			return new ObjectProxy(array);
		}
		
		private static function convertToArrayCollection(array:Array):Object
		{
			return new ArrayCollection(array);
		}
	}
}
	import flash.utils.getDefinitionByName;
	

// internal/private classes

class JSONEncoder {
	private var jsonString:String;
	private static var validKey:RegExp = new RegExp("[a-zA-Z_$][a-zA-Z0-9_$]*");
	private var readable:Boolean = false;
	private var tabs:String = "";
	private var tab:String = "    ";

	public function JSONEncoder(o:Object, readable:Boolean = false) {
		this.readable = readable;
		jsonString = convertToString(o);
	}

	public function getString():String {
		return jsonString;
	}

	private function convertToString(value:Object = false):String {	
		if (value is String) {	
			return escapeString(value as String);
		} else if (value is Number) {	
			return isFinite(value as Number) ? value.toString() : "null";	
		} else if (value is Boolean) {	
			return value ? "true" : "false";	
		} else if (value is Array) {	
			return arrayToString(value as Array);
		} else if (value is Object && value != null) {	
			return objectToString(value);
		}
        return "null";
	}
	
	private function escapeString(str:String):String {	
		var s:String = "";	
		var ch:String;	
		var len:Number = str.length;
			
		for (var i:int = 0; i < len; i++) {	
			ch = str.charAt(i);
			switch (ch) {
				case '"':
					s += "\\\"";
					break;
				case '\\':
					s += "\\\\";
					break;
				case '\b':
					s += "\\b";
					break;
				case '\f':
					s += "\\f";
					break;
				case '\n':
					s += "\\n";
					break;
				case '\r':
					s += "\\r";
					break;
				case '\t':
					s += "\\t";
					break;
				default:	
					if (ch < ' '/* || ch > ''*/) {	
						var hexCode:String = ch.charCodeAt(0).toString(16);	
						var zeroPad:String = "";
						if (hexCode.length == 1)
							zeroPad = "000";
						else if (hexCode.length == 2)
							zeroPad = "00";
						else if (hexCode.length == 3)
							zeroPad = "0";	
						s += "\\u" + zeroPad + hexCode;
					} else {	
						s += ch;	
					}
			}
		}
		
		return '"' + s + '"';
	}
	
	private function arrayToString(a:Array):String {	
		var s:String = "";
		tabs += tab;	
		for (var i:int = 0; i < a.length; i++) {	
			if (s.length > 0) {	
				s += "," + (readable ? "\n" + tabs : "")
			}	
			s += convertToString(a[i]);	
		}
		tabs = tabs.substr(0, tabs.length - tab.length);
		if (readable) {
			s += "\n" + tabs;
			return "[\n" + tabs + tab + s + "]";
		} else {			
			return "[" + s + "]";
		}
	}
	
	private function objectToString(o:Object):String {
		var s:String = "";
		tabs += tab;
		var value:Object;
		for (var key:String in o) {
			value = o[key];
			if (value is Function) {
				continue;
			}
			if (s.length > 0) {
				s += "," + (readable ? "\n" + tabs : "")
			}
			if (!validKey.test(key))
				key = escapeString(key);
			else
				key = '"' + key + '"';
			s += key + ':' + (readable ? " " : "") + convertToString(value);
		}
		tabs = tabs.substr(0, tabs.length - tab.length);
		if (readable) {
			s += "\n" + tabs;
			return "{\n" + tabs + tab + s + "}";
		} else {
			return "{" + s + "}";
		}
	}
	
}

class JSONDecoder {
	private var obj:Object;
	private var tokenizer:JSONTokenizer;
	private var token:JSONToken;
	private var objectHook:Function;
	private var arrayHook:Function;

	public function JSONDecoder(s:String, objectHook:Function, arrayHook:Function) {
		this.objectHook = objectHook;
		this.arrayHook = arrayHook;
		tokenizer = new JSONTokenizer(s);
		nextToken();
		obj = parseValue();
	}

	public function getObject():Object {
		return obj;
	}

	private function nextToken(lookingForKey:Boolean = false):JSONToken {
		return token = tokenizer.getNextToken(lookingForKey);
	}
	
	private function parseArray():Object {
		var a:Array = new Array();		
		nextToken();		
		if (token.type == JSONTokenType.RIGHT_BRACKET) {
			if (arrayHook != null)
				return arrayHook(a);
			else
				return a;
		}		
		while (true) {
			a.push(parseValue());
			nextToken();
			if (token.type == JSONTokenType.RIGHT_BRACKET) {
				return a;
			} else if (token.type == JSONTokenType.COMMA) {
				nextToken();
			} else {
				tokenizer.parseError("Expecting ] or , but found " + token.value);
			}
		}
        return null;
	}

	private function parseObject():Object {	
		var o:Object = new Object();
		var key:String
		nextToken(true);
		
		if (token.type == JSONTokenType.RIGHT_BRACE) {
			if (objectHook != null)
				o = objectHook(o);
			return o;
		}
					
		while (true) {
			if (token.type == JSONTokenType.STRING || token.type == JSONTokenType.KEY) {
				key = String(token.value);				
				nextToken();
				if (token.type == JSONTokenType.COLON) {
					nextToken();
					o[key] = parseValue();
					nextToken(true);
					if (token.type == JSONTokenType.RIGHT_BRACE) {
						return o;
					} else if (token.type == JSONTokenType.COMMA) {
						nextToken(true);
					} else {
						tokenizer.parseError("Expecting } or , but found " + token.value);
					}
				} else {
					tokenizer.parseError("Expecting : but found " + token.value);
				}
			} else {
				tokenizer.parseError("Expecting string but found " + token.value);
			}
		}
        return null;
	}
	
	private function parseValue():Object {
		switch (token.type) {
			case JSONTokenType.LEFT_BRACE:
				return parseObject();

			case JSONTokenType.LEFT_BRACKET:
				return parseArray();
				
			case JSONTokenType.STRING:
			case JSONTokenType.NUMBER:
			case JSONTokenType.TRUE:
			case JSONTokenType.FALSE:
			case JSONTokenType.NULL:
				return token.value;
	
			default:
				tokenizer.parseError("Unexpected " + token.value);
		}
        return null;
	}
}

	
class JSONTokenizer {
	private var obj:Object;
	private var jsonString:String;
	private var loc:int;
	private var ch:String;
	private static var validKey:RegExp = new RegExp("[a-zA-Z0-9_$]");

	public function JSONTokenizer(s:String) {
		jsonString = s;
		loc = 0;
		nextChar();
	}

	public function getNextToken(lookingForKey:Boolean = false):JSONToken {
		var token:JSONToken = new JSONToken();
		skipIgnored();
		
		if (lookingForKey) {
			switch (ch) {
				case '}':
					token.type = JSONTokenType.RIGHT_BRACE;
					token.value = '}';
					nextChar();
					break;
				case ',':
					token.type = JSONTokenType.COMMA;
					token.value = ',';
					nextChar();
					break;
				case '"':
					token = readString('"');
					break;
				case "'":
					token = readString("'");
					break;
				default:
					token = readKey();
			}
			return token;
		}
			
		switch (ch) {
			case '{':
				token.type = JSONTokenType.LEFT_BRACE;
				token.value = '{';
				nextChar();
				break;
			case '}':
				token.type = JSONTokenType.RIGHT_BRACE;
				token.value = '}';
				nextChar();
				break;
			case '[':
				token.type = JSONTokenType.LEFT_BRACKET;
				token.value = '[';
				nextChar();
				break;
			case ']':
				token.type = JSONTokenType.RIGHT_BRACKET;
				token.value = ']';
				nextChar();
				break;
			case ',':
				token.type = JSONTokenType.COMMA;
				token.value = ',';
				nextChar();
				break;
			case ':':
				token.type = JSONTokenType.COLON;
				token.value = ':';
				nextChar();
				break;
			case 't':
				var possibleTrue:String = "t" + nextChar() + nextChar() + nextChar();
				if (possibleTrue == "true") {
					token.type = JSONTokenType.TRUE;
					token.value = true;
					nextChar();
				} else {
					parseError("Expecting 'true' but found " + possibleTrue);
				}
				break;
			case 'f':
				var possibleFalse:String = "f" + nextChar() + nextChar() + nextChar() + nextChar();
				if (possibleFalse == "false") {
					token.type = JSONTokenType.FALSE;
					token.value = false;
					nextChar();
				} else {
					parseError("Expecting 'false' but found " + possibleFalse);
				}
				break;
			case 'n':
				var possibleNull:String = "n" + nextChar() + nextChar() + nextChar();
				if (possibleNull == "null") {
					token.type = JSONTokenType.NULL;
					token.value = null;
					nextChar();
				} else {
					parseError("Expecting 'null' but found " + possibleNull);
				}
				break;
			case '"':
				token = readString('"');
				break;
			case "'":
				token = readString("'");
				break;
			default: 
				if (isDigit(ch) || ch == '-') {
					token = readNumber();
				} else if (ch == '') {
					return null;
				} else {		
					parseError("Unexpected " + ch + " encountered");
				}
		}
		
		return token;
	}

	private function readString(quote:String = '"'):JSONToken {
		var token:JSONToken = new JSONToken();
		token.type = JSONTokenType.STRING;
		var string:String = "";
		nextChar();
		
		while (ch != quote && ch != '') {
			if (ch == '\\') {
				nextChar();
				switch (ch) {
					case quote:
						string += quote;
						break;
					case '/':
						string += "/";
						break;
					case '\\':
						string += '\\';
						break;
					case 'b':
						string += '\b';
						break;
					case 'f':
						string += '\f';
						break;
					case 'n':
						string += '\n';
						break;
					case 'r':
						string += '\r';
						break;
					case 't':
						string += '\t'
						break;
					case 'u':	
						var hexValue:String = "";	
						for (var i:int = 0; i < 4; i++) {	
							if (!isHexDigit(nextChar())) {
								parseError("Excepted a hex digit, but found: " + ch);
							}	
							hexValue += ch;
						}
						string += String.fromCharCode(parseInt(hexValue, 16));
						break;
					default:
						string += '\\' + ch;
				}
			} else {	
				string += ch;
			}
			nextChar();
		}
	
		if (ch == '') {
			parseError("Unterminated string literal");
		}
		
		nextChar();
		token.value = string;
		return token;
	}
	
	private function readKey():JSONToken {
		var token:JSONToken = new JSONToken();
		token.type = JSONTokenType.KEY;
		var string:String = ch;
		nextChar();
		
		var bad:Boolean = false;
		while (ch != '') {
			if (!validKey.test(ch)) {
				break;
			}
			string += ch;
			nextChar();
		}
		
		if (string == '') {
			parseError("Looking for object key:value pair, not found");
		}

		token.value = string;
		return token;
	}

	private function readNumber():JSONToken {
		var token:JSONToken = new JSONToken();
		token.type = JSONTokenType.NUMBER;
		var input:String = "";
		if (ch == '-') {
			input += '-';
			nextChar();
		}
	
		while (isDigit(ch)) {
			input += ch;
			nextChar();
		}
	
		if (ch == '.') {
			input += '.';
			nextChar();
	
			while (isDigit(ch)) {
				input += ch;
				nextChar();
			}
		}
	
		var num:Number = Number(input);
		if (isFinite(num)) {
			token.value = num;
			return token;
		} else {
			parseError("Number " + num + " is not valid!");
		}
        return null;
	}
	
	private function nextChar():String {
		return ch = jsonString.charAt(loc++);
	}

	private function skipIgnored():void {
		skipWhite();
		skipComments();
		skipWhite();
	}

	private function skipComments():void {
		if (ch == '/') {
			nextChar();
			switch (ch) {
				case '/':
					do {
						nextChar();
					} while (ch != '\n' && ch != '')
					nextChar();
					break;
				case '*':
					nextChar();
					while (true) {
						if (ch == '*') {
							nextChar();
							if (ch == '/') {
								nextChar();
								break;
							}
						} else {
							nextChar();
						}
						if (ch == '') {
							parseError("Multi-line comment not closed");
						}
					}
					break;
				default:
					parseError("Unexpected " + ch + " encountered (expecting '/' or '*')");
			}
		}
	}

	private function skipWhite():void {
		while (isSpace(ch)) {
			nextChar();
		}
	}

	private function isSpace(ch:String):Boolean {
		return (ch == ' ' || ch == '\t' || ch == '\n' || ch == '\r');
	}

	private function isDigit(ch:String):Boolean {
		return (ch >= '0' && ch <= '9');
	}

	private function isHexDigit(ch:String):Boolean {
		var uc:String = ch.toUpperCase();
		return (isDigit(ch) || (uc >= 'A' && uc <= 'F'));
	}

 	public function parseError(message:String):void {
		throw new Error(message + jsonString.substr(loc - 20, 80), loc);
	}
}

class JSONToken {

	private var _type:int;
	private var _value:Object;

	public function JSONToken(type:int = -1, value:Object = null) {
		_type = type;
		_value = value;
	}

	public function get type():int {
		return _type;	
	}

	public function set type(value:int):void {
		_type = value;	
	}

	public function get value():Object {
		return _value;	
	}

	public function set value (v:Object):void {
		_value = v;	
	}
}

class JSONTokenType {
	public static const UNKNOWN:int = -1;
	public static const COMMA:int = 0;
	public static const LEFT_BRACE:int = 1;
	public static const RIGHT_BRACE:int = 2;
	public static const LEFT_BRACKET:int = 3;
	public static const RIGHT_BRACKET:int = 4;
	public static const COLON:int = 6;
	public static const TRUE:int = 7;
	public static const FALSE:int = 8;
	public static const NULL:int = 9;
	public static const STRING:int = 10;
	public static const NUMBER:int = 11;
	public static const KEY:int = 12;
}