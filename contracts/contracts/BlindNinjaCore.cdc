
pub contract BlindNinjaCore {

  pub struct interface Map {
    pub let anchorX: Int
    pub let anchorY: Int
    pub let viewWidth: Int
    pub let viewHeight: Int
  }

  pub struct interface GameObject {
    pub var id: UInt64
    pub var type: String
    pub var referencePoint: [Int]

    pub fun setReferencePoint(_ newReferencePoint: [Int]) {
      self.referencePoint = newReferencePoint
    }
  }

  pub struct interface GameMechanic {
    pub let name: String
    pub fun tick(_ level: &BlindNinjaCore.LevelSaveState)
  }

  pub struct interface WinCondition {
    pub fun check(_ level: &BlindNinjaCore.LevelSaveState): Bool
  }

  pub struct interface VisualElement {

  }

  // ------------------------------------------
  // Begin GameBoard struct
  // ------------------------------------------
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

    access(self) fun clearFromBoard(_ referencePoint: [Int]) {
      let x = referencePoint[0]!
      let y = referencePoint[1]!
      var column = self.board[x]!
      column[y] = []
      self.board[x] = column
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
        self.clearFromBoard(gameObject!.referencePoint)
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

  pub struct LevelResult {
    pub let map: {Map}
    pub let gameObjects: {Int: {GameObject}}
    pub let hasWonGame: Bool

    init(map: {Map}, gameObjects: {Int: {GameObject}}, hasWonGame: Bool) {
      self.map = map
      self.gameObjects = gameObjects
      self.hasWonGame = hasWonGame
    }
  }

  // ------------------------------------------
  // Begin Level interface
  // ------------------------------------------
  pub resource interface Level {
    access(all) let name: String

    // The map and gameobjects can and likely will change during
    //  a game to represent changes in view or gameobject,
    // so when a game starts they are copied to a new
    // struct for the 'LevelResult'
    access(all) let map: {Map}
    access(all) let gameObjects: {Int: {GameObject}}

    // ------ Static modifiers that control the level --------

    // Mechanics are run on every tick, in the order of the given array.
    access(all) let mechanics: [{GameMechanic}]

    // Win conditions decide how a game could be won.
    // The game's tick will always check if the win conditions are satisfied
    // on each iteration.
    access(all) let winConditions: [{WinCondition}]

    // Static visuals that do not tick, and are in the background of the game.
    // This also can be used to associate an ID to a visual element for it.
    // This allows you to decouple the gameobjects from their visual counterpart.
    access(all) let visuals: [{VisualElement}]

    access(all) let state: {String: AnyStruct}

    access(all) let gameboard: GameBoard

    // ------ End Static modifiers --------

    // ------ Game Execution --------
    access(all) fun getInitialLevel(): LevelResult {
      let activeLevel = BlindNinjaCore.LevelResult(
        map: self.map,
        gameObjects: self.gameObjects,
        hasWonGame: false
      )
      return activeLevel
    }

    access(all) fun executeFullLevel(level: &LevelSaveState): [LevelResult] {
      let sequence = level.sequence
      
      level.addResult(self.getInitialLevel())

      var i: Int = 0
      var hasWon = false
      while (i < sequence.length) {
        hasWon = hasWon || self.tickLevel(level: level)
        level.incrementSequenceIndex()
        let curResult = LevelResult(
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
    access(all) fun tickLevel(level: &LevelSaveState): Bool
    // ------ End Game Execution -------
  
  }


  pub resource LevelSaveState {
    access(all) let referenceLevelID: UInt64
    access(all) let map: {Map}
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

    init(referenceLevelID: UInt64, map: {Map}, gameObjects: {Int: {GameObject}}, gameboard: GameBoard, state: {String: AnyStruct}, sequence: [String]) {
      self.referenceLevelID = referenceLevelID
      self.map = map
      self.gameObjects = gameObjects
      self.gameboard = gameboard
      self.state = state
      self.tickResults = []
      self.sequence = sequence
      self.curSequenceIndex = 0
    }
  }

  pub fun createLevelSaveState(_ level: &{Level}, _ sequence: [String]): @LevelSaveState {
    return <- create LevelSaveState(
      referenceLevelID: level.uuid,
      map: level.map,
      gameObjects: level.gameObjects,
      gameboard: level.gameboard,
      state: level.state,
      sequence: sequence
    )
  }

  // ------------------------------------------
  // End Level interface
  // ------------------------------------------

  // ------------------------------------------
  // Start level collection
  // ------------------------------------------

  pub resource interface LevelCollectionPublic {
    pub fun getLevel(_ name: String): &{Level}
    pub fun getLevelNames(): [String]
  }

  pub resource LevelCollection: LevelCollectionPublic {
    pub var levels: @{String: {Level}}

    init() {
      self.levels <- {}
    }

    destroy() {
      destroy self.levels
    }

    pub fun addLevel(_ level: @{Level}) {
      let prev <- self.levels[level.name] <- level
      destroy prev
    }

    pub fun getLevel(_ name: String): &{Level} {
      return (&self.levels[name] as &{Level}?)!
    }

    pub fun removeLevel(_ name: String): @{Level}? {
      let level <- self.levels.remove(key: name)
      return <-level
    }

    pub fun getLevelNames(): [String] {
      return self.levels.keys
    }
  }

  pub fun createLevelCollection(): @LevelCollection {
    return <- create LevelCollection()
  }

  // ------------------------------------------
  // End level collection
  // ------------------------------------------
}

