
/**
	Legacy TLS on port 5223
*/
class Test {
	
	static function main() {
		var ip = "127.0.0.1";
		//var ip = "192.168.0.110";
		var cnx = new jabber.SecureSocketConnection( ip, 5223 );
		var stream = new jabber.client.Stream( cnx );
		stream.onOpen = function() {
			trace("XMPP stream opened");
			var auth = new jabber.client.SASLAuth( stream, [cast new jabber.sasl.PlainMechanism()] );
			auth.onSuccess = function() {
				stream.sendPresence();
			}
			auth.authenticate( "test", "HXMPP" );
		}
		stream.onClose = function(?e) {
			trace("XMPP stream closed");
			trace(e);
		}
		stream.open( new jabber.JID( "hxmpp@disktree" ) );
	}
	
}
