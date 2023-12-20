import * as fcl from "@onflow/fcl"

export const BlindNinjaCoreContractAddress = "0xbe46c97f5d5fdab9"

function renderFrame(frame) {
    var board = new Array(Number(frame.map.viewWidth))
        .fill('').map(()=>new Array(Number(frame.map.viewHeight)).fill(''))

    let anchorX = Number(frame.map.anchorX)
    let anchorY = Number(frame.map.anchorY)

    for (const i in frame.gameObjects) {
        const objX = Number(frame.gameObjects[i].referencePoint[0] - anchorX)
        const objY = Number(frame.gameObjects[i].referencePoint[1] - anchorY)
        let obj = 'X'
        if (frame.gameObjects[i].display) {
            obj = frame.gameObjects[i].display
        }
        if (objX >= 0 && objX < board.length && objY >= 0 && objY < board[0].length) {
            board[objY][objX] = obj
        }
    }
    return board
}

export async function getInitialBoard(address, levelName) {
    const script = `
        import BlindNinjaCore from ${BlindNinjaCoreContractAddress}
        import BlindNinjaLevel from ${BlindNinjaCoreContractAddress}

        pub fun main(address: Address, levelName: String): AnyStruct {
            let level: &BlindNinjaLevel = getAccount(address).contracts.borrow<&BlindNinjaLevel>(name: levelName)!
            level.initializeLevel()
            let activeLevel = level.getInitialLevel()

            return {
                "name": level.name,
                "visuals": level.visuals,
                "map": activeLevel.map,
                "gameObjects": activeLevel.gameObjects
            }
        }
    `
    const result = await fcl.query({
        cadence: script,
        args: (arg, t) => [
            arg(address, t.Address),
            arg(levelName, t.String),
        ]
    })

    console.log("getInitialBoard", result)

    return renderFrame(result)
}

export async function executeLevel(address, levelName, moves) {
    const script = `
        import BlindNinjaCore from ${BlindNinjaCoreContractAddress}
        import BlindNinjaLevel from ${BlindNinjaCoreContractAddress}

        pub fun main(address: Address, levelName: String, moveSequence: [String]): AnyStruct {
            let level: &BlindNinjaLevel = getAccount(address).contracts.borrow<&BlindNinjaLevel>(name: levelName)!
            level.initializeLevel()

            let levelSaveState: @BlindNinjaCore.LevelSaveState <- BlindNinjaCore.createLevelSaveState(
                address: address,
                levelName: levelName,
                map: level.map,
                gameObjects: level.gameObjects,
                gameboard: level.gameboard,
                state: level.state,
                moveSequence: moveSequence,
            )
            let saveState: &BlindNinjaCore.LevelSaveState = &levelSaveState as &BlindNinjaCore.LevelSaveState
            let ticks: [BlindNinjaCore.LevelResult] = level.executeFullLevel(level: saveState)
            destroy levelSaveState

            return ticks
        }
    `
    var movesArray = []
    for (const m of moves) {
        switch (m) {
            case 'U':
                movesArray.push('ArrowUp')
                break
            case 'D':
                movesArray.push('ArrowDown')
                break
            case 'L':
                movesArray.push('ArrowLeft')
                break
            case 'R':
                movesArray.push('ArrowRight')
                break
        }
    }

    const result = await fcl.query({
        cadence: script,
        args: (arg, t) => [
            arg(address, t.Address),
            arg(levelName, t.String),
            arg(movesArray, t.Array(t.String)),
        ]
    })

    console.log("executeLevel", result)

    var haswon = false
    var frames = []
    for (const f of result) {
        if (f.hasWonGame) {
            haswon = true
        }
        frames.push(renderFrame(f))
    }

    return { frames, haswon }
}

export async function getDetailedGameInfo(address, levelName) {
    const script = `
        import BlindNinjaCore from ${BlindNinjaCoreContractAddress}
        import BlindNinjaLevel from ${BlindNinjaCoreContractAddress}

        pub fun addTypesToArray(_ objects: [AnyStruct]): [{String: AnyStruct}] {
            let results: [{String: AnyStruct}] = []
            for o in objects {
            let cur: {String: AnyStruct} = {
                "type": o.getType(),
                "data": o
            }
            results.append(cur)
            }
            return results
        }

        pub fun addTypesToGameObjects(_ map: {Int: {BlindNinjaCore.GameObject}}): {Int: AnyStruct} {
            let newMap: {Int: AnyStruct} = {}
            for key in map.keys {
                let nestedObj: {String: AnyStruct} = {}
                nestedObj["type"] = map[key]!.getType()
                nestedObj["data"] = map[key]!
                newMap[key] = nestedObj
            }
            return newMap
        }

        pub fun addTypeToMap(_ mapObj: BlindNinjaCore.Map): {String: AnyStruct} {
            let newMap: {String: AnyStruct} = {
                "data": mapObj,
                "type": mapObj.getType()
            }
            return newMap
        }

        pub fun main(address: Address, levelName: String): AnyStruct {
            let level: &BlindNinjaLevel = getAccount(address).contracts.borrow<&BlindNinjaLevel>(name: levelName)!
            level.initializeLevel()
            let activeLevel = level.getInitialLevel()

            let mechanics = level.mechanics
            let visuals = level.visuals
            let gameObjects = activeLevel.gameObjects
            let winConditions = level.winConditions

            return {
                "name": level.name,
                "visuals": addTypesToArray(level.visuals),
                "mechanics": addTypesToArray(level.mechanics),
                "winConditions": addTypesToArray(level.winConditions),
                "map": addTypeToMap(activeLevel.map),
                "gameObjects": addTypesToGameObjects(activeLevel.gameObjects)
            }
        }
    `
    const result = await fcl.query({
        cadence: script,
        args: (arg, t) => [
            arg(address, t.Address),
            arg(levelName, t.String)
        ]
    })

    console.log('Detailed game info is', result)

    return result
}

export async function fetchRemixContracts(gameDetailsResult) {

    const contracts = {}

    function addToContracts(type) {
        const address = type.split('.')[1]
        const name = type.split('.')[2]
        if (!(address in contracts)) {
            contracts[address] = {}
        }
        contracts[address][name] = ''
    }

    // gameObjects
    for (const key in gameDetailsResult.gameObjects) {
        addToContracts(gameDetailsResult.gameObjects[key].type.typeID)
    }

    // map
    addToContracts(gameDetailsResult.map.type.typeID)

    // mechanics
    for (const key in gameDetailsResult.mechanics) {
        addToContracts(gameDetailsResult.mechanics[key].type.typeID)
    }

    // visuals
    for (const key in gameDetailsResult.visuals) {
        addToContracts(gameDetailsResult.visuals[key].type.typeID)
    }

    // winConditions
    for (const key in gameDetailsResult.winConditions) {
        addToContracts(gameDetailsResult.winConditions[key].type.typeID)
    }

    for (const address in contracts) {
        const account = await fcl.account(address)
        for (const contract in contracts[address]) {
            contracts[address][contract] = account.contracts[contract]
        }
    }

    console.log('fetchRemixContracts', contracts)

    return contracts
}
