import "BlindNinjaCore"

pub contract ComposableLevel {
  
  pub resource Level: BlindNinjaCore.Level {
    access(all) let name: String
    access(all) let map: {BlindNinjaCore.Map}
    access(all) let gameObjects: [{BlindNinjaCore.GameObject}]
    access(all) let mechanics: [{BlindNinjaCore.GameMechanic}]
    access(all) let visuals: [{BlindNinjaCore.VisualElement}]
    access(all) let winConditions: [{BlindNinjaCore.WinCondition}]

    init(
      name: String,
      map: {BlindNinjaCore.Map},
      gameObjects: [{BlindNinjaCore.GameObject}],
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
    }
    
    access(all) fun tickLevel(activeLevel: BlindNinjaCore.ActiveLevel, curSequence: String): BlindNinjaCore.ActiveLevel {
      return activeLevel
    }
  }


  pub fun createLevel(
    name: String,
    map: {BlindNinjaCore.Map},
    gameObjects: [{BlindNinjaCore.GameObject}],
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