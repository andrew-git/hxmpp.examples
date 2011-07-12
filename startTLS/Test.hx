
class Test {
	
	static function main() {
		
		#if flash
		flash.Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		flash.Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		haxe.Firebug.redirectTraces();
		#end
		
		var ip = "127.0.0.1";
		var jid = "hxmpp@disktree";
		
		var cnx = new jabber.SocketConnection( ip );
		var stream = new jabber.client.Stream( cnx );
		stream.onOpen = function() {
			trace("XMPP stream opened");
			var auth = new jabber.client.Authentication( stream, [cast new jabber.sasl.PlainMechanism()] );
			auth.onSuccess = function() {
				stream.sendPresence();
				new jabber.client.VCard( stream ).load();
			}
			auth.authenticate( "test", "HXMPP" );
		}
		stream.onClose = function(?e) {
			trace("XMPP stream closed");
			trace(e);
		}
		stream.open( new jabber.JID( jid ) );
	}
	
}
