
@:keep class Test {
	
	static var stream : jabber.client.Stream;
	
	static function main() {
		var cnx = new jabber.BOSHConnection( "disktree", "127.0.0.1/jabber" );
		stream = new jabber.client.Stream( cnx );
		stream.onOpen = function(){
			trace("XMPP stream opened");
			var auth = new jabber.client.Authentication( stream, [cast new jabber.sasl.PlainMechanism()] );
			auth.onSuccess = function(){
				stream.sendPresence();
			}
			auth.authenticate( "test", "HXMPP" );
		}
		stream.onClose = function(?e){trace(e);};
		try {
			stream.open( new jabber.JID( "romeo@disktree" ) );
		} catch(e : Dynamic ) {
			trace(e);
		}
	}
}
