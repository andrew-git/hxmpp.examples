
class Test {
	
	static function main() {
		var cnx = new jabber.WebSocketConnection( "192.168.0.110", 5722, false );
		var stream = new jabber.client.Stream( cnx );
		stream.onOpen = function(){
			trace("XMPP stream opened");
			var auth = new jabber.client.Authentication( stream, [cast new jabber.sasl.PlainMechanism()] );
			auth.authenticate( "test", "HXMPP" );
		}
		stream.onClose = function(?e){
			trace( "XMPP stream closed", "info" );
			if( e != null ) trace( e, "warn" );
		};
		stream.open( new jabber.JID( "tong@disktree" ) );
	}
	
}
