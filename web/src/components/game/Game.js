'use client'

import { useEffect, useState } from 'react'
import { Flex, Button, Box, TextArea, Badge, Code, Text, Tabs } from '@radix-ui/themes'

import Board from '@/components/game/Board.js'
import GameResult from '@/components/game/GameResult.js'

import { executeLevel, getInitialBoard } from '@/lib/engine'

const Game = () => {
  const [moves, setMoves] = useState('')
  const [board, setBoard] = useState([['']])
  const [state, setState] = useState('ready')
  const [gameResults, setGameResults] = useState()

  useEffect(() => {
    setBoard(getInitialBoard())
  }, [])

  async function run() {
    setState('executing')
    await new Promise(r => setTimeout(r, 1000));
    setGameResults(executeLevel(moves))
    setState('executed')
  }

  async function resetGame() {
    setMoves('')
    setState('ready')
    setGameResults()
    setBoard(getInitialBoard())
  }

  return (
      <Flex gap="7" justify="center">

        <Flex gap="3" direction="column">
          <Flex align="baseline">
            <Flex ml="0" gap="3" align="baseline">
              <Code variant="ghost">0x34ac358b9819f79d</Code>
              <Badge variant="surface">Mainnet</Badge>
            </Flex>
            <Flex mr="0" grow="1" justify="end">
              <Text size="4" weight="bold">Intro Level</Text>
            </Flex>
          </Flex>

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
              <TextArea
                placeholder="Enter moves (e.g. RRLLDUL)"
                value={moves}
                onChange={(e) => setMoves(e.target.value.toUpperCase())}
              />

              <Button
                onClick={run}
                disabled={state != 'ready'}
              >
                { state === 'ready' && 'Submit' }
                { state === 'executing' && 'Executing ...' }
                { state === 'executed' && 'Done' }
              </Button>

              <Box py="8">
                <GameResult
                  resetGameFunc={resetGame}
                  setBoardFunc={setBoard}
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