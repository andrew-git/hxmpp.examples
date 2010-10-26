
import flash.events.MouseEvent;
import flash.media.Camera;
import flash.media.Microphone;
import jabber.jingle.RTMPCall;
import jabber.jingle.transport.RTMPOutput;
import Client;

class Caller extends Client {
	
	static var CALLEE = "julia@disktree/HXMPP";
	
	var mic : Microphone;
	var cam : Camera;
	var jingle : RTMPCall;
	var btn_call : Button;
	
	override function onLogin() {
		
		super.onLogin();
		
		mic = Microphone.getMicrophone();
		if( mic == null ) {
			trace("TODO no mic found");
			return;
		}
		mic.setUseEchoSuppression( true );
		cam = Camera.getCamera();
		if( cam == null ) {
			trace("TODO no cam found");
			return;
		}
		cam.setMode( 320, 240, 10 );
		video.attachCamera( cam );
		
		btn_call = new Button( "CALL JULIA" );
		btn_call.addEventListener( MouseEvent.MOUSE_DOWN, mouseDownCall );
		btn_call.visible = false;
		menu.addChild( btn_call );
		
		stream.sendPresence();
	}
	
	override function onPresence( p : xmpp.Presence ) {
		if( p.from == CALLEE ) {
			if( p.type == null ) {
				btn_call.visible = true;
				info.text = "CLICK THE BUTTON TO CALL JULIA";
			} else {
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
		jingle = new RTMPCall( stream, CALLEE );
		jingle.transports.push( new RTMPOutput("haXevideo","mystream","192.168.0.110") );
		jingle.onConnect = onJingleConnect;
		jingle.onInit = onJingleInit;
		jingle.onInfo = onJingleInfo;
		jingle.onFail = onJingleFail;
		jingle.onEnd = onJingleEnd;
		try jingle.init() catch(e:Dynamic) {
			trace(e,"error");
		}
	}
	
	function onJingleConnect() {
		trace( "Jingle connect", "info" );
	}
	
	function onJingleInit() {
		trace( "Jingle init", "info" );
		jingle.transport.ns.attachCamera( cam );
		jingle.transport.ns.attachAudio( mic );
		btn_hangup.visible = true;
		info.text = "TALKING TO JULIA";
	}
	
	override function onJingleEnd( r : xmpp.jingle.Reason ) {
		super.onJingleEnd( r );
		info.text = "CALL ENDED: "+r ;
		btn_call.visible = true;
	}
	
	override function hangup() {
		info.text = "ENDED SESSION";
		btn_hangup.visible = false;
		jingle.terminate();
	}
	
	static function main() {
		haxe.Firebug.redirectTraces();
		new Caller().login( "romeo@disktree/HXMPP", "test", "192.168.0.110" );
	}
	
}
