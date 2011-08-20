
class BOSHConnection extends jabber.BOSHConnection {
	
	var worker : Dynamic; // Worker;
	
	public override function connect() {
		worker = Type.createInstance( untyped Worker, ["worker_bosh.js"] ); // new Worker( "worker_bosh.js" );
		worker.onmessage = function(e) { handleHTTPData( e.data ); }
		super.connect();
	}
	
	override function createHTTPRequest( data : String ) {
		worker.postMessage( untyped JSON.stringify( { url : getHTTPPath(), data : data } ) );
	}
}

/**
	Test/Example of running every http/xhr request of a bosh connection in a seperate thread using webworkers.
*/
class Test {
	
	static function main() {
		var cnx = new BOSHConnection( "disktree.local", "disktree.local/http", 1, 30, false, 2 );
		var stream = new jabber.client.Stream( cnx );
		stream.onOpen = function(){
			trace("XMPP stream opened");
			var auth = new jabber.client.Authentication( stream, [cast new jabber.sasl.PlainMechanism()] );
			auth.onSuccess = function(){
				stream.sendPresence();
			}
			auth.authenticate( "test", "HXMPP" );
		}
		stream.onClose = function(?e){trace(e);};
		try {
			stream.open( new jabber.JID( "romeo@disktree" ) );
		} catch(e : Dynamic ) {
			trace(e);
		}
	}
	
}
