pub contract BlindNinjaCore {

  // Interface for defining the map structure in the game.
  pub struct Map {
    pub let anchorX: Int
    pub let anchorY: Int
    pub let viewWidth: Int
    pub let viewHeight: Int

    init(anchorX: Int, anchorY: Int, viewWidth: Int, viewHeight: Int) {
      self.anchorX = anchorX
      self.anchorY = anchorY
      self.viewWidth = viewWidth
      self.viewHeight = viewHeight
    }
  }

  // Interface for game objects within the game environment.
  pub struct interface GameObject {
    pub var id: UInt64
    access(all) var name: String
    access(all) var description: String
    pub var type: String
    pub var referencePoint: [Int]
    pub var display: String

    // Function to set a new reference point for the game object.
    pub fun setReferencePoint(_ newReferencePoint: [Int]) {
      self.referencePoint = newReferencePoint
    }

    pub fun setDisplay(_ newDisplay: String) {
      self.display = newDisplay
    }
  }

  // Interface for game mechanics which can affect the game state.
  pub struct interface GameMechanic {
    access(all) let name: String
    access(all) let description: String
    access(all) fun tick(_ level: &BlindNinjaCore.LevelSaveState)
  }

  // Interface for defining conditions to win the game.
  pub struct interface WinCondition {
    access(all) let name: String
    access(all) let description: String
    access(all) fun check(_ level: &BlindNinjaCore.LevelSaveState): Bool
  }

  // Interface for visual elements within the game.
  pub struct interface VisualElement {
  }

  // Struct representing the game board, handling spatial arrangement of objects.
  pub struct GameBoard {
    // Map of x coordinate to y coordinate to object id
    pub var board: {Int: {Int: [UInt64]}}
    pub var newCollisionPoints: [[Int]]

    access(self) fun addToBoard(_ gameObject: {GameObject}) {
      let referencePoint: [Int] = gameObject.referencePoint
      let x = referencePoint[0]!
      let y = referencePoint[1]!

      if (!self.board.containsKey(x)) {
        self.board[x] = {}
      }
      var column = self.board[x]!
      if (column[y] == nil) {
        column[y] = []
      }
      if (column[y]!.length > 0) {
        self.newCollisionPoints.append(referencePoint)
      }
      column[y]!.append(gameObject.id)
      self.board[x] = column
    }

    access(self) fun clearFromBoard(_ gameObject: {GameObject}) {
      let referencePoint = gameObject.referencePoint
      let x = referencePoint[0]!
      let y = referencePoint[1]!

      var newIDs: [UInt64] = []
      var row = self.board[x]!
      var column = row[y]!
      for id in column {
        if (id != gameObject.id) {
          newIDs.append(id)
        }
      }
      row[y] = newIDs
      self.board[x] = row
    }

    // Add the given gameobject to the gameboard
    pub fun add(_ gameObject: {GameObject}?) {
      if (gameObject != nil) {
        self.addToBoard(gameObject!)
      }
    }

    // Remove this object from the gameboard
    pub fun remove(_ gameObject: {GameObject}?) {
      if (gameObject != nil) {
        self.clearFromBoard(gameObject!)
      }
    }

    pub fun clearCollisionPoints() {
      self.newCollisionPoints = []
    }

    pub fun getIDsAtPoint(_ refPoint: [Int]): [UInt64] {
      return self.board[refPoint[0]!]![refPoint[1]!]!
    }

    init() {
      self.board = {}
      self.newCollisionPoints = []
    }
  }

  // Struct to hold the result of a level in the game.
  pub struct LevelResult {
    pub let map: Map
    pub let gameObjects: {Int: {GameObject}}
    pub let hasWonGame: Bool

    init(map: Map, gameObjects: {Int: {GameObject}}, hasWonGame: Bool) {
      self.map = map
      self.gameObjects = gameObjects
      self.hasWonGame = hasWonGame
    }
  }

  // Resource to save the state of a level during gameplay or to resume
  // gameplay at a later time, assuming a TX needs to batch a level into
  // multiple, or if we want multiple sequences to be submittable to
  // a single level.
  pub resource LevelSaveState {
    access(all) var levelAddress: Address
    access(all) var levelName: String
    access(all) var map: Map
    access(all) let gameObjects: {Int: {GameObject}}
    access(all) let gameboard: GameBoard
    access(all) let state: {String: AnyStruct}
    access(all) let tickResults: [LevelResult]
    access(all) let sequence: [String]
    access(all) var curSequenceIndex: Int

    access(all) fun incrementSequenceIndex() {
      self.curSequenceIndex = self.curSequenceIndex + 1
      self.gameboard.clearCollisionPoints()
    }

    access(all) fun setState(_ key: String,_ value: AnyStruct) {
      self.state[key] = value
    }

    access(all) fun addResult(_ levelResult: LevelResult) {
      self.tickResults.append(levelResult)
    }

    access(all) fun setGameObject(_ id: Int, _ gameObject: {GameObject}) {
      self.gameObjects[id] = gameObject
    }
    
    access(all) fun setMap(_ map: Map) {
      self.map = map
    }

    init(levelAddress: Address, levelName: String, map: Map, gameObjects: {Int: {GameObject}}, gameboard: GameBoard, state: {String: AnyStruct}, sequence: [String]) {
      self.levelAddress = levelAddress
      self.levelName = levelName
      self.map = map
      self.gameObjects = gameObjects
      self.gameboard = gameboard
      self.state = state
      self.tickResults = []
      self.sequence = sequence
      self.curSequenceIndex = 0
    }
  }

  // Function to create a new level save state.
  pub fun createLevelSaveState(
    address: Address,
    levelName: String,
    map: Map,
    gameObjects: {Int: {GameObject}},
    gameboard: GameBoard,
    state: {String: AnyStruct},
    moveSequence: [String]
  ): @LevelSaveState {
    return <- create LevelSaveState(
      levelAddress: address,
      levelName: levelName,
      map: map,
      gameObjects: gameObjects,
      gameboard: gameboard,
      state: state,
      sequence: moveSequence
    )
  }

}

