
import jabber.client.SASLAuth;
import jabber.sasl.AnonymousMechanism;

/**
	Anonymous login.
*/
class Test {
	
	static function main() {
		var cnx = new jabber.SocketConnection( "127.0.0.1" );
		var stream = new jabber.client.Stream( cnx );
		stream.onClose = function(?e) {
			if( e == null ) trace( "XMPP stream closed." );
			else trace( "An XMPP stream error occured: "+e );
		}
		stream.onOpen = function() {
			var anonymouseLoginAllowed = false;
			var serverMechs = stream.server.features.get( "mechanisms" );
			for( m in serverMechs ) {
				if( m.firstChild().nodeValue == AnonymousMechanism.NAME  ) {
					anonymouseLoginAllowed = true;
					break;
				}
			}
			if( !anonymouseLoginAllowed ) {
				trace( "Server does not support anonymous login" );
				return;
			}
			var auth = new SASLAuth( stream, [cast new AnonymousMechanism()] );
			auth.onSuccess = function() {
				stream.sendPresence();
				trace( "Logged in as "+stream.jid.toString() );
			}
			auth.authenticate( null, null);
		}
		var jid = new jabber.JID( null );
		jid.domain = "disktree";
		stream.open( jid );
	}
	
}
