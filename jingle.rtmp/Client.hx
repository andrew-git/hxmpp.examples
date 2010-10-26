
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.media.Video;
import flash.text.TextField;

class Client extends ClientBase {
	
	var ui : Sprite;
	var info : TextField;
	var menu : Sprite;
	var btn_hangup : Button;
	var video : Video;
	
	override function onLogin() {
		
		super.onLogin();
		
		flash.net.NetConnection.defaultObjectEncoding = flash.net.ObjectEncoding.AMF0;
		
		ui = new Sprite();
		flash.Lib.current.addChild( ui );
		
		info = new TextField();
		info.autoSize = flash.text.TextFieldAutoSize.LEFT;
		info.selectable = info.mouseEnabled = false;
		ui.addChild( info );
		
		menu = new Sprite();
		menu.y = 30;
		ui.addChild( menu );
		
		btn_hangup = new Button( "HANGUP" );
		btn_hangup.visible = false;
		btn_hangup.onClick = hangup;
		menu.addChild( btn_hangup );
		
		video = new Video( 320, 240 );
		video.y = 100;
		ui.addChild( video );
		
		new jabber.PresenceListener( stream, onPresence );
	}
	
	function onPresence( p : xmpp.Presence ) {
	}
	
	function onJingleFail( info : String ) {
		trace( "Jingle fail ["+info+"]" );
	}
	
	function onJingleInfo( x : Xml ) {
		trace( "Jingle info["+x+"]", "info" );
	}
	
	function onJingleEnd( reason : xmpp.jingle.Reason ) {
		trace( "Jingle end ["+reason+"]", "info" );
		//video.visible = false;
	}
	
	function hangup() {
	}
}


class Button extends Sprite {
	
	public dynamic function onClick() : Void;
	
	public var text(getText,setText) : String;
	
	var tf : TextField;
	
	public function new( text : String ) {
		super();
		tf = new TextField();
		tf.autoSize = flash.text.TextFieldAutoSize.LEFT;
		tf.selectable = tf.mouseEnabled = false;
		tf.text = text;
		addChild( tf );
		graphics.beginFill( 0x9999bb );
		graphics.drawRect( 0, 0, tf.width, tf.height );
		graphics.endFill();
		buttonMode = true;
		addEventListener( MouseEvent.MOUSE_DOWN, mouseDown );
	}
	
	function getText() : String {
		return tf.text;
	}
	function setText( t : String ) : String {
		return tf.text = t;
	}
	
	function mouseDown( e : MouseEvent ) {
		onClick();
	}
}
