import "BlindNinjaCore"

pub contract interface BlindNinjaLevel {
  access(all) var name: String

  // The map and gameobjects can and likely will change during
  //  a game to represent changes in view or gameobject
  access(all) var map: {BlindNinjaCore.Map}
  access(all) var gameObjects: {Int: {BlindNinjaCore.GameObject}}

  // Mechanics are run on every tick, in the order of the given array.
  access(all) var mechanics: [{BlindNinjaCore.GameMechanic}]

  // Win conditions decide how a game could be won.
  // The game's tick will always check if the win conditions are satisfied
  // on each iteration.
  access(all) var winConditions: [{BlindNinjaCore.WinCondition}]

  // Static visuals that do not tick, and are in the background of the game.
  // This also can be used to associate an ID to a visual element for it.
  // This allows you to decouple the gameobjects from their visual counterpart
  // or simply override the default visual element attached to an existing
  // gameobject
  access(all) var visuals: [{BlindNinjaCore.VisualElement}]

  access(all) var state: {String: AnyStruct}

  access(all) var gameboard: BlindNinjaCore.GameBoard

  // Default implementation of providing the initial level
  // state for a UI to show before a player enters in a sequence
  // to execute the game with.
  access(all) fun getInitialLevel(): BlindNinjaCore.LevelResult {
    let activeLevel = BlindNinjaCore.LevelResult(
      map: self.map,
      gameObjects: self.gameObjects,
      hasWonGame: false
    )
    return activeLevel
  }

  // Executes a given sequence given a level from beginning to end.
  access(all) fun executeFullLevel(level: &BlindNinjaCore.LevelSaveState): [BlindNinjaCore.LevelResult] {
    let sequence = level.sequence
    
    level.addResult(self.getInitialLevel())

    var i: Int = 0
    var hasWon = false
    while (i < sequence.length) {
      hasWon = hasWon || self.tickLevel(level: level)
      level.incrementSequenceIndex()
      let curResult = BlindNinjaCore.LevelResult(
        map: level.map,
        gameObjects: level.gameObjects,
        hasWonGame: hasWon
      )
      level.addResult(curResult)
      if (hasWon) {
        return level.tickResults
      }
      i = i + 1
    }
    return level.tickResults
  }

  // Returns true if the game has been won.
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
      for w in self.winConditions {
        hasWonGame = hasWonGame || w.check(level)
      }
      
      return hasWonGame
  }

  access(all) fun addObjectsToGameBoard() {
    for object in self.gameObjects.values {
      self.gameboard.add(object)
    }
  }

  access(all) fun initializeLevel()
}