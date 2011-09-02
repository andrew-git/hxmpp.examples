
class Test extends ClientBase {
	
	var vcard : jabber.client.VCard;
	
	override function onLogin() {
		
		//stream.sendPresence();
		
		vcard = new jabber.client.VCard( stream );
		vcard.onLoad = onVCardLoad;
		vcard.onUpdate = function(){
			trace( "VCard updated" );
		}
		vcard.load(); // load own vcard
		
		
		var roster = new jabber.client.Roster( stream );
		roster.onLoad = function(){
			for( i in roster.items ) {
				vcard.load( i.jid );
			}
		}
		roster.load();
		
		
		//vcard.load("julia@disktree");
	}
	
	function onVCardLoad( jid : String, d : xmpp.VCard ) {
		
		if( jid == null ) jid = "my";
		trace( "VCard loaded ["+jid+"]:" );
		
		if( d == null || d.photo == null || d.photo.binval == null || d.photo.type == null )
			return;
		
		#if js
		var e = js.Lib.document.createElement( "img" );
		e.setAttribute( "src", "data:"+d.photo.type+";base64,"+d.photo.binval );
		js.Lib.document.getElementById("vcards").appendChild( e );
		
		#elseif flash
		var t = d.photo.binval.split("\n").join("");
		var l = new flash.display.Loader();
		l.loadBytes( jabber.util.Base64.decodeBytes( t ).getData() );
		flash.Lib.current.addChild( l );
		
		#elseif neko
		/*
		var type = d.photo.type;
		type = type.substr( type.indexOf("/")+1 );
		var fo = neko.io.File.write( jid+"."+type );
		fo.write( jabber.util.Base64.decodeBytes( d.photo.binval ) );
		fo.flush();
		fo.close();
		*/
		
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
		new Test().login( "tong@jabber.spektral.at", "rotz", "jabber.spektral.at" );
		//new Test().login( "romeo@disktree" );
	}
	
}
