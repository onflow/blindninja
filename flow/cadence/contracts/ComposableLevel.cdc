import "BlindNinjaCore"

pub contract ComposableLevel {
  pub resource Level: BlindNinjaCore.Level {
    pub let map: {BlindNinjaCore.Map}
    pub let gameObjects: [{BlindNinjaCore.GameObject}]
    pub let mechanics: [{BlindNinjaCore.GameMechanic}]
    pub let visuals: [{BlindNinjaCore.VisualElement}]
    pub let winCondition: {BlindNinjaCore.WinCondition}

    init(
      map: {BlindNinjaCore.Map},
      gameObjects: [{BlindNinjaCore.GameObject}],
      mechanics: [{BlindNinjaCore.GameMechanic}],
      visuals: [{BlindNinjaCore.VisualElement}],
      winCondition: {BlindNinjaCore.WinCondition}
    ) {
      self.map = map
      self.gameObjects = gameObjects
      self.mechanics = mechanics
      self.visuals = visuals
      self.winCondition = winCondition
    }
  }

  pub fun createLevel(
    map: {BlindNinjaCore.Map},
    gameObjects: [{BlindNinjaCore.GameObject}],
    mechanics: [{BlindNinjaCore.GameMechanic}],
    visuals: [{BlindNinjaCore.VisualElement}],
    winCondition: {BlindNinjaCore.WinCondition}
  ): @Level {
    var level <- create Level(
      map: map,
      gameObjects: gameObjects,
      mechanics: mechanics,
      visuals: visuals,
      winCondition: winCondition
    )

    return <-level
  }
}