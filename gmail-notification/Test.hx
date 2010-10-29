
/**
	http://code.google.com/apis/talk/jep_extensions/gmail.html
*/
class Test extends ClientBase {
	
	override function login( ?jid : String, ?pass : String, ?ip : String, ?boshpath : String ) {
		var _jid = new jabber.JID( jid );
		this.pass = pass;
		var cnx = new jabber.SecureSocketConnection( ip, 443 );
		stream = new jabber.client.Stream( cnx );
		stream.onOpen = onStreamOpen;
		stream.onClose = onStreamClose;
		stream.open( _jid );
	}
	
	override function onLogin() {
		super.onLogin();
		var gmail = new jabber.client.GMailNotify( stream );
		gmail.onMail = onMail;
		gmail.request();
	}
	
	function onMail( x : Xml ) {
		trace( "You got mail:" );
		trace( x );
	}
	
	static function main() {
		new Test().login( "youremail@gmail.com/HXMPP", "yourpassword", "talk.google.com" );
	}

}
