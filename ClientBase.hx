
import jabber.JID;
import jabber.client.Stream;

/**
	Base class for XMPP client tests.
	This class gets extended by the test applications to avoid repeating the authentication process over and over again.
*/
class ClientBase {
	
	#if js
	static var BOSH_PATH = "127.0.0.1/jabber";
	#end
	
	var stream : Stream;
	var pass : String;
	
	function new() {
	}
	
	function login( jid : String, pass : String, ?host : String ) {
		var _jid = new jabber.JID( jid );
		var _host = ( host == null ) ? _jid.domain : host;
		this.pass = pass;
		#if (js&&!nodejs)
		var cnx = new jabber.BOSHConnection( _jid.domain, BOSH_PATH );
		#else
		var cnx = new jabber.SocketConnection( _host );
		#end
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
	
	function onLoginFail( ?e ) {
		trace( "Authentication failed ["+stream.jid+"]", "warn" );
	}
	
	function onLogin() {
		trace( "Logged in as ["+stream.jid+"]" );
	}
	
	/*
	public static function getAccount( num : Int ) : { jid : JID, pass : String } {
		var p = haxe.Resource.getString( "account_"+num ).split( ":" );
		return { jid : new jabber.JID( p[0] ), pass : p[1] };
	}
	*/
}
