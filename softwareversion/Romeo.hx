
/**
	Requests another entity for the 'SoftwareVersion'
*/
class Romeo extends ClientBase {
	
	override function onLogin() {
		
		stream.sendPresence();
		
		var swv = new jabber.SoftwareVersion( stream );
		swv.onLoad = function( jid : String, swv : xmpp.SoftwareVersion ) {
			trace( "SoftwareVersion of "+jid+": "+swv.name+" "+swv.version+", Operating system: "+swv.os, "info" );
		};
		swv.load( "julia@disktree/hxmpp" );
	}
	
	static function main() {
		new Romeo().login( "romeo@disktree" );
	}
	
}
