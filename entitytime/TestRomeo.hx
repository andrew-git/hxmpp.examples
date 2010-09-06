
class TestRomeo extends Test {
	
	static function main() {
		var app = new TestRomeo();
		app.entity = "julia@disktree/HXMPP";
		app.login( "romeo@disktree/HXMPP", "test", "127.0.0.1" );
	}
	
}
