
import neko.FileSystem;
import neko.Lib;

class Build {
	
	public static function main() {
		
		//println( "\n  HXMPP "+HXMPP.VERSION+"\n", "info" );
		println( "\n  HXMPP 0.4.8\n", "info" );

		var builds = new Array<String>();
		for( p in FileSystem.readDirectory( "." ) ) {
			if( !StringTools.startsWith( p, "_" ) && FileSystem.kind( p ) == neko.FileKind.kdir && FileSystem.exists( p+"/build.hxml" ) ) {
				builds.push( p );
			}
		}
		builds.sort( function(a,b){
			return if( a > b ) 1 else if( a < b ) -1 else 0;
		});
		
		println( "    Building "+builds.length+" tests ...\n" );

		var failedBuilds = new Array<String>();
		var numBuilded = 0;
		var i = 0;
		for( p in builds ) {
			neko.Sys.setCwd( p );
			print( "    "+i+" : "+p );
			var hx = new neko.io.Process( "haxe", ["build.hxml"] );
			hx.exitCode();
			var err = hx.stderr.readAll().toString();
			if( err == null || err == "" ) {
				numBuilded++;
				println( " : OK", "ok" );
			} else {
				var info = err;//.substr(5);
				while( StringTools.startsWith( info, "../" ) )
					info = info.substr(3);
				println( " : FAILED ", "error" );
				print( info, "error" );
				failedBuilds.push( p );
			}
			neko.Sys.setCwd( "../" );
			i++;
		}
		println( "\n----------------------------------------------------------------------------------------\n" );
		print( numBuilded+" OK", "ok" );
		print( " | " );
		println( failedBuilds.length+" FAILED" ); 
		if( failedBuilds.length > 0 ) {
			println( ' ( '+failedBuilds.join(", ")+' )\n', "error" );
		}
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
