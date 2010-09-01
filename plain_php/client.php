<?php

require('lib/php/Boot.class.php');
require('lib/HList.class.php');
require('lib/jabber/JID.class.php');
require('lib/jabber/SocketConnection.class.php');
require('lib/jabber/client/SASLAuth.class.php');

$cnx = new jabber_SocketConnection("127.0.0.1",null,null,null,null,null);
$stream = new jabber_client_Stream($cnx,"1.0");
$stream->onOpen = function() use ($stream) {
	print "XMPP stream opened";
	$mechs = new HList();
	$mechs->add( new jabber_sasl_PlainMechanism());
	$auth = new jabber_client_SASLAuth($stream,$mechs);
	$auth->onSuccess = function(){
		print "Logged in.";
	};
	$auth->authenticate("test","HXMPP");
};
$stream->open( new jabber_JID("romeo@disktree") );
