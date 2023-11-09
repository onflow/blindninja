import "BlindNinjaCore"

pub contract ComposableLevel {
  pub resource Level: BlindNinjaCore.Level {
    pub let name: String
    pub let map: {BlindNinjaCore.Map}
    pub let gameObjects: [{BlindNinjaCore.GameObject}]
    pub let mechanics: [{BlindNinjaCore.GameMechanic}]
    pub let visuals: [{BlindNinjaCore.VisualElement}]
    pub let winConditions: [{BlindNinjaCore.WinCondition}]

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
  }
}