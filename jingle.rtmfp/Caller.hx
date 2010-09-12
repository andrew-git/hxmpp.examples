
import flash.events.MouseEvent;
import flash.events.StatusEvent;
import flash.media.Camera;
import flash.media.Microphone;
import flash.media.SoundCodec;
import flash.media.Video;
import jabber.jingle.RTMFPCall;
import Client;


class Caller extends Client {
	
	static var CALLEE = "julia@disktree";
	
	var mic : Microphone;
	var cam : Camera;
	var jingle : RTMFPCall;
	var btn_call : Button;
	
	override function onLogin() {
		
		super.onLogin();
		
		var micVolume = 60;
		mic = Microphone.getMicrophone();
		if( mic == null ) {
			trace("TODO no mic found");
			return;
		}
		mic.codec = SoundCodec.SPEEX;
		mic.setSilenceLevel( 0 );
		mic.framesPerPacket = 1;
		mic.gain = micVolume;
		
		cam = Camera.getCamera();
		if( cam == null ) {
			trace("TODO no cam found");
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
	
	function mouseDownCall( e : MouseEvent ) {
		btn_call.visible = false;
		info.text = "CALLING JULIA .. STAND BY";
		jingle = new RTMFPCall( stream, Client.STRATUS_KEY );
		jingle.onConnect = onJingleConnect;
		jingle.onInit = onJingleInit;
		jingle.onEnd = onJingleEnd;
		jingle.onFail = onJingleFail;
		jingle.init( "julia@disktree/HXMPP" );
	}
	
	function onJingleConnect() {
		trace( "JINGLE CONNECTED" );
	}
	
	function onJingleInit() {
		trace( "JINGLE INIT" );
		jingle.ns.attachCamera( cam );
		jingle.ns.attachAudio( mic );
		btn_hangup.visible = true;
		info.text = "TALKING TO JULIA";
	}
	
	function onJingleEnd( r : xmpp.jingle.Reason ) {
		trace( "JINGLE END "+r );
		info.text = "CALL ENDED: "+r ;
		//jingle.hangup();
		btn_call.visible = true;
	}
	
	function onJingleFail( info : String ) {
		trace( "JINGLE FAILED" );
	}
	
	override function hangup() {
		info.text = "ENDED SESSION";
		btn_hangup.visible = false;
		jingle.terminate();
	}
	
	function onCamStatus( e : StatusEvent ) {
		//trace(e);
	}
	
	static function main() {
		haxe.Firebug.redirectTraces();
		flash.Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		flash.Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		var app = new Caller();
		app.login( "romeo@disktree/HXMPP", "test", "192.168.0.110" );
	}
}
