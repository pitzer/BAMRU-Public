var raised=document.getElementById('raised').innerHTML;
var goal=document.getElementById('goal').innerHTML;
raised=raised.replace(/[^0-9\.]+/g,""); // set to digits only
goal=goal.replace(/[^0-9\.]+/g,""); // set to digits only
raised=raised*1; // convert text to numeric
goal=goal*1; // convert text to numeric
if (raised>goal) {
    raised=goal;
    document.getElementById('raised').innerHTML=document.getElementById('goal').innerHTML;
} // prevent exceeding 100%;
var mercury=(raised/goal)*100; // get percentage
var displayMercury=mercury.toFixed(2); // restrict percentage to 2 places after the decimal
displayMercury=displayMercury.replace(/\.00/,""); // if the percentage is a whole number, the decimal and zeroes are removed
document.getElementById('towards').innerHTML=displayMercury+"%"; // display the percentage
document.getElementById('rojo').style.height=mercury*250/100+'px'; // display the red mercury in the thermometer
document.getElementById('rojo').style.top=268.47-(mercury*2.47)+'px'; // position the red mercury in the thermometer
if (displayMercury==100) {
    document.getElementById('rojo').style.display="none";
    document.write('<style>#thermometer{background-image:url(fullthermometer.gif);}</style>');
}