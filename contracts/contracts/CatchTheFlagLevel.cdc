import "BlindNinjaCore"
import "BlindNinjaLevel"
import "Ninja"
import "Flag"
import "NinjaMovementMechanic"
import "NinjaTouchGoalWinCondition"
import "SpiralMovementMechanic"

// This composable level provides an easy way to create a BlindNinja
// level using core blind ninja core interfaces as drivers within it.
pub contract CatchTheFlagLevel: BlindNinjaLevel {
  access(all) var name: String
  access(all) var map: BlindNinjaCore.Map
  access(all) var gameObjects: {Int: {BlindNinjaCore.GameObject}}
  access(all) var mechanics: [{BlindNinjaCore.GameMechanic}]
  access(all) var visuals: [{BlindNinjaCore.VisualElement}]
  access(all) var winConditions: [{BlindNinjaCore.WinCondition}]
  access(all) var gameboard: BlindNinjaCore.GameBoard
  access(all) var state: {String: AnyStruct}

  init() {
    // This init doesn't really matter, as 'initializeGame' must be called before each interaction with this game.
    // This is setup like this so that the contract can be updated, and the game will reflect those updates.
    let gameObjects: {Int: {BlindNinjaCore.GameObject}} = {}
    self.name = "Intro Level"
    self.map = BlindNinjaCore.Map(
      anchorX: 0,
      anchorY: 0,
      viewWidth: 20,
      viewHeight: 20
    )
    self.gameObjects = gameObjects
    self.mechanics = []
    self.visuals = []
    self.winConditions = []
    self.gameboard = BlindNinjaCore.GameBoard()
    self.state = {}
    self.addObjectsToGameBoard()
  }

  access(all) fun initializeLevel() {
    // Create the ninja for the map
    let ninja = Ninja.GameObject(id: 1)
    ninja.setReferencePoint([6,6])

    // Create the flag to place on the map
    let flag = Flag.GameObject(id: 2)
    flag.setReferencePoint([8,6])

    // Add these objects to the master list of game objects
    // for creating the new level.
    let gameObjects: {Int: {BlindNinjaCore.GameObject}} = {}
    gameObjects[Int(ninja.id)] = ninja
    gameObjects[Int(flag.id)] = flag

    // Create a move mechanic which makes it so that
    // the ninja moves according to the inputted sequence
    // for the level.
    let moveMechanic: {BlindNinjaCore.GameMechanic} = NinjaMovementMechanic.Mechanic(ninjaID: ninja.id)

    let spiralMechanic: {BlindNinjaCore.GameMechanic} = SpiralMovementMechanic.Mechanic(objectID: flag.id)

    // Create a win condition for the level, where the ninja
    // must touch the flag to win.
    let winCondition = NinjaTouchGoalWinCondition.WinCondition(
      ninjaID: ninja.id,
      goalID: flag.id
    )

    // Set all of the contract level variables
    self.name = "Catch the Spiraling Flag!"
    self.map = BlindNinjaCore.Map(
      anchorX: 0,
      anchorY: 0,
      viewWidth: 13,
      viewHeight: 14
    )
    self.gameObjects = gameObjects
    self.mechanics = [ moveMechanic, spiralMechanic ]
    self.visuals = []
    self.winConditions = [ winCondition ]
    self.gameboard = BlindNinjaCore.GameBoard()
    self.state = {}
    self.addObjectsToGameBoard()
  }
}
