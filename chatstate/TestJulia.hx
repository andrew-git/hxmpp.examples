
class TestJulia extends TestClient {
	
	function new() {
		super( "romeo@disktree/HXMPP" );
	}
	
	static function main() {
		var app = new TestJulia();
		app.login( "julia@disktree/HXMPP", "test", "127.0.0.1" );
	}
}
