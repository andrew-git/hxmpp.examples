
class TestJulia extends Test {
	
	static function main() {
		var app = new TestJulia();
		app.entity = "romeo@disktree/HXMPP";
		app.login( "julia@disktree/HXMPP", "test", "127.0.0.1" );
	}
	
}
