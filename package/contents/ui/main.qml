/*
 * This file is part of MinecraftServerPing.
 * Copyright (C) 2020  Chris Josten <chris@netsoj.nl>
 * 
 * MinecraftServerPing is free software: you can redistribute it and/or modify
 * it under the terms of the lesser GNU General Public License as published by
 * the Free Software Foundation, version 3
 *
 * MinecraftServerPing is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * Lesser GNU General Public License for more details.
 *
 * You should have received a copy of the Lesser GNU General Public License
 * along with MinecraftServerPing. If not, see <https://www.gnu.org/licenses/>.
 */

import QtQuick
import QtQuick.Layouts
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.extras
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents

import nl.netsoj.minecraftserverping as MSP

PlasmoidItem {
	id: plasmoidRoot
	// Poor people of example.org won't be able to monitor their minecraft server :/
	property bool configurationRequired: plasmoid.configuration.address == "" || plasmoid.configuration.address == "example.org" || plasmoid.configuration.port == null
	property string configurationRequiredReason
	/**
	 * This object handles the pinging, and is part of th
	 */
	MSP.MinecraftServer {
		id: server
		name: plasmoid.configuration.name
		address: plasmoid.configuration.address
		port: plasmoid.configuration.port
		autoPing: false
		function validateAndRefresh() {
			if (!plasmoidRoot.configurationRequired) {
				refresh()
			}
		}
		
		onAddressChanged: {
			server.validateAndRefresh()
		}
		onPortChanged: {
			server.validateAndRefresh()
		}
		Component.onCompleted: firstDelayTimer.start()
	}
	function action_refresh() {
		server.validateAndRefresh()
	}
	Timer {
		id: firstDelayTimer
		interval: 1000
		onTriggered: server.validateAndRefresh()
	}
	configurationRequiredReason: qsTr("Please set an address and port for the Minecraft server to monitor")
	
	Timer {
		interval: plasmoid.configuration.refreshInterval * 1000
		repeat: true
				running: plasmoidRoot.configurationRequired
		onTriggered: server.validateAndRefresh()
		onIntervalChanged: {
			restart()
			server.validateAndRefresh()
		}
	}
	
	// switchHeight: theme.mSize(theme.defaultFont).height * 4
	// switchWidth: theme.mSize(theme.defaultFont).width * 30
	
    fullRepresentation: MinecraftServerFullDelegate {
		name: server.name
		address: server.address
		port: server.port
		currentPlayers: server.currentPlayers
		maxPlayers: server.maxPlayers
		icon: server.icon
		motd: server.motd
		serverState: server.serverState
		error: server.error
		players: server.playerNamesSample
		opacity: Plasmoid.configurationRequired ? 0.5 : 1
		//height: parent.height
		/*Layout.minimumWidth: implicitWidth
		Layout.minimumHeight: implicitHeight*/
	}
	
	compactRepresentation: MinecraftServerIconDelegate {
		icon: server.icon
		currentPlayers: server.currentPlayers
		motd: server.motd
		serverState: server.serverState
		players: server.playerNamesSample
		opacity: plasmoidRoot.configurationRequired ? 0.5 : 1
	}
	
   preferredRepresentation: fullRepresentation
   toolTipMainText: qsTr("Minecraft Server Status")
   toolTipSubText: server.playerNamesSample.length > 0
		          ? server.playerNamesSample.join("\n")
		          : qsTr("No players online");

	Component.onCompleted: {
		// plasmoid.setAction("refresh", qsTr("Refresh"), "view-refresh")
	}
}
