extends Node

var levels_map = {
  "tutorialLevel": "Tutorial Level",
  "birdIntro": "Bird Intro",
  "level-1": "Level 1?",
  "Justin_test_scene": "Justin's scene",
  "JumpingBuilding": "Building Jump",
  "M1": "Crow Graveyard",
  "M2": "Building Jump 2",
  "RoadChase": "Road Chase"
}

var levels = levels_map.keys()
var level_names = levels_map.values()

var selected_starting_level = 0
