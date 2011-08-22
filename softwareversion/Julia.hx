
/**
	Listens for and responses to 'SoftwareVersion' requests
*/
class Julia extends ClientBase {
	
	override function onLogin() {
		stream.sendPresence();
		var listener = new jabber.SoftwareVersionListener( stream, "HXMPP", "0.4.8" );
	}
	
	static function main() {
		new Julia().login( "julia@disktree/hxmpp" );
	}
	
}
