
import jabber.data.SITransfer;
import jabber.data.IBTransfer;
#if (neko||cpp||nodejs||air)
import jabber.data.ByteStreamTransfer;
import xmpp.file.ByteStreamHost;
#end
#if neko
import neko.io.File;
#elseif cpp
import cpp.io.File;
#elseif php
import php.io.File;
#elseif nodejs
import js.io.File;
#end

class Sender extends ClientBase {
	
	static var FILEPATH = "file.txt";
	static var RECIEVER = "julia@disktree";
	static var initialized = false;
	
	var ft : SITransfer;
	
	override function onLogin() {
		new jabber.MessageListener( stream, function(m:xmpp.Message){} );
		new jabber.PresenceListener( stream, onPresence );
		stream.sendPresence();
	}
	
	function onPresence( p : xmpp.Presence ) {
		var from = jabber.JIDUtil.parseBare( p.from );
		if( !initialized && from == RECIEVER && p.type == null ) {
			
			ft = new SITransfer( stream, p.from );
			
			#if (neko||cpp||nodejs||air)
			var bs = new ByteStreamTransfer( stream, p.from );
			// TODO bs.addHost( stream.jid.toString(), "192.168.0.110", 7654  );
			bs.hosts.push( new ByteStreamHost( stream.jid.toString(), "192.168.0.110", 7654 ) );
			ft.methods.push( bs );
			#end
			
			ft.methods.push( new IBTransfer( stream, p.from ) );
			
			ft.onInit = onFileTransferInit;
			ft.onProgress = onFileTransferProgress;
			ft.onComplete = onFileTransferComplete;
			ft.onFail = onFileTransferFail;
			
			try {
				#if (neko||cpp||php||nodejs||air)
				//var hash = jabber.util.MD5.encode( File.getBytes( FILEPATH ).toString() );
				var hash = null;
				ft.sendFile( FILEPATH, "A test filetransfer", hash, true );
				
				#elseif (flash||js)
				ft.sendData( haxe.Resource.getBytes( "file" ), "file.png" );
				
				#end
				
			} catch( e : Dynamic ) {
				trace( e );
				return;
			}
			initialized = true;
		}
	}
	
	function onFileTransferInit() {
		trace( "Filetransfer started..." );
	}
	
	function onFileTransferFail( error : String, ?info : String ) {
		var m = error;
		if( info != null ) m += " ["+info+"]";
		trace( "Filetransfer failed: "+m );
	}
	
	function onFileTransferProgress( bytes : Int ) {
//		trace( "Filetransfer progress: "+Std.int(bytes/1024)+"kb "+Std.int(bytes/ft.file.size*100)+"%" );
	}
	
	function onFileTransferComplete() {
		trace( "File transfer complete ["+ft.file.size+"]" );
	}
	
	static function main() {
		#if (flash||js) #if (!air&&!nodejs) haxe.Firebug.redirectTraces(); #end #end
		#if flash
		flash.Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		flash.Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		#end
		var app = new Sender();
		app.login( "romeo@disktree" );
	}
	
}
