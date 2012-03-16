
import jabber.JID;
import jabber.client.Stream;
#if macro
import haxe.macro.Expr;
#end

/**
	Base class for XMPP client tests.
	This class gets extended by most of the test applications (to avoid repeat writing the connect and authentication process).
*/
class ClientBase {
	
	public static inline var defaultResource = "hxmpp-"+getPlatform();
	//public static inline var resource(getResource,null) : String; 
	//static function createResource() : String return "hxmpp-"+getPlatform()
	
	var jid : String;
	var pass : String;
	var ip : String;
	var boshpath : String;
	var stream : Stream;
	
	function new() {
	
		// default credentials
		this.jid = "romeo@disktree";
		this.pass = "test";
		this.ip = "localhost";
		this.boshpath = "jabber";
		
		#if flash
		flash.Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		flash.Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		#end
	}
	
	function login( ?jid : String, ?pass : String, ?ip : String, ?boshpath : String ) {
		
		if( jid != null ) this.jid = jid;
		if( pass != null ) this.pass = pass;
		if( ip != null ) this.ip = ip;
		if( boshpath != null ) this.boshpath = boshpath;
		
		var _jid = new jabber.JID( this.jid );
		
		trace( "Connecting to: "+this.ip+" ..." );
		
		#if (neko||cpp||php||nodejs||flash||air)
		var cnx = new jabber.SocketConnection( this.ip, 5222, false );
		//var cnx = new jabber.SecureSocketConnection( this.ip );
		#elseif js
		var cnx = new jabber.BOSHConnection( _jid.domain, this.ip+"/"+this.boshpath );
		#end
		
		stream = new Stream( cnx );
		stream.onOpen = onStreamOpen;
		stream.onClose = onStreamClose;
		stream.open( _jid );
	}
	
	function onStreamOpen() {
		var mechs = new Array<jabber.sasl.Mechanism>();
		mechs.push( new jabber.sasl.MD5Mechanism() );
		mechs.push( new jabber.sasl.PlainMechanism() );
		var auth = new jabber.client.Authentication( stream, mechs );
		auth.onSuccess = _onLogin;
		auth.onFail = onLoginFail;
		var resource = ( stream.jid.resource != null ) ? stream.jid.resource : defaultResource;
		auth.start( pass, resource );
	}
	
	function onStreamClose( ?e ) {
		if( e == null )
			trace( "XMPP stream closed ["+stream.jid+"]", "info" );
		else
			trace( "XMPP stream error ["+e+"]", "error" );
	}
	
	function onLoginFail( ?e ) {
		trace( "Authentication failed ["+stream.jid+"]", "warn" );
	}
	
	function _onLogin() {
		trace( "Logged in as: "+stream.jid, "info" );
		onLogin();
	}
	
	function onLogin() {
		//override me
	}
	
	//public static inline var resource(getResource,null) : String; 
	//static function createResource() : String return "hxmpp-"+getPlatform()
	
	public static inline var platform(getPlatform,null) : String; 
	static inline function getPlatform() : String {
		return #if cpp "cpp"
		#elseif flash "flash"
		#elseif js
			#if nodejs "nodejs" #elseif rhino "rhino" #else "js" #end
		#elseif neko "neko"
		#elseif php "php"
		#end;
	}
	
}
