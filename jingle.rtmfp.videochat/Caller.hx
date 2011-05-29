
import flash.events.MouseEvent;
import flash.events.NetStatusEvent;
import flash.events.StatusEvent;
import flash.media.Camera;
import flash.media.Microphone;
import flash.media.SoundCodec;
import flash.media.Video;
import flash.net.NetStream;
import jabber.jingle.RTMFPCall;
import jabber.jingle.io.RTMFPOutput;
import Client;

class Caller extends Client {
	
	static var CALLEE = "julia@disktree";
	
	var mic : Microphone;
	var cam : Camera;
	var jingle : RTMFPCall;
	var btn_call : Button;
	var callTimer : haxe.Timer;
	
	var ns : flash.net.NetStream;
	
	override function onLogin() {
		
		super.onLogin();
		
		mic = Microphone.getMicrophone();
		if( mic == null ) {
			trace("no mic found");
			return;
		}
		mic.setUseEchoSuppression( true );
		mic.codec = SoundCodec.SPEEX;
		mic.setSilenceLevel( 0 );
		mic.framesPerPacket = 1;
		mic.gain = 70;
		
		cam = Camera.getCamera();
		if( cam == null ) {
			trace("no cam found");
			return;
		}
		cam.addEventListener( StatusEvent.STATUS, onCamStatus );
		cam.setMode( 160, 120, 15 );
		cam.setQuality( 0, 90 );
		
		video.attachCamera( cam );
		
		btn_call = new Button( "CALL JULIA" );
		btn_call.addEventListener( MouseEvent.MOUSE_DOWN, mouseDownCall );
		btn_call.visible = false;
		menu.addChild( btn_call );
		
		stream.sendPresence();
	}
	
	override function onPresence( p : xmpp.Presence ) {
		if( jingle == null ) {
			var from = jabber.JIDUtil.parseBare( p.from );
			if( from == CALLEE ) {
				if( p.type == null ) {
					btn_call.visible = true;
					info.text = "CLICK THE BUTTON TO CALL JULIA";
				} else {
					//TODO....
					info.text = "JULIA IS GONE";
					btn_call.text = "CALL JULIA";
					btn_call.visible = false;
					btn_hangup.visible = false;
				}
			}
		}
	}
	
	function mouseDownCall( e : MouseEvent ) {
		btn_call.visible = false;
		info.text = "CALLING JULIA .. STAND BY";
	//	RTMFPCall.cirrus_key = Client.CIRRUS_KEY;
		jingle = new RTMFPCall( stream, "julia@disktree/HXMPP" );
		var transport = new RTMFPOutput( Client.CIRRUS_URL+Client.CIRRUS_KEY );
		jingle.transports.push( transport );
		jingle.onInit = onJingleInit;
		jingle.onEnd = onJingleEnd;
		jingle.onFail = onJingleFail;
		try jingle.init() catch( e : Dynamic ) {
			trace(e);
			return;
		}
		callTimer = new haxe.Timer( 10000 );
		callTimer.run = onCallTimer;
	}
	
	function onCallTimer() {
		callTimer.stop();
		jingle.terminate( xmpp.jingle.Reason.timeout );
	}
	
	function onJingleInit() {
	
		callTimer.stop();
		trace( "Jingle init", "info" );
		
		var peer : Dynamic = {};
		peer.onPeerConnect = function( ns : flash.net.NetStream ) : Bool {
			trace( "Peer connected [farID: "+ns.farID+"]", "info" );
			return true;
		}
		peer.onImageData = function( data : Dynamic ) {
			trace( "onImageData" );
			var l = new flash.display.Loader();
			l.loadBytes( data.data );
			flash.Lib.current.addChild( l );
		}
		ns = new NetStream( jingle.transport.nc, NetStream.DIRECT_CONNECTIONS );
		ns.addEventListener( NetStatusEvent.NET_STATUS, function(e){trace("########### "+e.info.code);} );
		ns.client = peer;
		ns.attachCamera( cam );
		ns.attachAudio( mic );
		ns.publish( jingle.pubid );
		
		btn_hangup.visible = true;
		info.text = "TALKING TO JULIA";
	}
	
	function onJingleEnd( r : xmpp.jingle.Reason ) {
		trace( "Jingle end "+r, "info" );
		info.text = "CALL ENDED: "+r ;
		btn_call.visible = true;
	}
	
	function onJingleFail( info : String ) {
		trace( "Jingle failed: "+info, "warn" );
	}
	
	override function hangup() {
		info.text = "ENDING SESSION ..";
		btn_hangup.visible = false;
		jingle.terminate();
	}
	
	function onCamStatus( e : StatusEvent ) {
		//trace(e);
	}
	
	static function main() {
		haxe.Firebug.redirectTraces();
		var app = new Caller();
		app.login( "romeo@disktree/HXMPP", "test", "127.0.0.1" );
	}
}
