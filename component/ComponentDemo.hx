
import jabber.component.Stream;

/**
	HXMPP server component example
*/
class ComponentDemo {
	
	static var SERVER = "disktree";
	static var COMPONENT = "mycomp";
	static var SECRET = "1234";
	
	static var stream : Stream;
	
	static function main() {
		
		trace( "HXMPP server component example" );
		
		var identity = { category : "conference", name : "MYSERVICE", type : "text" };
		
		var cnx = new jabber.SocketConnection( "127.0.0.1" );
		stream = new Stream( cnx );
		stream.onOpen = function() {
			trace( "XMPP stream opened.", "info" );
		}
		stream.onClose = function(?e) {
			trace( "XMPP stream closed." );
		}
		stream.onConnect = function() {
			trace( "Component connected. Have fun!", "info" );
		}
		stream.open( SERVER, COMPONENT, SECRET, [identity] );
		trace( "Connecting to server ("+stream.host+") ..." );
	}
	
}
