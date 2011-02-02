
import haxe.io.Bytes;
#if neko
import neko.io.File;
#elseif cpp
import cpp.io.File;
#elseif php
import php.io.File;
#elseif nodejs
import js.io.File;
#end
import jabber.data.SIListener;
import jabber.data.IBReciever;
import jabber.data.DataReciever;
#if (neko||cpp||nodejs||flash)
import jabber.data.ByteStreamReciever;
#end

class Reciever extends ClientBase {
	
	var fr : DataReciever;
	var data : haxe.io.BytesBuffer; // recieved data
	var bytesRecieved : Int;
	
	override function onLogin() {
		
		new jabber.ServiceDiscoveryListener( stream );
		new jabber.MessageListener( stream, function(m:xmpp.Message){} );
		new jabber.PresenceListener( stream, onPresence );
		
		var ft_listener = new SIListener( stream, onDataTransferRequest );
		ft_listener.onFail = onDataTransferNegotiationFail;
		
		#if (neko||cpp||nodejs||flash)
		ft_listener.methods.push( new ByteStreamReciever(stream) );
		#end
		ft_listener.methods.push( new IBReciever(stream) );
		
		stream.sendPresence();
	}
	
	function onPresence( p : xmpp.Presence ) {
	}

	function onDataTransferNegotiationFail( info : String ) {
		trace( "Data transfer negotiation failed: "+info );
	}

	function onDataTransferRequest( fr : DataReciever ) {
		trace( "Data transfer request: "+fr.initiator+"\n"+
			   "\tFilename: "+fr.file.name+"\n"+
			   "\tSize: "+fr.file.size+" bytes\n"+
			   "\tHash: "+fr.file.hash+"\n"+
			   "\tDescription: "+fr.file.desc+"\n"+
			   "\tRange: "+(fr.file.range!=null) );
		data = new haxe.io.BytesBuffer();
		bytesRecieved = 0;
		this.fr = fr;
		//fr.onInit = onDataTransferInit;
		fr.onProgress = onDataTransferProgress;
		fr.onComplete = onDataTransferComplete;
		fr.onFail = onDataTransferFail;
		//fr.accept( true, { offset : 4, length : 9 } );
		//fr.accept( true, { offset : 4, length : null } );
		fr.accept( true );
	}
	
	function onDataTransferInit() {
		trace( "Data transfer started ..", "info" );
	}
	
	function onDataTransferProgress( bytes : Bytes ) {
		this.data.add( bytes );
		bytesRecieved += bytes.length;
//		trace( "Filetransfer progress: "+Std.int(bytesRecieved/1024)+"kb "+Std.int(bytesRecieved/fr.file.size*100)+"%" );
	}
	
	function onDataTransferComplete() {
		
		var bytes = this.data.getBytes();
		trace( "File transfer complete ["+bytes.length+"]" );
		if( fr.file.hash != null ) {
			if( fr.file.hash != jabber.util.MD5.encode( bytes.toString() ) ) {
				trace( "Hash does not match", "warn" );
				return;
			}
		}
		
		
		#if (neko||cpp||php)
		var fo = File.write( "__"+fr.file.name, true );
		fo.write( bytes );
		fo.flush();
		fo.close();
		trace( "File saved." );
		
		#elseif nodejs
		var d = bytes.getData();
		js.Node.fs.writeFile( "__"+fr.file.name, d, js.Node.BINARY, function(e){
			if( e == null ) trace( "File saved." );
		});
		
		#elseif flash
		if( fr.range != null ) return;
		var ext = fr.file.name.substr( fr.file.name.length-3 );
		if( ext == "png" || ext == "jpg" || ext == "gif" ) {
			var l = new flash.display.Loader();
			l.loadBytes( bytes.getData() );
//			flash.Lib.current.addChild( l );
		}
		
		#elseif js
		if( fr.range != null ) return;
		var ext = fr.file.name.substr( fr.file.name.length-3 );
		if( ext == "png" || ext == "jpg" || ext == "gif" ) {
			var s = "data:image/"+ext+";base64,"+jabber.util.Base64.removeNullbits( jabber.util.Base64.encodeBytes( bytes ) );
			var img = js.Lib.document.createElement( "img" );
			img.setAttribute( "src", s );
			js.Lib.document.getElementById( "output" ).appendChild( img );
		}
		
		#end
	}
	
	function onDataTransferFail( info : String ) {
		trace( "File transfer failed: "+info );
	}
	
	static function main() {
		#if (flash||js) #if (!air&&!nodejs) haxe.Firebug.redirectTraces(); #end #end
		#if flash
		flash.Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		flash.Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		#end
		var app = new Reciever();
		app.login( "julia@disktree" );
	}
}
