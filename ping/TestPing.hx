
class TestPing extends ClientBase {
	
	override function onLogin() {
		stream.sendPresence();
		var ping = new jabber.Ping( stream, "julia@disktree/HXMPP" );
		ping.onPong = onPong;
		ping.onTimeout = onTimeout;
		ping.run( 1000 );
	}
	
	function onPong( jid : String ) {
		if( jid == null ) jid = "XMPP server";
		trace( "Pong from "+jid );
	}
	
	function onTimeout( jid : String ) {
		trace( "Pong timeout: "+jid );
	}
	
	static function main() {
		new TestPing().login( "romeo@disktree" );
	}
	
}
