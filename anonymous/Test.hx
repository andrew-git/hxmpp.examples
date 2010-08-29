
import jabber.client.SASLAuth;
import jabber.sasl.AnonymousMechanism;

class Test {
	
	static function main() {
		var cnx = new jabber.SocketConnection( "127.0.0.1" );
		var stream = new jabber.client.Stream( cnx );
		stream.onClose = function(?e) {
			if( e == null ) trace( "XMPP stream closed." );
			else trace( "An XMPP stream error occured: "+e );
		}
		stream.onOpen = function() {
			var auth = new SASLAuth( stream, [cast new AnonymousMechanism()] );
			auth.onSuccess = function() {
				stream.sendPresence();
				trace( "Logged in as "+stream.jid.toString() );
			}
			auth.authenticate( null, null);
		}
		stream.open( new jabber.JID( "null@disktree.ath.cx" ) ); // any JID
	}
	
}