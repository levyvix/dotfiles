import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

Panel {
  id: root
  moduleName: "levi.notification-center"
  ipcTarget: "levi.notification-center"

  readonly property var notificationService: shell ? shell.serviceFor("omarchy.notifications") : null
  readonly property string historyDir: notificationService
    ? notificationService.historyDir
    : Quickshell.env("HOME") + "/.local/state/omarchy/notifications/history/"
  readonly property color foreground: bar ? bar.foreground : Color.foreground
  readonly property color dim: Qt.darker(foreground, 1.5)
  readonly property string fontFamily: bar ? bar.fontFamily : Style.font.family

  ListModel { id: historyModel }

  Process {
    id: historyProcess
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.loadRows(text)
    }
  }

  function loadHistory() {
    historyProcess.command = ["bash", "-c",
      "for f in \"$1\"/*.json; do [ -f \"$f\" ] && awk 1 \"$f\"; done", "--", historyDir]
    historyProcess.running = true
  }

  function loadRows(raw) {
    var rows = []
    var lines = String(raw || "").split("\n")
    for (var i = 0; i < lines.length; i++) {
      var line = lines[i].trim()
      if (line === "") continue
      try { rows.push(JSON.parse(line)) } catch (e) { }
    }
    rows.sort(function(a, b) { return Number(b.timestamp || 0) - Number(a.timestamp || 0) })
    historyModel.clear()
    for (var j = 0; j < Math.min(rows.length, 10); j++) historyModel.append(rows[j])
  }

  function dismiss(index) {
    if (index >= 0 && index < historyModel.count) {
      historyModel.remove(index)
    }
  }

  function clearHistory() {
    historyModel.clear()
  }

  function openNotification(row) {
    var command = row && String(row.exec || "")
    if (command !== "") {
      Util.execDetached(command)
      return
    }
    if (notificationService && row) notificationService.focusApp(row)
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  onOpenedChanged: if (opened) {
    loadHistory()
    Qt.callLater(function() { keyCatcher.forceActiveFocus() })
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "󰂚"
    active: false
    onPressed: root.toggle()
  }

  KeyboardPanel {
    id: panel
    anchorItem: button
    owner: root
    bar: root.bar
    open: root.opened
    focusTarget: keyCatcher
    contentWidth: panel.fittedContentWidth(Style.space(390))
    contentHeight: panel.fittedContentHeight(content.implicitHeight, Style.space(600))

    PanelKeyCatcher {
      id: keyCatcher
      anchors.fill: parent
      onCloseRequested: root.close()
      onTextKey: function(text) {
        if (text === "r" || text === "R") root.loadHistory()
        if (text === "c" || text === "C") {
          root.clearHistory()
          root.close()
        }
      }

      Flickable {
        id: notificationFlick
        anchors.fill: parent
        contentWidth: width
        contentHeight: content.implicitHeight
        clip: true
        flickableDirection: Flickable.VerticalFlick
        interactive: contentHeight > height
        maximumFlickVelocity: 5000
        ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

        WheelHandler {
          onWheel: function(event) {
            var delta = event.angleDelta.y !== 0
              ? event.angleDelta.y / 120 * 80
              : event.pixelDelta.y * 1.5
            var maximum = Math.max(0, notificationFlick.contentHeight - notificationFlick.height)
            notificationFlick.contentY = Math.max(0, Math.min(maximum, notificationFlick.contentY - delta))
            event.accepted = true
          }
        }

        Column {
          id: content
          width: parent.width
          spacing: Style.space(10)

          PanelHero {
            width: parent.width
            title: "Notification center"
            meta: root.notificationService
              ? historyModel.count + " recent"
              : "Notification service unavailable"
            foreground: root.foreground
            fontFamily: root.fontFamily
            iconComponent: Component {
              Text {
                text: "󰂚"
                color: root.foreground
                font.family: root.fontFamily
                font.pixelSize: Style.font.display
              }
            }
          }

          RowLayout {
            width: parent.width
            spacing: Style.space(8)

            Text {
              Layout.fillWidth: true
              text: "R refresh · C clear all · Esc close"
              color: root.dim
              font.family: root.fontFamily
              font.pixelSize: Style.font.bodySmall
            }

            Button {
              text: "Clear all"
              enabled: historyModel.count > 0
              onClicked: root.clearHistory()
            }
          }

          Text {
            width: parent.width
            visible: historyModel.count === 0
            text: root.notificationService ? "No recent notifications." : "The notification service is not ready."
            color: root.dim
            font.family: root.fontFamily
            font.pixelSize: Style.font.body
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
          }

          Repeater {
            model: historyModel

            delegate: Item {
              required property int index
              required property string app
              required property string summary
              required property string body
              required property string appIcon
              required property string exec
              required property int urgency

              width: content.width
              implicitHeight: card.implicitHeight

              MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.openNotification({ app: app, exec: exec })
              }

              BorderSurface {
                id: card
                anchors.fill: parent
                implicitHeight: cardColumn.implicitHeight + Style.space(20)
                color: Color.notifications.background
                borderSpec: Border.flat(urgency === 2 ? Color.urgent : Color.notifications.border, 1)
                radius: Style.cornerRadius
                z: 1

                Column {
                id: cardColumn
                width: parent.width - Style.space(20)
                x: Style.space(10)
                y: Style.space(10)
                spacing: Style.space(5)
                z: 1

                RowLayout {
                  width: parent.width
                  spacing: Style.space(8)

                  Text {
                    Layout.fillWidth: true
                    text: app !== "" ? app : "Notification"
                    color: root.dim
                    font.family: root.fontFamily
                    font.pixelSize: Style.font.bodySmall
                    elide: Text.ElideRight
                  }

                  Button {
                    text: "×"
                    onClicked: root.dismiss(index)
                  }
                }

                Text {
                  width: parent.width
                  text: summary
                  color: root.foreground
                  font.family: root.fontFamily
                  font.pixelSize: Style.font.body
                  font.bold: true
                  wrapMode: Text.WordWrap
                }

                Text {
                  width: parent.width
                  visible: body !== ""
                  text: body
                  color: root.dim
                  font.family: root.fontFamily
                  font.pixelSize: Style.font.bodySmall
                  wrapMode: Text.WordWrap
                  maximumLineCount: 4
                  elide: Text.ElideRight
                }
                }
              }
            }
          }
        }
      }
    }
  }
}
