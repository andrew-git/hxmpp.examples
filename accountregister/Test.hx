
/**
	Register an new xmpp client account.
*/
class Test {

	static function main() {
		
		var node = 'testaccount';
		var pass = 'mypassword';
		var email = 'node@example.com';
		var name = 'Captain Kirk';
		
		var cnx = new jabber.SocketConnection( 'localhost' );
		var stream = new jabber.client.Stream( cnx );
		stream.onOpen = function() {
			var acc = new jabber.client.Account( stream );
			acc.onRegister = function( node : String ) {
				trace( 'Account successfully registerd ['+node+']' );
				stream.close( true );
			}
			acc.onError = function( e ) {
				trace( e.toString() );
				stream.close( true );
			}
			acc.register( new xmpp.Register( node, pass, email, name ) );
		}
		stream.onClose = function(?e) {
			if( e != null ) {
				trace( "XMPP stream error: "+e );
			}
		}
		stream.open( null );
	}
	
}
