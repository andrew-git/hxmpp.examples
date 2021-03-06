
import jabber.client.Authentication;
import jabber.sasl.AnonymousMechanism;

/**
	Anonymous login.
*/
class Test {
	
	static function main() {
		var cnx = new jabber.SocketConnection( "localhost" );
		var stream = new jabber.client.Stream( cnx );
		stream.onClose = function(?e) {
			if( e == null ) trace( "XMPP stream closed." );
			else trace( "XMPP stream error: "+e );
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
			var auth = new Authentication( stream, [cast new AnonymousMechanism()] );
			auth.onSuccess = function() {
				stream.sendPresence();
				trace( "Logged in as "+stream.jid.toString() );
			}
			auth.start( null, null);
		}
		var jid = new jabber.JID( null );
		jid.domain = "disktree";
		stream.open( jid );
	}
	
}
