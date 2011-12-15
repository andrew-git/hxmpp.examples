
import haxe.io.Bytes;
import jabber.util.Base64;

class Test extends ClientBase {
	
	override function onLogin() {
		
		//stream.sendPresence();
		
		//vcard = new jabber.client.VCard( stream );
		var vcard = new jabber.client.VCardTemp( stream );
		vcard.onError = function(e) {
			trace( "VCard error: "+e, "error" );
		}
		vcard.onLoad = onVCardLoad;
		vcard.onUpdate = function(){
			trace( "VCard updated" );
		}
		vcard.load(); // load own vcard
		
		// load roster and vcards of all contacts
		/*
		var roster = new jabber.client.Roster( stream );
		roster.onLoad = function(){
			for( i in roster.items ) {
				vcard.load( i.jid );
			}
		}
		roster.load();
		*/
		
		// load another vcard
		//vcard.load("julia@disktree");
	}
	
	function onVCardLoad( jid : String, d : xmpp.VCardTemp ) {
		
		if( jid == null )
			trace( "Own vcard loaded" );
		else
			trace( "VCard of ["+jid+"] loaded", "info" );
		
		if( d == null || d.photo == null || d.photo.binval == null || d.photo.type == null ) {
			return;
		}
		
		#if js
		var e = js.Lib.document.createElement( "img" );
		e.setAttribute( "src", "data:"+d.photo.type+";base64,"+d.photo.binval );
		js.Lib.document.getElementById("vcards").appendChild( e );
		
		#elseif flash
		var t = d.photo.binval.split("\n").join("");
		var l = new flash.display.Loader();
		l.loadBytes( Base64.decodeBytes( t ).getData() );
		flash.Lib.current.addChild( l );
		
		trace("----------------------");
		
		#elseif neko
		var t = d.photo.binval.split("\n").join("");
		var type =  d.photo.type;
		type = type.substr( type.indexOf("/")+1 );
		var pic = Base64.decodeBytes( t );
		var fo = neko.io.File.write( "recieved."+type );
		fo.write( pic );
		fo.flush();
		fo.close();
		
		#end
		
		// update own vcard
		/*
		if( jid == null ) {
			data.birthday = "9/11 2001";
			vcard.update( data );
		}
		*/
	}
	
	static function main() {
		new Test().login( "romeo@disktree" );
	}
	
}
