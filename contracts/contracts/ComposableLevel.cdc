import "BlindNinjaCore"


// This composable level provides an easy way to create a BlindNinja
// level using core blind ninja core interfaces as drivers within it.
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

    // Generic way to tick the level making use of all of the mechanics
    // and win conditions provided at initialization time.
    // all mechanics and win conditions are executed in the order
    // of which they were provided.
    access(all) fun tickLevel(level: &BlindNinjaCore.LevelSaveState): Bool {
      let curSequence: String = level.sequence[level.curSequenceIndex]!
      
      // each tick will run every mechanic
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

  // Create a new level given all of the parameters needed
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
