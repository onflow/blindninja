import "BlindNinjaCore"

// This composable level assumes that a ninja game object
// has been provided, and has the ID of '0'
pub contract ComposableLevel {
  
  pub resource Level: BlindNinjaCore.Level {
    access(all) let name: String
    access(all) let map: {BlindNinjaCore.Map}
    access(all) let gameObjects: {Int: {BlindNinjaCore.GameObject}}
    access(all) let mechanics: [{BlindNinjaCore.GameMechanic}]
    access(all) let visuals: [{BlindNinjaCore.VisualElement}]
    access(all) let winConditions: [{BlindNinjaCore.WinCondition}]
    access(all) let gameboard: BlindNinjaCore.GameBoard

    init(
      name: String,
      map: {BlindNinjaCore.Map},
      gameObjects: {Int: {BlindNinjaCore.GameObject}},
      mechanics: [{BlindNinjaCore.GameMechanic}],
      visuals: [{BlindNinjaCore.VisualElement}],
      winConditions: [{BlindNinjaCore.WinCondition}]
    ) {
      self.name = name
      self.map = map
      self.gameObjects = gameObjects
      self.mechanics = mechanics
      self.visuals = visuals
      self.winConditions = winConditions
      self.gameboard = BlindNinjaCore.GameBoard()
      for object in self.gameObjects.values {
        self.gameboard.add(object)
      }
    }

    access(self) fun handleNinjaMovement(_ curSequence: String) {
      if (curSequence == "ArrowDown") {
        
      }
      if (curSequence == "ArrowUp") {

      }
      if (curSequence == "ArrowRight") {

      }
      if (curSequence == "ArrowLeft") {

      }
    }
    
    access(all) fun tickLevel(curSequence: String): Bool {
      self.handleNinjaMovement(curSequence)
      

      // each tick should pass in the set of mechanics

      // all win conditions should be checked after the above is complete.

      return false
    }
  }

  pub fun createLevel(
    name: String,
    map: {BlindNinjaCore.Map},
    gameObjects: {Int: {BlindNinjaCore.GameObject}},
    mechanics: [{BlindNinjaCore.GameMechanic}],
    visuals: [{BlindNinjaCore.VisualElement}],
    winConditions: [{BlindNinjaCore.WinCondition}]
  ): @Level {
    return <- create Level(
      name: name,
      map: map,
      gameObjects: gameObjects,
      mechanics: mechanics,
      visuals: visuals,
      winConditions: winConditions,
    )
  }
}
