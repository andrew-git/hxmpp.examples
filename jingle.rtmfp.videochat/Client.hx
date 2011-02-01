
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.media.Video;

class Client extends ClientBase {
	
	static var CIRRUS_KEY = haxe.Resource.getString("cirrus_key");
	static var CIRRUS_URL = "rtmfp://p2p.rtmfp.net/";
	
	var ui : Sprite;
	var info : TextField;
	var menu : Sprite;
	var btn_hangup : Button;
	var video : Video;
	
	override function onLogin() {
		
		super.onLogin();
		
		new jabber.PresenceListener( stream, onPresence );
		
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
		
		video = new Video( 160, 120 );
		video.y = 100;
		ui.addChild( video );
	}
	
	function onPresence( p : xmpp.Presence ) {
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
