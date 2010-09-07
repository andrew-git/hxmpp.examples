
class TestRomeo extends TestClient {
	
	function new() {
		super( "julia@disktree/HXMPP" );
	}
	
	static function main() {
		new TestRomeo().login("romeo@disktree/HXMPP");
	}
}