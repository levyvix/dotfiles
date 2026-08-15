import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "levi.youtube-music"

  readonly property var players: Mpris.players ? Mpris.players.values : []
  readonly property var player: findYoutubeMusicPlayer()
  property bool popupOpen: false

  function metadataUrl(candidate) {
    var metadata = candidate && candidate.metadata ? candidate.metadata : {}
    return String(metadata["xesam:url"] || "")
  }

  function isYoutubeMusic(candidate) {
    if (!candidate) return false
    var identity = String(candidate.identity || "").toLowerCase()
    var url = metadataUrl(candidate).toLowerCase()
    return identity.indexOf("youtube music") !== -1 || url.indexOf("music.youtube.com") !== -1
  }

  function findYoutubeMusicPlayer() {
    var paused = null
    for (var i = 0; i < players.length; i++) {
      var candidate = players[i]
      if (!isYoutubeMusic(candidate)) continue
      if (candidate.isPlaying) return candidate
      if (!paused) paused = candidate
    }
    return paused
  }

  function playPause() {
    if (player && player.canTogglePlaying) player.togglePlaying()
  }

  function previous() {
    if (player && player.canGoPrevious) player.previous()
  }

  function next() {
    if (player && player.canGoNext) player.next()
  }

  function openYoutubeMusic() {
    Quickshell.execDetached(["omarchy-launch-webapp", "https://music.youtube.com"])
    popupOpen = false
  }

  visible: player !== null
  implicitWidth: player ? row.implicitWidth + Style.space(12) : 0
  implicitHeight: barSize

  Row {
    id: row
    anchors.centerIn: parent
    spacing: Style.space(6)

    Text {
      anchors.verticalCenter: parent.verticalCenter
      text: player && player.isPlaying ? "󰏤" : "󰐊"
      color: root.bar.barForeground
      font.family: root.bar.fontFamily
      font.pixelSize: Style.font.body
    }

    Text {
      anchors.verticalCenter: parent.verticalCenter
      text: player ? (player.trackTitle || "YouTube Music") : ""
      color: root.bar.barForeground
      font.family: root.bar.fontFamily
      font.pixelSize: Style.font.body
      elide: Text.ElideRight
      width: Math.min(Style.space(180), implicitWidth)
    }
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onClicked: function(mouse) {
      if (mouse.button === Qt.RightButton) popupOpen = !popupOpen
      else playPause()
    }
  }

  PopupCard {
    id: popup
    anchorItem: root
    bar: root.bar
    owner: root
    open: root.popupOpen
    contentWidth: popup.fittedContentWidth(Style.space(320))
    contentHeight: popup.fittedContentHeight(content.implicitHeight)

    Column {
      id: content
      anchors.fill: parent
      spacing: Style.space(10)

      Text {
        width: parent.width
        text: player ? (player.trackTitle || "YouTube Music") : "YouTube Music"
        color: root.bar.barForeground
        font.family: root.bar.fontFamily
        font.pixelSize: Style.font.subtitle
        font.bold: true
        wrapMode: Text.WordWrap
      }

      Text {
        width: parent.width
        visible: !!player && player.trackArtist !== ""
        text: player ? player.trackArtist : ""
        color: Qt.darker(root.bar.barForeground, 1.35)
        font.family: root.bar.fontFamily
        font.pixelSize: Style.font.bodySmall
        elide: Text.ElideRight
      }

      RowLayout {
        width: parent.width
        spacing: Style.space(8)

        Button {
          Layout.fillWidth: true
          text: "󰒮"
          enabled: !!player && player.canGoPrevious
          onClicked: root.previous()
        }

        Button {
          Layout.fillWidth: true
          text: player && player.isPlaying ? "󰏤" : "󰐊"
          enabled: !!player && player.canTogglePlaying
          onClicked: root.playPause()
        }

        Button {
          Layout.fillWidth: true
          text: "󰒭"
          enabled: !!player && player.canGoNext
          onClicked: root.next()
        }
      }

      Button {
        width: parent.width
        text: "Open YouTube Music"
        onClicked: root.openYoutubeMusic()
      }
    }
  }
}
