
class Test {
	
	static function main() {
		
		#if flash
		flash.Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		flash.Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		#end
		
		var jid = "romeo@disktree";
		var password = "test";

		var t = haxe.Timer.stamp();

		var cnx = new jabber.BOSHConnection( "disktree", "localhost/httpbind" );
		var stream = new jabber.client.Stream( cnx );
		stream.onOpen = function(){
			trace("XMPP stream opened");
			var auth = new jabber.client.Authentication( stream, [cast new jabber.sasl.PlainMechanism()] );
			auth.onSuccess = function(){
				trace( "Authenticated as: "+stream.jid.s );
				stream.sendPresence();
				trace( "TIME::::::::: "+(haxe.Timer.stamp()-t) );
			}
			auth.onFail = function(e){
				trace( "Authentication failed! ("+stream.jid.s+")("+password+")" );
			}
			auth.start( password, "HXMPP" );
		}
		stream.onClose = function(?e){
			trace("XMPP stream closed");
			if( e != null ) trace(e,"error");
		};
		trace(">>>");
		try {
			stream.open( new jabber.JID( jid ) );
		} catch(e : Dynamic ) {
			trace(e,"error");
		}
	}
	
}
