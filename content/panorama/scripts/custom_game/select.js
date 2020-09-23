var typeIndex = 1;
var pointsIndex = 1;
var heroIndex = 0;
var type_details = [
  {
    name: "#type_battle_royale",
  },
  {
    name: "#type_death_match",
  },
];

var points_details = [
  {
    name: "#points_7",
  },
  {
    name: "#points_14",
  },
  {
    name: "#points_21",
  },
];
var hero_details = [
  {
    name: "#npc_dota_hero_chen",
  },
  {
    name: "#npc_dota_hero_mirana",
  },
  {
    name: "#npc_dota_hero_batrider",
  },
  {
    name: "#npc_dota_hero_gyrocopter",
  },
  {
    name: "#npc_dota_hero_luna",
  },
  {
    name: "#npc_dota_hero_disruptor",
  },
  {
    name: "#npc_dota_hero_keeper_of_the_light",
  },
  {
    name: "#npc_dota_hero_snapfire",
  },
];

function AddTypes() {
  var panel = $.CreatePanel("Panel", $("#SelectionPanel"), "");
  panel.BLoadLayoutSnippet("TypeSnippet");
}

function AddPoints() {
  var panel = $.CreatePanel("Panel", $("#SelectionPanel"), "");
  panel.BLoadLayoutSnippet("PointsSnippet");
}

function AddCostumes() {
  var panel = $.CreatePanel("Panel", $("#SelectionPanel"), "");
  panel.BLoadLayoutSnippet("HeroSnippet");
}

function OnTypeSelectionEnd() {
  HideTypeSelection();
}

function OnPointsSelectionEnd() {
  HidePointsSelection();
  OnHighlightHero(heroIndex);
}

function OnHeroSelectionEnd() {
  HideHeroSelection();
}

function OnHighlightType(index) {
  typeIndex = index;
  var type_detail = type_details[index];
  $("#TypeName").text = $.Localize(type_detail.name);
  for (var i = 0; i < Object.keys(type_details).length; i++) {
    if (i == index) {
      $("#TypePanel" + index).style["backgroundColor"] = "#0000FF";
    } else {
      $("#TypePanel" + i).style["backgroundColor"] = "#000000";
    }
  }
}

function OnHighlightPoints(index) {
  pointsIndex = index;

  var points_detail = points_details[index];
  $("#PointsName").text = $.Localize(points_detail.name);

  //use Object.keys(hero_details).length to make it dynanic to the length of the "hero_details" dictionary
  for (var i = 0; i < Object.keys(points_details).length; i++) {
    if (i == index) {
      $("#PointsPanel" + index).style["backgroundColor"] = "#0000FF";
    } else {
      $("#PointsPanel" + i).style["backgroundColor"] = "#000000";
    }
  }
}

function OnHighlightHero(index) {
  heroIndex = index;

  var hero_detail = hero_details[index];
  $("#HeroName").text = $.Localize(hero_detail.name);
  //because this doesn't work, it prevents the box from being highlighted
  //for (var i = 0; i < 5; i++) {
  //  $("#HeroAbility" + i).abilityname = hero_detail.abilities[i].icon;
  //}

  //use Object.keys(hero_details).length to make it dynanic to the length of the "hero_details" dictionary
  for (var i = 0; i < Object.keys(hero_details).length; i++) {
    if (i == index) {
      $("#HeroImage" + index).style["backgroundColor"] = "#FFD700";
    } else {
      $("#HeroImage" + i).style["backgroundColor"] = "#000000";
    }
  }
}

function OnTypeMouseOver(index) {
  $.DispatchEvent(
    "DOTAShowTitleTextTooltip",
    $("#TypePanel" + index),
    $.Localize(type_details[index].name),
    $.Localize(type_details[index].name + "_lore")
  );
}

function OnPointsMouseOver(index) {
  $.DispatchEvent(
    "DOTAShowTitleTextTooltip",
    $("#PointsPanel" + index),
    $.Localize(points_details[index].name),
    $.Localize(points_details[index].name + "_lore")
  );
}

function OnHeroMouseOver(index) {
  $.DispatchEvent(
    "DOTAShowTitleTextTooltip",
    $("#HeroImage" + index),
    $.Localize(hero_details[index].name),
    $.Localize(hero_details[index].name + "_lore")
  );
}

function OnTypeMouseOut(index) {
  $.DispatchEvent("DOTAHideTitleTextTooltip");
}

function OnPointsMouseOut(index) {
  $.DispatchEvent("DOTAHideTitleTextTooltip");
}

function OnHeroMouseOut(index) {
  $.DispatchEvent("DOTAHideTitleTextTooltip");
}

function OnSelectType() {
  var type_options = ["battleRoyal", "deathMatch"];
  var payload = {
    type: type_options[typeIndex],
  };
  GameEvents.SendCustomGameEventToServer("js_player_select_type", payload);
  AddPoints();
  OnHighlightPoints(pointsIndex);
}

function OnSelectPoints() {
  var points_options = [7, 14, 21];

  var payload = {
    points: points_options[pointsIndex],
  };

  // $.Msg("payload: " + JSON.stringify(payload));

  //payload gets passed to "gamemode"'s js function as "keys"
  GameEvents.SendCustomGameEventToServer("js_player_select_points", payload);

  //not the "jingle" in the beginning
  //Game.EmitSound("Conquest.capture_point_timer.Generic");

  //open "custom_hero_select.xml"
  AddCostumes();

  OnHighlightHero(heroIndex);
}

function OnSelectHero() {
  var hero_names = [
    "npc_dota_hero_chen",
    "npc_dota_hero_mirana",
    "npc_dota_hero_batrider",
    "npc_dota_hero_gyrocopter",
    "npc_dota_hero_luna",
    "npc_dota_hero_disruptor",
    "npc_dota_hero_keeper_of_the_light",
    "npc_dota_hero_snapfire",
  ];

  var payload = {
    hero_name: hero_names[heroIndex],
  };

  // $.Msg("payload: " + JSON.stringify(payload));

  GameEvents.SendCustomGameEventToServer("js_player_select_hero", payload);

  Game.EmitSound("Conquest.capture_point_timer.Generic");
}

function HideTypeSelection() {
  $("#TypeSelectRoot").visible = false;
}

function ShowTypeSelection() {
  $("#TypeSelectRoot").visible = true;
}

function HidePointsSelection() {
  $("#PointsSelectRoot").visible = false;
}

function ShowPointsSelection() {
  $("#PointsSelectRoot").visible = true;
}

function HideHeroSelection() {
  $("#HeroSelectRoot").visible = false;
}

function ShowHeroSelection() {
  $("#HeroSelectRoot").visible = true;
}

function debug() {
  AddTypes();
  OnHighlightType(typeIndex);
  GameEvents.Subscribe("type_selection_end", OnTypeSelectionEnd);
  GameEvents.Subscribe("points_selection_end", OnPointsSelectionEnd);
  GameEvents.Subscribe("hero_selection_end", OnHeroSelectionEnd);
}

debug();
