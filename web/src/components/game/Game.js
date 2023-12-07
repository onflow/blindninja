'use client'

import { useEffect, useState } from 'react'
import { Flex, Button, Box, TextArea, Badge, Code, Text, Tabs } from '@radix-ui/themes'

import Board from '@/components/game/Board.js'
import GameResult from '@/components/game/GameResult.js'
import GameDetails from '@/components/game/GameDetails.js'
import GameInput from '@/components/game/GameInput.js'

import { executeLevel, getInitialBoard, getDetailedGameInfo } from '@/lib/engine'

// Since we are using a window level document listener for key-presses
// this is needed to keep track of the moves since we lose scope in the
// key press listener.
var globalMoves = ""

const Game = ({ address, levelName }) => {

  const [moves, setMoves] = useState('')
  const [board, setBoard] = useState()
  const [state, setState] = useState('ready')
  const [frameIndex, setFrameIndex] = useState(0)
  const [gameResults, setGameResults] = useState()
  const [gameDetails, setGameDetails] = useState({
    gameObjects: null,
    mechanics: null,
    winConditions: null
  })

  useEffect(() => {
    (async () => {
      setGameDetails(await getDetailedGameInfo(address, levelName))
    })().catch(console.error)
  }, [])


  useEffect(() => {
    (async () => {
      setBoard(await getInitialBoard(address, levelName))
    })().catch(console.error)
  }, [])

  useEffect(() => {
    globalMoves = moves
  }, [moves])

  useEffect(() => {
    const handleKeyPress = async (event) => {
      if (event.key === 'r' || event.key === 'R') {
        resetGame();
      }
      if (event.key === ' ') {
        run();
      }
    };
    window.addEventListener('keydown', handleKeyPress);
    return () => {
      window.removeEventListener('keydown', handleKeyPress);
    };
  }, []);

  async function run() {
    setFrameIndex(0)
    setState('executing')
    const executedLevel = await executeLevel(address, levelName, globalMoves)
    setGameResults(executedLevel)
    setState('executed')
  }

  async function resetGame() {
    setFrameIndex(0)
    setState('ready')
    setMoves('')
    setGameResults()
    setBoard(await getInitialBoard(address, levelName))
  }

  return (
      <Flex gap="7" justify="center">

        <Flex gap="3" direction="column">
          <Flex align="baseline">
            <Flex ml="0" gap="3" align="baseline">
              <Text size="4" weight="bold">{levelName}</Text>
            </Flex>
            <Flex mr="0" grow="1" gap="3" justify="end">
              <Code variant="ghost">{address}</Code>
              <Badge variant="surface">Testnet</Badge>
            </Flex>
          </Flex>
          <Box style={{ width: '700px', height: '16px', marginBottom: '10px' }}>
            <GameDetails gameDetails={gameDetails}></GameDetails>
          </Box>
          <Box style={{ width: '700px', height: '700px'}}>
            <Board board={board}/>
          </Box>

        </Flex>

        <Box style={{ width: '200px'}}>

        <Tabs.Root defaultValue="play">
          <Tabs.List>
            <Tabs.Trigger value="play">Play</Tabs.Trigger>
            <Tabs.Trigger value="remix">Remix</Tabs.Trigger>
            <Tabs.Trigger value="info">Info</Tabs.Trigger>
          </Tabs.List>
          <Tabs.Content value="play">

            <Flex mt="5" direction="column" gap="3">
              {/* <Kbd>↑</Kbd>
              <Kbd>↓</Kbd>
              <Kbd>→</Kbd>
              <Kbd>←</Kbd> */}
              <Text weight={"bold"} style={{ marginTop: '10px' }}>How to Play</Text>
              <Text size="2">Give some instructions to the blind ninja and he will follow your lead!</Text>
              <Text weight={"bold"} style={{ marginTop: '10px' }}>How to Win</Text>
              <Text size="2">
                {
                  gameDetails && gameDetails["winConditions"] && Object.keys(gameDetails["winConditions"]).map((key) => {
                    return (
                      <>
                        {gameDetails["winConditions"][key].data.description}
                      </>
                    )
                  })
                }
              </Text>

              <Text weight={"bold"} style={{ marginTop: '10px' }}>Controls</Text>
              
              <GameInput
                moves={moves}
                addMove={(move) => { setMoves(moves + move) }}
                frameIndex={frameIndex}
              />

              <Button
                onClick={run}
                disabled={state != 'ready'}
              >
                { state === 'ready' && 'Simulate (Space Bar)' }
                { state === 'executing' && 'Executing ...' }
                { state === 'executed' && 'Done (Space to Reset)' }
              </Button>

              <Box py="2">
                <GameResult
                  resetGameFunc={resetGame}
                  setBoardFunc={setBoard}
                  setFrameIndexFunc={setFrameIndex}
                  results={gameResults}
                />
              </Box>
            </Flex>
          </Tabs.Content>

          <Tabs.Content value="info">
            <Flex mt="5" mx="3" gap="4" direction="column">
              <Text>GameObjects</Text>
              <Text>Mechanics</Text>
              <Text>Visuals</Text>
            </Flex>
          </Tabs.Content>
        </Tabs.Root>
        </Box>
      </Flex>
  )
}

export default Game