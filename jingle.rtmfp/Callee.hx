
import flash.events.MouseEvent;
import jabber.jingle.RTMFPListener;
import jabber.jingle.RTMFPResponder;
import Client;


class Callee extends Client {
	
	static var CALLER = "romeo@disktree";
	
	var responder : RTMFPResponder;
	
	var btn_accept : Button;
	var btn_deny : Button;
	
	override function onLogin() {
		
		super.onLogin();
		
		new jabber.MessageListener( stream, function(m){} );
		new RTMFPListener( stream, onJingleRequest, Client.STRATUS_KEY );
		
		stream.sendPresence();
		
		info.text = "WAITING FOR ROMEO TO CALL";
	}

	override function onPresence( p : xmpp.Presence ) {
		var from = jabber.JIDUtil.parseBare( p.from );
		if( from == CALLER ) {
			//TODO...
		}
	}
	
	function onJingleRequest( r : RTMFPResponder ) {
		trace( "JINGLE REQUEST" );
		
		responder = r;
		responder.onInit = onJingleInit;
		responder.onEnd = onJingleEnd;
		
		info.text = "INCOMING CALL FROM "+r.entity;
		
		btn_accept = new Button( "ACCEPT" );
		btn_accept.addEventListener( MouseEvent.MOUSE_DOWN, mouseDownAcceptCall );
		menu.addChild( btn_accept );
		btn_deny = new Button( "DENY" );
		btn_deny.x = btn_accept.x + btn_accept.width+1;
		btn_deny.addEventListener( MouseEvent.MOUSE_DOWN, mouseDownDenyCall );
		menu.addChild( btn_deny );
	}
	
	function mouseDownAcceptCall( e : MouseEvent ) {
		btn_accept.visible = btn_deny.visible = false;
		responder.accept( true );
	}
	
	function mouseDownDenyCall( e : MouseEvent ) {
		btn_accept.visible = btn_deny.visible = false;
		info.text = "YOU DENIED THE CALL";
		responder.accept( false );
	}
	
	function onJingleInit() {
		video.attachNetStream( responder.ns );
		btn_hangup.visible = true;
		info.text = "ROMEO IS TALKING";
	}
	
	function onJingleEnd( r : xmpp.jingle.Reason ) {
		info.text = "CALL ENDED: "+r ;
		btn_hangup.visible = false;
	}
	
	override function hangup() {
		responder.terminate();
		info.text = "YOU ENDED THE SESSION";
		btn_hangup.visible = false;
		btn_deny.visible = false;
	}
	
	static function main() {
		haxe.Firebug.redirectTraces();
		flash.Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		flash.Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		var app = new Callee();
		app.login( "julia@disktree/HXMPP", "test", "192.168.0.110" );
	}
	
}
