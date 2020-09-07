//$.GetContextPanel().SetHasClass("Scoreboard", false);

function AddDebugScore(color) {
  //Make the panel
  var panel = $.CreatePanel("Panel", $("#Scores"), "");
  panel.BLoadLayoutSnippet("Score");
}

function debug() {
  $.Msg("Debug!");
  AddDebugScore("red");
  AddDebugScore("purple");
}

debug();
