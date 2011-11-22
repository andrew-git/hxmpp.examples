
class Test extends ClientBase {
	
	var disco : jabber.ServiceDiscovery;
	var target : String;
	
	function new( target : String ) {
		super();
		this.target = target;
	}
	
	override function onLogin() {
		
		super.onLogin();
		new jabber.PresenceListener( stream, onPresence );
		
		// add some stream features to test disco request responses
		new jabber.Pong( stream );
		new jabber.LastActivityListener( stream );
		
		disco = new jabber.ServiceDiscovery( stream );
		disco.onInfo = onDiscoInfo;
		disco.onItems = onDiscoItems;
		new jabber.ServiceDiscoveryListener( stream, [{category:"client",type:"pc",name:"HXMPP"}] );
		
		stream.sendPresence();
		
		disco.info( target ); // discover server info
		disco.items( target ); // discover server items
	}
	
	function onPresence( p : xmpp.Presence ) {
		var jid = new jabber.JID( p.from );
		if( jid.bare != stream.jid.bare && p.type == null ) {
			disco.info( p.from );
		}
	}
	
	function onDiscoInfo( jid : String, info : xmpp.disco.Info ) {
		trace( "Disco info ["+jid+"]:", "info" );
		trace( "identities:" );
		for( identity in info.identities )
			trace( "\tname: "+identity.name+" , type: "+identity.type+" , category: "+identity.category, "info" );
		trace( "features:");
		for( feature in info.features )
			trace( "\t"+feature, "info"  );
		trace("\n");
	}
	
	function onDiscoItems( node : String, items : xmpp.disco.Items ) {
		trace( "Disco items ["+node+"]:", "info"  );
		if( items.length == 0 ) {
			trace( "Null items", "info" );
			return;
		}
		var recieved = new Array<String>();
		for( i in items ) {
			trace( "\t"+i.jid+" , "+i.name, "info" );
			recieved.push( i.jid );
		}
		for( r in recieved ) {
			disco.info( r );
		}
	}
	
	static function main() {
		var target = "disktree";
		#if neko
		var args = neko.Sys.args();
		if( args.length > 0 ) {
			target = args[0];
		}
		#end
		new Test( target ).login( "romeo@disktree" );
	}

}
