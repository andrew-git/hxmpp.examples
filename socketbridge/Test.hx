
import jabber.SocketConnection;

/**
	Connect to a XMPP server from javascript using a flash socketbridge.
*/
class Test {
	
	static function main() {
		
		if( haxe.Firebug.detect() ) haxe.Firebug.redirectTraces();
		
		var swf = "../../hxmpp/util/socketbridge/socketbridge_tls.swf";
		//var swf = "../../hxmpp/util/socketbridge/socketbridge.swf";
		untyped swfobject.embedSWF( swf, "socketbridge", "600", "320", "10" );
		
		SocketConnection.init( 'socketbridge', function(e:String) {
			
			if( e != null ) {
				trace( e, 'error' );
				return;
			}
			trace( 'socketbridge initialized', 'info' );
			
			var cnx = new SocketConnection( "127.0.0.1", 5222, true );
			var stream = new jabber.client.Stream( cnx );
			stream.onOpen = function(){
				trace( 'XMPP stream opened', 'info' );
				var auth = new jabber.client.SASLAuth( stream, [cast new jabber.sasl.PlainMechanism()] );
				auth.onSuccess = function() {
					trace( 'Authenticated ['+stream.jid.toString()+']', 'info' );
					stream.sendPresence();
				}
				auth.authenticate( "test", "HXMPP" );
			}
			stream.open( new jabber.JID( "romeo@disktree" ) );
		}, 200 );
	}
}
