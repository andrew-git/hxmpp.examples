
import jabber.client.Stream;
import jabber.client.SASLAuth;

/**
	A simple XMPP client responding with a "Hello" to every message.
*/
class EchoBot {
	
	static var HOST = "disktree";
	static var IP = "127.0.0.1";
	static var JID = "julia@"+HOST;
	static var PASSWORD = "test";
    static var RESOURCE = "HXMPP";
    
	static var stream : Stream;
	
	static function main() {
		
		#if (!nodejs&&(flash||js))
		if( haxe.Firebug.detect() ) haxe.Firebug.redirectTraces(); 
		#end
		
		// crossplatform stuff, using the 'best' connection available for the target
		#if ( js && !nodejs && !JABBER_SOCKETBRIDGE )
		var cnx = new jabber.BOSHConnection( HOST, IP+"/jabber" );
		#else
		var cnx = new jabber.SocketConnection( IP, 5222, false );
		#end

		//#if JABBER_SOCKETBRIDGE trace( "Using flash socketbridge to connect to server" ); #end
		
		var jid = new jabber.JID( JID );
		stream = new Stream( cnx );
		stream.onClose = function(?e) {
			if( e == null ) trace( "XMPP stream closed." );
			else trace( "An XMPP stream error occured: "+e );
		}
		stream.onOpen = function() {
			var mechs = new Array<jabber.sasl.TMechanism>();
			mechs.push( new jabber.sasl.MD5Mechanism() );
			mechs.push( new jabber.sasl.PlainMechanism() );
			var auth = new SASLAuth( stream, mechs );
			auth.onSuccess = function() {
				new jabber.MessageListener( stream, handleMessage );
				stream.sendPresence();
				trace( "Logged in as "+JID );
			}
			auth.authenticate( PASSWORD, RESOURCE );
		}
		stream.open( jid );
	}
	
	// handle incoming messages
	static function handleMessage( m : xmpp.Message ) {
		if( xmpp.Delayed.fromPacket( m ) != null )
			return; // avoid processing of offline sent messages
		var jid = new jabber.JID( m.from ); // parsing the 'from' into a jabber-id
		trace( "Recieved message from "+jid.bare+" at resource: "+jid.resource );
		stream.sendPacket( new xmpp.Message( m.from, "Hello darling aka "+jid.node ) );
	}
	
}
