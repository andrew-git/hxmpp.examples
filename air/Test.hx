
import jabber.client.Stream;

/**
	Adobe AIR usage.
	Get required typedefinitions from: http://disktree.spektral.at/git/?a=summary&p=hxair
	Mind! AIR does not allow to make secure socket connections to servers with self signed certs.
*/
class Test {
	
	var pass : String;
	var stream : Stream;
	
	function new() {}
	
	function login( jid : String, pass : String, host : String, secure : Bool ) {
		var _jid = new jabber.JID( jid );
		var _host = ( host == null ) ? _jid.domain : host;
		this.pass = pass;
		var cnx : jabber.stream.Connection = if( secure )
			cast new jabber.SecureSocketConnection( _host );
		else
			cast new jabber.SocketConnection( _host );
	//	var cnx = new jabber.SocketConnection( _host );
		stream = new Stream( cnx );
		stream.onOpen = onStreamOpen;
		stream.onClose = onStreamClose;
		stream.open( _jid );
	}
	
	function onStreamOpen() {
		var mechs = new Array<jabber.sasl.TMechanism>();
		mechs.push( new jabber.sasl.PlainMechanism()  );
		var auth = new jabber.client.SASLAuth( stream, mechs );
		auth.onSuccess = onLogin;
		auth.onFail = onLoginFail;
		auth.authenticate( pass, stream.jid.resource );
	}
	
	function onStreamClose( ?e ) {
		if( e == null )
			trace( "XMPP stream closed ["+stream.jid+"]" );
		else
			trace( "XMPP stream error ["+e+"]" );
	}
	
	function onLogin() {
		new jabber.PresenceListener( stream, function(p){} );
		new jabber.MessageListener( stream, function(m){} );
		stream.sendPresence();
	}
	
	function onLoginFail( ?e ) {
		trace( "Authentication failed ["+stream.jid+"]", "warn" );
	}
	
	static function main() {
		#if flash
		flash.Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		flash.Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		#end
		var app = new Test();
		app.login( "romeo@disktree/HXMPP", "test", "127.0.0.1", false );
		// .. google allow secure socket connections on port 5223 only
		//app.login( "username@gmail.com/HXMPP", "test", "talk.google.com", true );
	}
	
}
