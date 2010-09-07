
class TestJulia extends TestClient {
	
	function new() {
		super( "romeo@disktree/HXMPP" );
	}
	
	static function main() {
		new TestJulia( ).login( "julia@disktree/HXMPP" );
	}
}
