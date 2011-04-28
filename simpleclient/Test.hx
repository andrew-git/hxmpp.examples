
class Test {

	static function main() {
		var jid = new jabber.JID( 'romeo@jabber.org' );
		var cnx = new jabber.SocketConnection( jid.domain );
		var stream = new jabber.client.Stream( cnx );
		stream.onOpen = function(){
			trace( "XMPP stream opened, proceed with authentication ...." );
		}
		stream.onClose = function(?e){
			trace( "XMPP stream closed ["+e+"]" );
		}
		stream.open( jid );
	}
	
}
