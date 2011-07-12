
/**
	Legacy TLS on port 5223
*/
class Test {
	
	static function main() {
		
		var ip = "127.0.0.1";
		var jid = "romeo@disktree";

		trace( "Connecting ["+ip+","+jid+"] ..." );
		
		var cnx = new jabber.SecureSocketConnection( ip );
		//var cnx = new jabber.SocketConnection( ip );
		var stream = new jabber.client.Stream( cnx );
		stream.onOpen = function() {
			trace( "XMPP stream opened", "info" );
			var auth = new jabber.client.Authentication( stream, [cast new jabber.sasl.PlainMechanism()] );
			auth.onSuccess = function() {
				trace( "Authenticated as: "+stream.jid.toString(), "info" );
				stream.sendPresence();
			}
			auth.authenticate( "test", "HXMPP" );
		}
		stream.onClose = function(?e) {
			trace( "XMPP stream closed" );
			if( e != null ) trace( e, "warn" );
		}
		stream.open( new jabber.JID( jid ) );
	}
	
}
