
class Api extends ClientBase {
	
	override function onLogin() {
		var ctx = new haxe.remoting.Context();
		ctx.addObject( "inst", this );
		var host = new jabber.remoting.Host( stream, ctx );
		stream.sendPresence();
	}
	
	public function foo( x : Int, y : Int ) : Int {
		return x+y;
	}
	
	static function main() {
		new Api().login( "julia@disktree" );
	}
	
}
