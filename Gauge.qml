import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.3
import QtQuick.Extras.Private 1.0
import QtGraphicalEffects 1.0

CircularGauge {
    id: gauge
    property string speedColor: "#32D74B"
    function speedColorProvider(value){
        if(value < 60 ){
            return "#32D74B"
        } else if(value > 60 && value < 150){
            return "yellow"
        }else{
            return "Red"
        }
    }
    style: CircularGaugeStyle {
        labelStepSize: 10
        labelInset: outerRadius / 2.2
        tickmarkInset: outerRadius / 4.2
        minorTickmarkInset: outerRadius / 4.2
        minimumValueAngle: -144
        maximumValueAngle: 144

        background: Rectangle {
            implicitHeight: gauge.height
            implicitWidth: gauge.width
            color: "#1E1E1E"
            anchors.centerIn: parent
            radius: 360
            opacity: 0.5

//            Image {
//                anchors.fill: parent
//                source: "qrc:/assets/background.svg"
//                asynchronous: true
//                sourceSize {
//                    width: width
//                }
//            }

            Canvas {
                property int value: gauge.value

                anchors.fill: parent
                onValueChanged: requestPaint()

                function degreesToRadians(degrees) {
                  return degrees * (Math.PI / 180);
                }

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();

                    // Define the gradient colors for the filled arc
                    var gradientColors = [
                        "#32D74B",     // Start color
                        "yellow",  // Middle color (you can add more colors for more segments)
                        "red"    // End color
                    ];

                    // Calculate the start and end angles for the filled arc
                    var startAngle = valueToAngle(gauge.minimumValue) - 90;
                    var endAngle = valueToAngle(gauge.value) - 90;

                    // Loop through the gradient colors and fill the arc segment with each color
                    for (var i = 0; i < gradientColors.length; i++) {
                        var gradientColor = speedColorProvider(gauge.value)
                        speedColor = gradientColor
                        var angle = startAngle + (endAngle - startAngle) * (i / gradientColors.length);

                        ctx.beginPath();
                        ctx.lineWidth = outerRadius * 0.225;
                        ctx.strokeStyle = gradientColor;
                        ctx.arc(outerRadius,
                                outerRadius,
                                outerRadius - ctx.lineWidth / 2,
                                degreesToRadians(angle),
                                degreesToRadians(endAngle));
                        ctx.stroke();
                    }
                }

            }
        }

        needle: Item {
            visible: gauge.value.toFixed(0) > 0
            y: -outerRadius * 0.78
            height: outerRadius * 0.27
            Image {
                id: needle
                source: "qrc:/assets/needle.svg"
                height: parent.height
                width: height * 0.1
                asynchronous: true
                antialiasing: true
            }

            Glow {
              anchors.fill: needle
              radius: 5
              samples: 10
              color: "white"
              source: needle
          }
        }

        foreground: Item {
            ColumnLayout{
                anchors.centerIn: parent
                Label{
                    text: gauge.value.toFixed(0)
                    font.pixelSize: 85
                    font.family: "Inter"
                    color: "#01E6DE"
                    font.bold: Font.DemiBold
                    Layout.alignment: Qt.AlignHCenter
                }

                Label{
                    text: "MPH"
                    font.pixelSize: 46
                    font.family: "Inter"
                    color: "#01E6DE"
                    font.bold: Font.Normal
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        tickmarkLabel:  Text {
            font.pixelSize: Math.max(6, outerRadius * 0.05)
            text: styleData.value
            color: styleData.value <= gauge.value ? "white" : "#777776"
            antialiasing: true
        }

        tickmark: Image {
            source: "qrc:/assets/tickmark.svg"
            width: outerRadius * 0.018
            height: outerRadius * 0.15
            antialiasing: true
            asynchronous: true
        }

        minorTickmark: Rectangle {
            implicitWidth: outerRadius * 0.01
            implicitHeight: outerRadius * 0.03

            antialiasing: true
            smooth: true
            color: styleData.value <= gauge.value ? "white" : "darkGray"
        }
    }
}
