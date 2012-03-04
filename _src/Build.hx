
import neko.Lib;
import neko.FileSystem;
import neko.Sys;
import neko.io.File;

/**
	Builds all examples.
*/
class Build {
	
	public static function main() {
		
		//var color = Sys.args()[0] == "color";
		
		println( "\n  HXMPP\n", "info" );

		var builds = new Array<String>();
		for( p in FileSystem.readDirectory( "." ) ) {
			if( !StringTools.startsWith( p, "_" ) && FileSystem.kind( p ) == neko.FileKind.kdir && FileSystem.exists( p+"/build.hxml" ) ) {
				builds.push( p );
			}
		}
		builds.sort( function(a,b) return if( a > b ) 1 else if( a < b ) -1 else 0 );
		
		println( "    Building "+builds.length+" tests ...\n" );

		var failedBuilds = new Array<String>();
		var numBuilded = 0;
		var i = 0;
		for( p in builds ) {
			var hxmlpath = p+"/build.hxml";
			if( !FileSystem.exists( hxmlpath ) )
				continue;
			var n = (i+1);
			var spaces = "";
			for( i in 0...(10-Std.string(n).length) ) spaces += " ";
			print( spaces+n+" : "+p );
			Sys.setCwd( p );
			var hx = new neko.io.Process( "haxe", ["build.hxml"] );
			hx.exitCode();
			var err = hx.stderr.readAll().toString();
			if( err == null || err == "" ) {
				numBuilded++;
				println( " : ok", "ok" );
			} else {
				var info = err;//.substr(5);
				while( StringTools.startsWith( info, "../" ) )
					info = info.substr(3);
				println( " : FAILED ", "error" );
				print( info, "error" );
				failedBuilds.push( p );
			}
			Sys.setCwd( "../" );
			i++;
		}
		println( "" );
		print( numBuilded+" OK", "ok" );
		print( " | " );
		println( failedBuilds.length+" FAILED" ); 
		if( failedBuilds.length > 0 ) {
			println( ' ( '+failedBuilds.join(", ")+' )\n', "error" );
		}
		println("");
	}
	
	static function print( t : Dynamic, ?level : String ) {
		/* 
		if( level == null ) Lib.print( t );
		else {
			var c = switch( level ) {
				case "info" : 36;
				case "ok" : 32;
				case "error" : 31;
			};
			Lib.print( '\033['+c+'m'+t+'\033[m' );
		}
		*/
		Lib.print( t );
	}
	
	static inline function println( t : Dynamic, ?level : String ) {
		print( t+"\n", level );
	}
	
}
