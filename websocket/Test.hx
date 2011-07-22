
class Test {
	
	static function main() {
		var cnx = new jabber.WebSocketConnection( "localhost", 5228, false );
		var stream = new jabber.client.Stream( cnx );
		stream.onOpen = function(){
			trace("XMPP stream opened");
			var auth = new jabber.client.Authentication( stream, [cast new jabber.sasl.PlainMechanism()] );
			auth.authenticate( "test", "HXMPP" );
		}
		stream.onClose = function(?e){
			trace( "XMPP stream closed", "info" );
			if( e != null ) trace( e, "error" );
		};
		stream.open( new jabber.JID( "tong@disktree" ) );
	}
	
}
