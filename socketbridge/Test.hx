
import jabber.SocketConnection;

/**
	Example usage of a flash socketbridge to connect to a XMPP server from HXMPP/JS
*/
class Test {
	
	static function main() {
		
		var swf = "socketbridge.swf";
		//var swf = "socketbridge_tls.swf";
		untyped swfobject.embedSWF( swf, "socketbridge", "400", "200", "10" );
		
		SocketBridgeConnection.initDelayed( "socketbridge", function(){
			var cnx = new SocketConnection( "localhost", 5222 );
			var stream = new jabber.client.Stream( cnx );
			stream.onOpen = function(){
				trace( "XMPP stream opened" );
			}
			stream.open( new jabber.JID( "node@example.com" ) );
		});
	}
}
