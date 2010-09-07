
import jabber.SocketConnection;

/**
	Connect to a XMPP server from javascript using a flash socketbridge.
*/
class Test {
	
	static function main() {
		
		haxe.Firebug.redirectTraces();
		
		var swf = "../../hxmpp/util/socketbridge/socketbridge_tls.swf";
		//var swf = "../../hxmpp/util/socketbridge/socketbridge.swf";
		untyped swfobject.embedSWF( swf, "socketbridge", "600", "320", "9" );
		
		SocketConnection.init( "socketbridge", function() {
			var cnx = new SocketConnection( "127.0.0.1", 5222, true );
			var stream = new jabber.client.Stream( cnx );
			stream.onOpen = function(){
				trace( "XMPP stream opened" );
				var auth = new jabber.client.SASLAuth( stream, [cast new jabber.sasl.PlainMechanism()] );
				auth.onSuccess = function() {
					trace( "Authenticated as: "+stream.jid.toString(), "info" );
					stream.sendPresence();
				}
				auth.authenticate( "test", "HXMPP" );
			}
			stream.open( new jabber.JID( "romeo@disktree" ) );
		});
	}
}
