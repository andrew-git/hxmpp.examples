
/**
	Legacy TLS on port 5223 test.
*/
class App {
	
	static function main() {
		var ip = "127.0.0.1";
		var stream = new jabber.client.Stream( new jabber.SecureSocketConnection( ip, 5223 ) );
		stream.onOpen = function() {
			trace("XMPP stream opened");
		}
		stream.onClose = function(?e) {
			trace("XMPP stream closed");
			trace(e);
		}
		trace( "Trying to connect to "+ip+":5223 ..." );
		stream.open( new jabber.JID( "any@disktree" ) );
	}
	
}
