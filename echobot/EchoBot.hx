
import jabber.client.Stream;
import jabber.client.Authentication;

/**
	A simple XMPP client responding with a "Hello" to every message.
*/
class EchoBot {
	
	static var HOST = "disktree";
	static var IP = "localhost";
	static var JID = "romeo@"+HOST;
	static var PASSWORD = "test";
    static var RESOURCE = "HXMPP";
	static var stream : Stream;
	
	static function main() {
		
		/*
		#if cpp
		var s = "23";
		//trace( untyped __global__.__hxcpp_utf8_string_to_char_bytes(s) );
		trace( cpp.Utf8.decode(s) );
		//::haxe::Log_obj::trace(::cpp::Utf8_obj::decode(s),hx::SourceInfo(HX_CSTRING("EchoBot.hx"),22,HX_CSTRING("EchoBot"),HX_CSTRING("main")));
		
		untyped {
			//printf("233".__s);
		}
		#end
		return;
		*/
		
		#if (!nodejs&&(flash||js))
		if( haxe.Firebug.detect() ) haxe.Firebug.redirectTraces(); 
		#end
		
		jabber.XMPPDebug.beautify = true;
		
		// crossplatform stuff, using the 'best' connection available for the target
		#if ( js && !nodejs && !JABBER_SOCKETBRIDGE )
		var cnx = new jabber.BOSHConnection( HOST, IP+"/http" );
		#else
		var cnx = new jabber.SocketConnection( IP, 5222, false );
		#end

		var jid = new jabber.JID( JID );
		stream = new Stream( cnx );
		stream.onClose = function(?e) {
			if( e == null ) trace( "XMPP stream closed.", 'warn' );
			else trace( "An XMPP stream error occured: "+e, 'error' );
		}
		stream.onOpen = function() {
			var mechs = new Array<jabber.sasl.Mechanism>();
			mechs.push( new jabber.sasl.MD5Mechanism() );
			//mechs.push( new jabber.sasl.PlainMechanism() );
			var auth = new Authentication( stream, mechs );
			auth.onSuccess = function() {
				new jabber.MessageListener( stream, handleMessage );
				//stream.sendPresence();
				//trace( "Logged in as "+JID );
			}
			auth.start( PASSWORD, RESOURCE );
		}
		stream.open( jid );
	}
	
	// handle incoming messages
	static function handleMessage( m : xmpp.Message ) {
	
		if( xmpp.Delayed.fromPacket( m ) != null )
			return; // avoid processing of offline sent messages
			
		var jid = new jabber.JID( m.from ); // parsing the 'from' into a jabber-id
		trace( "Recieved message from "+jid.bare+" at resource: "+jid.resource );
		
		// send response message
		stream.sendPacket( new xmpp.Message( m.from, "Hello darling aka "+jid.node ) );
	}
	
}
