
class Romeo extends ClientBase {
	
	override function onLogin() {
		super.onLogin();
		new jabber.AttentionListener( stream, onAttentionRequest );
		stream.sendPresence();
	}
	
	function onAttentionRequest( m : xmpp.Message ) {
		if( xmpp.Delayed.fromPacket( m ) != null )
			return;
		trace( m.from+" wants your attention", "info" );
		stream.sendMessage( m.from, 'You now have my full attention' );
	}
	
	static function main() {
		new Romeo().login( "romeo@disktree" );
	}

}
