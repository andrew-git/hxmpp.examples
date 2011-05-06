
class Julia extends ClientBase {
	
	static var entity = 'romeo@disktree/HXMPP';
	static var requestedAttention = false;
	
	override function onLogin() {
		super.onLogin();
		new jabber.MessageListener( stream, onMessage );
		new jabber.PresenceListener( stream, onPresence );
		stream.sendPresence();
	}
	
	function onPresence( p : xmpp.Presence ) {
		if( !requestedAttention && p.from == entity ) {
			new jabber.Attention( stream ).capture( entity, 'Hey, give me some attention!' );
			requestedAttention = true;
		}
	}
	
	function onMessage( m : xmpp.Message ) {
		if( xmpp.Delayed.fromPacket( m ) != null )
			return;
		trace( m.from+': '+m.body );
	}
	
	static function main() {
		new Julia().login( "julia@disktree" );
	}

}
