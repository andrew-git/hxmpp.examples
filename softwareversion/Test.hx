
/**
	Requests another entity for the software version.
*/
class Test extends ClientBase {
	
	override function onLogin() {
		
		stream.sendPresence();
		
		var swv = new jabber.SoftwareVersion( stream, "HXMPP", "0.4" );
		swv.onLoad = function( jid : String, swv : xmpp.SoftwareVersion ) {
			trace( "SoftwareVersion of "+jid+": "+swv.name+" "+swv.version+", Operating system: "+swv.os, "info" );
		};
		swv.load( "julia@disktree/desktop" );
	}
	
	static function main() {
		new Test().login( "romeo@disktree" );
	}
	
}
