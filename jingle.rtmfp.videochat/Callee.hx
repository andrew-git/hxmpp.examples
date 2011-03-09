
import flash.events.MouseEvent;
import flash.events.NetStatusEvent;
import flash.net.NetStream;
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
		new RTMFPListener( stream, onJingleRequest );
		stream.sendPresence();
	}

	override function onPresence( p : xmpp.Presence ) {
		var from = jabber.JIDUtil.parseBare( p.from );
		if( from == CALLER ) {
			if( p.type == null )
				info.text = "WAITING FOR ROMEO TO CALL";
			//...
		}
	}
	
	function onJingleRequest( r : RTMFPResponder ) {
		
		trace( "Jingle request: "+r.entity, "info" );
		
		responder = r;
		//responder.cirrus_key = 
		responder.onInit = onJingleInit;
		responder.onFail = onJingleFail;
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
		video.visible = true;
		responder.accept( true );
	}
	
	function mouseDownDenyCall( e : MouseEvent ) {
		btn_accept.visible = btn_deny.visible = false;
		info.text = "YOU DENIED THE CALL";
		responder.accept( false );
	}
	
	function onJingleInit() {
		
		trace("Jingle init","info");
		
		var peer : Dynamic = {};
		peer.onPeerConnect = function( ns : flash.net.NetStream ) : Bool {
			trace( "Peer connected [farID: "+ns.farID+"]", "info" );
			return true;
		}
		peer.onImageData = function( data : Dynamic ) {
			trace( "onImageData "+data );
		}
		var ns = new NetStream( responder.transport.nc, responder.transport.id );
		ns.client = peer;
		ns.addEventListener( NetStatusEvent.NET_STATUS, function(e){trace("########### "+e.info.code);} );
		video.attachNetStream( ns );
		ns.play(responder.transport.pubid);
		
		btn_hangup.visible = true;
		info.text = "ROMEO IS TALKING";
	}
	
	function onJingleFail( e : String ) {
		trace(e,"warn");
		info.text = "JINGLE FAILED: "+e;
	}
	
	function onJingleEnd( r : xmpp.jingle.Reason ) {
		trace("Jingle end: "+r );
		info.text = "CALL ENDED: "+r ;
		btn_hangup.visible = false;
	}
	
	override function hangup() {
		responder.terminate();
		info.text = "YOU ENDED THE SESSION";
		btn_hangup.visible = false;
		btn_deny.visible = false;
		video.visible = false;
	}
	
	static function main() {
		haxe.Firebug.redirectTraces();
		new Callee().login( "julia@disktree/HXMPP", "test", "192.168.0.110" );
	}
	
}
