(function() {
  var adjustPx, displayMercury, goal, mercury, mercuryGap, mercuryHeight, mercuryTop, raised;

  raised = document.getElementById("raised").innerHTML;

  goal = document.getElementById("goal").innerHTML;

  raised = raised.replace(/[^0-9\.]+/g, "");

  goal = goal.replace(/[^0-9\.]+/g, "");

  raised = raised * 1;

  goal = goal * 1;

  if (raised > goal) {
    raised = goal;
    document.getElementById("raised").innerHTML = document.getElementById("goal").innerHTML;
  }

  mercury = (raised / goal) * 100;

  displayMercury = mercury.toFixed(2).replace(/\.[0-9][0-9]/, "");

  mercuryHeight = mercury * 250 / 100;

  adjustPx = mercury < 90 ? 18 : 1;

  mercuryTop = 268.47 - (mercury * 2.47);

  mercuryGap = mercuryTop - (25 + adjustPx);

  document.getElementById("towards").innerHTML = displayMercury + "%";

  document.getElementById("rojo").style.height = "" + mercuryHeight + "px";

  document.getElementById("rojo").style.top = "" + mercuryTop + "px";

  if (displayMercury === 100) {
    document.getElementById("rojo").style.display = "none";
    document.write("<style>#thermometer{background-image:url(fullthermometer.gif);}</style>");
  }

  $(document).ready(function() {
    $('#goal_lbl').css("margin-top", "" + adjustPx + "px");
    return $('#raised_lbl').css("margin-top", "" + mercuryGap + "px");
  });

}).call(this);
