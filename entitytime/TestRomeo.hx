
class TestRomeo extends Test {
	
	static function main() {
		
		var t = '<?xml version="1.0" encoding="UTF-8"?><stream:stream xmlns="jabber:client" xmlns:stream="http://etherx.jabber.org/streams" to="disktree" xmlns:xml="http://www.w3.org/XML/1998/namespace" version="1.0">';
		
		var s = haxe.Timer.stamp();
		for( i in 0...100000 ) {
			//StringTools.startsWith( t, '</stream:stream' );
			//~/(<\/stream:stream)/.match( t );
			startsWith( t, '</stream:stream' );
		}
		trace( haxe.Timer.stamp()-s );
		return;
		
		var app = new TestRomeo();
		app.entity = "julia@disktree/HXMPP";
		app.login( "romeo@disktree/HXMPP" );
	}
	
	static function startsWith( s : String, start : String ) {
		
		
		return( s.length >= start.length && s.substr(0,start.length) == start );
		
		/*
		if( s.length < start.length )
			return false;
		
		for( i in 0...start.length ) {
			if( StringTools.fastCodeAt( start, i ) !=
				StringTools.fastCodeAt( s, i ) ) {
				return false;
			}
		}
		
		return true;
		*/
	}
	
}
