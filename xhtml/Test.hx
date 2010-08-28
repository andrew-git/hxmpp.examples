
/**
	Sends a XHTML HTTP link to a buddy.
*/
class Test extends ClientBase {
	
	override function onLogin() {
		super.onLogin();
		stream.sendPresence();
		var m = new xmpp.Message( "julia@disktree", "LINK" );
		stream.sendPacket( xmpp.XHTML.attach( m, '<a href="http://disktree.net">DISKTREE.NET</a>' ) );
	}
	
	static function main() {
		var app = new Test();
		app.login( "romeo@disktree", "test", "127.0.0.1" );
	}
	
}
