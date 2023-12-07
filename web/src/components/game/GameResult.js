import { useEffect, useState } from 'react'

import { Flex, Text, Button } from '@radix-ui/themes'

const GameResult = ({ results, resetGameFunc, setBoardFunc, setFrameIndexFunc }) => {

    var frameIndex = 0
    var [ playing, setPlaying ] = useState(false)

    async function advanceFrame() {
        setPlaying(true)
        setTimeout(() => {
            setBoardFunc(results.frames[frameIndex])
            frameIndex++
            setFrameIndexFunc(frameIndex)
            if (frameIndex < results.frames.length) {
                advanceFrame()
            } else {
                setPlaying(false)
            }
        }, 200)
    }

    useEffect(() => {
        if (results) {
            advanceFrame()
        }
    }, [results])

    return (
        <Flex gap="3" direction="column">            
            <Button
                onClick={resetGameFunc}
                disabled={!results || playing}
            >
                Reset (R)
            </Button>

            {results ? (

            <Flex style={{paddingTop: '20px'}} gap="2">
                <Text>Win: </Text>
                <Text
                    weight="bold"
                    color={results.haswon? 'green': 'red'}
                >
                    {results.haswon? 'Yes': 'No'}
                </Text>
            </Flex>
            ):(
            <Text></Text>
            )}
        </Flex>
    )
}

export default GameResult