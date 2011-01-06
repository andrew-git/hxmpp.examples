
import flash.events.MouseEvent;
import jabber.jingle.RTMPListener;
import jabber.jingle.RTMPResponder;
import Client;

class Callee extends Client {
	
	static var CALLER = "romeo@disktree/HXMPP";
	
	var responder : RTMPResponder;
	var btn_accept : Button;
	var btn_deny : Button;
	
	override function onLogin() {
		super.onLogin();
		new RTMPListener( stream, onJingleRequest );
		stream.sendPresence();
		info.text = "WAITING FOR ROMEO TO CALL";
	}
	
	override function onPresence( p : xmpp.Presence ) {
		if( p.from == CALLER &&
			p.type == xmpp.PresenceType.unavailable &&
			responder != null ) {
			video.visible = false;
		}
	}
	
	function onJingleRequest( r : RTMPResponder ) {
		trace( "Jingle request", "info" );
		info.text = "INCOMING CALL FROM "+r.entity;
		responder = r;
		responder.onInit = onJingleInit;
		responder.onEnd = onJingleEnd;
		responder.onFail = onJingleFail;
//		responder.onInfo = onJingleInfo;
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
		responder.accept();
	}
	
	function mouseDownDenyCall( e : MouseEvent ) {
		btn_accept.visible = btn_deny.visible = false;
		info.text = "YOU DENIED THE CALL";
		responder.accept( false );
	}
	
	function onJingleInit() {
		trace( "Jingle init", "info" );
		video.attachNetStream( responder.transport.ns );
		btn_hangup.visible = true;
		info.text = "ROMEO IS TALKING";
	}
	
	override function onJingleEnd( r : xmpp.jingle.Reason ) {
		super.onJingleEnd( r );
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
		if( haxe.Firebug.detect() ) haxe.Firebug.redirectTraces();
		new Callee().login( "julia@disktree/HXMPP" );
	}
	
}
