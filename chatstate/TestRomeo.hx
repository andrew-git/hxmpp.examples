
class TestRomeo extends TestClient {
	
	function new() {
		super( "julia@disktree/HXMPP" );
	}
	
	static function main() {
		var app = new TestRomeo();
		app.login( "romeo@disktree/HXMPP", "test", "127.0.0.1" );
	}
}