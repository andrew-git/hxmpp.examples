
class Test {
	
	static var stream : jabber.client.Stream;
	
	static function main() {
		var cnx = new jabber.BOSHConnection( "disktree", "192.168.0.110/jabber" );
		stream = new jabber.client.Stream( cnx );
		stream.onOpen = function(){
			trace("XMPP stream opened");
			var auth = new jabber.client.SASLAuth( stream, [cast new jabber.sasl.PlainMechanism()] );
			auth.authenticate( "mypass", "HXMPP" );
		}
		stream.onClose = function(?e){ trace(e);};
		stream.open( new jabber.JID( "hxmpp@disktree" ) );
	}
}
