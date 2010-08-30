
import JQuery;
typedef JQ = JQuery;
import xmpp.ChatState;

class TestClient extends ClientBase {
	
	var occupant : jabber.JID;
	var initialized : Bool;
	var chatState : jabber.ChatStateNotification;
	var timer : haxe.Timer;
	var input : JQ;
	var output : JQ;
	var lastAction : Float;
	var lastInput : String;
	
	function new( occupant : String ) {
		super();
		this.occupant = new jabber.JID( occupant );
		lastAction = -1;
		initialized = false;
	}
	
	override function onLogin() {
		
		super.onLogin();
		
		chatState = new jabber.ChatStateNotification( stream );
		chatState.onState = onChatState;
		
		new jabber.MessageListener( stream, onMessage );
		new jabber.PresenceListener( stream, onPresence );
		stream.sendPresence();
	}
	
	function checkChatState() {
		lastAction = haxe.Timer.stamp();
		var inp = input.val();
		if( inp != lastInput ) {
			chatState.send( occupant.toString(), xmpp.ChatState.composing );
			lastInput = inp;
		}
	}
	
	function checkInactive() {
		if( lastAction != -1 ) {
			var now = haxe.Timer.stamp();
			if( now-lastAction > 30 ) {
				sendChatState( xmpp.ChatState.inactive );
				lastAction = -1;
			} else if( now-lastAction > 180 ) {
				sendChatState( xmpp.ChatState.gone );
				lastAction = -1;
			}
		}
	}
	
	function onChatState( jid : String, state : xmpp.ChatState ) {
		new JQ("#chatstate_"+stream.jid.node ).html( "ChatState: "+occupant.node+": "+Std.string(state) );
	}
	
	function sendChatState( state : xmpp.ChatState ) {
		chatState.send( occupant.toString(), state );
	}
	
	function onPresence( p : xmpp.Presence ) {
		var jid = new jabber.JID( p.from );
		if( jid.bare == occupant.bare ) {
			if( !initialized ) {
				var e = new JQ( "#ui_"+stream.jid.node );
				var ctx : Dynamic = { user : stream.jid.node };
				e.html( new haxe.Template( haxe.Resource.getString( "chat" ) ).execute( ctx ) );
				var me = this;
				output = new JQ( "#chatoutput_"+stream.jid.node );
				input = new JQ( "#chatinput_"+stream.jid.node );
				input.focus(function(){
					me.sendChatState( ChatState.active );
					me.input.bind( "keydown", me.checkChatState );
				});
				input.blur(function(){
					me.sendChatState( ChatState.paused );
					me.input.unbind( "keydown", me.checkChatState );
				}); 
				var btn = new JQ("#btn_send_"+stream.jid.node );
				btn.mousedown( function(){
					var e_input = new JQ( "#chatinput_"+me.stream.jid.node );
					var msg = e_input.val();
					if( msg != "" ) {
						e_input.val( "" );
						me.sendChatState( ChatState.paused );
						me.stream.sendMessage( me.occupant.toString(), msg );
					}
				});
				timer = new haxe.Timer( 1000 );
				timer.run = me.checkInactive;
				initialized = true;
			}
		}
	}
	
	function onMessage( m : xmpp.Message ) {
		if( m.body != null ) {
			output.append( m.body+"<br/>" );
		}
	}
	
}