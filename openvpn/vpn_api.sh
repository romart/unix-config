#!/bin/bash

function vpn_connect() {
	openvpn3 session-start --config $1
}

function vpn_disconnect() {
	openvpn3 session-manage --config $1 --disconnect
}


function vpn_status() {
	openvpn3 sessions-list
}

