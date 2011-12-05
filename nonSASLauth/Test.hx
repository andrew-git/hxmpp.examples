
/**
	Example usage of non-sasl client authentication with a xmpp server.
	This should NOT get used, f* unsecure (Use jabber.client.Authentication instead).
*/
class Test {
	
	static function main() {
		var cnx = new jabber.SocketConnection( "127.0.0.1", 5222 );
		var stream = new jabber.client.Stream( cnx );
		stream.onOpen = function() {
			trace("XMPP stream opened");
			var auth = new jabber.client.NonSASLAuthentication( stream );
			auth.onSuccess = function() {
				trace( "Authenticated as "+stream.jid.toString() );
			}
			auth.onFail = function(?e) {
				trace( "Failed to authenticate as "+stream.jid.toString() );
			}
			auth.start( "test", "HXMPP" );
		}
		stream.onClose = function(?e) {
			trace("XMPP stream  closed "+e );
		}
		stream.open( new jabber.JID( "romeo@disktree" ) );
	}
}
