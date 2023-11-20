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
    access(all) let state: {String: AnyStruct}

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
      self.state = {}
      for object in self.gameObjects.values {
        self.gameboard.add(object)
      }
    }

    access(all) fun tickLevel(level: &BlindNinjaCore.LevelSaveState): Bool {
      let curSequence: String = level.sequence[level.curSequenceIndex]!
      
      // each tick should pass in the set of mechanics
      for m in self.mechanics {
        m.tick(level)
      }

      // all win conditions should be checked after the above is complete.
      var hasWonGame = false
      
      // If any of the win condtions are satisfied, then we consider
      // the game as won.
      // TODO: This maybe later should have a mechanism
      // of an 'and' rather than 'or' mechanic.
      for w in self.winConditions {
        hasWonGame = hasWonGame || w.check(level)
      }
      
      return hasWonGame
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
