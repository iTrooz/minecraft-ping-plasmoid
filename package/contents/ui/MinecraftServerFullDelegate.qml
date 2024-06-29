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
import QtQuick.Controls
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.extras
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

import nl.netsoj.minecraftserverping

Item {
	id: fullRoot
	clip: true
	// implicitHeight: theme.mSize(Kirigami.Theme.defaultFont).height * 4 + Kirigami.Units.smallSpacing * 2
	// implicitWidth: + theme.mSize(Kirigami.Theme.defaultFont).width * 30 + theme.mSize(Kirigami.Theme.defaultFont).height * 3 + 3 * Kirigami.Units.smallSpacing
	property string name
	property string address
	property int port
	property string icon
	property int currentPlayers
	property int maxPlayers
	property string motd
	property int serverState
	property string error
	property var players

	Image {
		id: serverImage
		anchors.left: parent.left
		anchors.leftMargin: Kirigami.Units.smallSpacing
		anchors.top: parent.top
		anchors.topMargin: Kirigami.Units.smallSpacing
		anchors.bottomMargin: Kirigami.Units.smallSpacing
		anchors.bottom: parent.bottom
		width: height
		fillMode: Image.PreserveAspectFit
		source: icon ? icon : "../images/no-icon.svgz"
	}
	Heading {
		id: serverName
		anchors.left: serverImage.right
		anchors.leftMargin: Kirigami.Units.largeSpacing
		anchors.top: parent.top
		anchors.right: serverPlayers.left
		anchors.rightMargin: Kirigami.Units.largeSpacing
		text: name
		elide: Text.ElideRight
	}
	
	PlasmaComponents.Label {
		id: serverPlayers
		anchors.right: parent.right
		anchors.rightMargin: Kirigami.Units.smallSpacing
		anchors.baseline: serverName.baseline
		text: qsTr("??/??", "current and maximum amount of players unknown")
		Binding on text {
			when: fullRoot.serverState == MinecraftServer.ONLINE
			value: qsTr("%1 / %2", "current players/maximum amount of players").arg(currentPlayers).arg(maxPlayers)
		}

		MouseArea {
			id: serverPlayersHover
			anchors.fill: parent
			hoverEnabled: true

		}

		ToolTip.visible: serverPlayersHover.containsMouse
		ToolTip.text: fullRoot.players.length > 0
		              ? fullRoot.players.join("\n")
					  : qsTr("No players online");
	}
	
	Motd {
		id: serverMotd
		anchors.top: serverName.bottom
		anchors.left: serverImage.right
		anchors.leftMargin: Kirigami.Units.largeSpacing
		anchors.right: parent.right
		
		motd: fullRoot.motd
		serverState: fullRoot.serverState
		error: fullRoot.error
		address: fullRoot.address
		port: fullRoot.port
	}
}
