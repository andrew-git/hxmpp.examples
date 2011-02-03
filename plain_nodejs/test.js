
require("./hxmpp");

var cnx = new jabber.SocketConnection( "127.0.0.1", 5222, false );
var stream = new jabber.client.Stream( cnx );
stream.onOpen = function(){
	console.log("XMPP stream opened");
	var auth = new jabber.client.SASLAuth( stream, [new jabber.sasl.PlainMechanism()] );
	auth.onSuccess = function() {
		haxe.Log.trace("Authenticated as "+stream.jid.toString());
	}
	auth.onFail = function(e) {
		haxe.Log.trace("Login failed");
	}
	auth.authenticate("test","HXMPP");
}
stream.onClose= function(e){
	console.log("XMPP stream closed");
}
stream.open( new jabber.JID( "romeo@disktree" ) );
