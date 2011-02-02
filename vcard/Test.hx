
#if flash

import flash.display.Sprite;

private class VCardDisplay extends Sprite {
	
	static var py = 0.0;
	
	public function new( vc : xmpp.VCard ) {
		super();
		//var tf = new flash.text.TextField();
		//tf.text = 
		//addChild( tf );
		if( vc.photo != null ) {
			try {
				var t = vc.photo.binval.split("\n").join("");
				var bc = new haxe.BaseCode( haxe.io.Bytes.ofString( jabber.util.Base64.CHARS ) );
				var ba = bc.decodeBytes( haxe.io.Bytes.ofString( t ) ).getData();
				var l = new flash.display.Loader();
				l.contentLoaderInfo.addEventListener( flash.events.Event.COMPLETE, function(e) {
					l.y = py;
					py += l.height;
				});
				l.loadBytes( ba );
				addChild( l );
			} catch( e : Dynamic ) {
				trace( e );
				return;
			}
		}
		flash.Lib.current.addChild( this );
	}
}

#end

class Test extends ClientBase {
	
	var vcard : jabber.client.VCard;
	
	override function onLogin() {
		
		stream.sendPresence();
		
		vcard = new jabber.client.VCard( stream );
		vcard.onLoad = onVCardLoad;
		vcard.onUpdate = function(){
			trace( "VCard updated" );
		}
		vcard.load(); // load own vcard
		vcard.load("julia@disktree");
	}
	
	function onVCardLoad( jid : String, data : xmpp.VCard ) {
		
		trace( "VCard loaded ["+jid+"]:" );
		#if flash
		var d = new VCardDisplay( data );
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
