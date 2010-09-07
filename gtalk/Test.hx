
import jabber.client.Stream;

/**
	GTalk example.
	Google allows only secure socket connections on port 5223 or 443.
*/
class Test extends ClientBase {
	
	override function login( ?jid : String, ?pass : String, ?ip : String, ?boshpath : String ) {
		
		var _jid = new jabber.JID( jid );
		this.pass = pass;
		
		var cnx = new jabber.SecureSocketConnection( ip, 443 );
		
		stream = new Stream( cnx );
		stream.onOpen = onStreamOpen;
		stream.onClose = onStreamClose;
		stream.open( _jid );
	}
	
	override function onLogin() {
		stream.sendPresence();
	}
	
	static function main() {
		var app = new Test();
		app.login( "romeo@gmail.com/HXMPP", "yourpassword", "talk.google.com" );
	}
	
}
