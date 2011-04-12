
class TestPong extends ClientBase {
	
	override function onLogin() {
		stream.sendPresence();
		var pong = new jabber.Pong( stream );
		pong.onPong = function(jid:String) { trace("Sent pong to: "+jid); }
	}
	
	static function main() {
		new TestPong().login( "julia@disktree" );
	}
	
}
