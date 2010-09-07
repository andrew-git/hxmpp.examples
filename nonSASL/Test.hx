
/**
	Example usage of non-sasl client authentication with a xmpp server.
	This should NOT get used since its not secure.
*/
class Test {
	
	static function main() {
		var cnx = new jabber.SocketConnection( "127.0.0.1", 5222 );
		var s = new jabber.client.Stream( cnx );
		s.onOpen = function() {
			trace("XMPP stream opened");
			var auth = new jabber.client.NonSASLAuth( s );
			auth.onSuccess = function() {
				trace( "Authenticated as "+s.jid.toString() );
			}
			auth.onFail = function(?e) {
				trace( "Failed to authenticate as "+s.jid.toString() );
			}
			auth.authenticate( "test", "HXMPP" );
		}
		s.onClose = function(?e) {
			trace("XMPP stream  closed "+e );
		}
		s.open( new jabber.JID( "romeo@disktree" ) );
	}
}
