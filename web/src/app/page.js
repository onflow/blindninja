'use client'

import { Flex, Box, Text, Button, Link, Container } from '@radix-ui/themes'
import Image from "next/image"
import { useTheme } from 'next-themes';

function InfoBox({ title, subtitle, img, ctaButtonText, cta, isDarkMode }) {
  return (
    <Box width={"350px"} style={{ backgroundColor: '#F5F5F5', borderRadius: '15px', color: '#000', width: '250px', height: '250px', paddingTop: '16px', paddingBottom: '12px', textAlign: 'center', border: '1px solid #000' }}>
      <Text size="6" weight={"bold"} align={"center"}>{title}</Text>
      <br />
      <br />
      <Text size="9">{img}</Text>
      <br />
      <br />
      <Text size="4" style={{
        padding: '20px',
        width: '236px'
      }}>{subtitle}</Text>
      {
        cta && (
          <>
            <Button style={{marginTop: '16px'}} onClick={() => { cta() }}>{ ctaButtonText }</Button>
          </>
        )
      }
    </Box>
  )
}

export default function Home() {
  const { resolvedTheme } = useTheme()

  return (
    <>
      <div>
        <Image src='/images/BlindNinja-BG.png' width="800" height="100" style={{ width: '100%', height: '500px', objectFit: 'cover', objectPosition: 'top', marginTop: '-9px' }} />
        <Box style={{ position: 'absolute', top: '46px', width: '100vw', height: '300px', background: 'linear-gradient(0deg, rgba(0,0,0,0) 0%, rgba(0,0,0,0.5) 100%)' }}></Box>
        <Text size="9" weight={"bold"} align={"center"} style={{ position: 'absolute', top: '105px', left: '50%', transform: 'translate(-50%, -50%)', fontFamily: 'fantasy', color: '#eee' }}>Blind Ninja</Text>
        <Flex direction={"column"} style={{ marginTop: '-100px', textAlign: 'center' }}>
          <Flex direction={"row"} style={{ paddingBottom: '60px', justifyContent: 'center', zIndex: "10" }} gap={"8"} >
            <InfoBox
              title="Play"
              subtitle="Click to start playing now"
              ctaButtonText="Play"
              cta={() => { document.getElementById('levels').scrollIntoView(); }}
              img="🥷"
              isDarkMode={resolvedTheme && resolvedTheme === 'dark'}
            />
            <InfoBox
              title="Remix"
              subtitle="Modify any level to have your own twist or create new levels from scratch"
              img="✏️"
              isDarkMode={resolvedTheme && resolvedTheme === 'dark'}
            />
            <InfoBox
              title="Share"
              subtitle="Share your progress and newly created levels with friends"
              img="🔗"
              isDarkMode={resolvedTheme && resolvedTheme === 'dark'}
            />
          </Flex>
          <Flex direction={"row"} style={{ justifyContent: "center" }} gap={"2"}>
            <Text size="6">
              Blind Ninja is a fully on-chain and openly moddable game on the Flow Blockchain
            </Text>
            <Image width="30" height="30" src='/images/flow-logo.png'></Image>
          </Flex>
          <Container size="2" gap="5" style={{ padding: '60px 0px', paddingBottom: '40px', textAlign: 'center' }}>
            <Box style={{ backgroundColor: '#F5F5F5', color: '#000', borderRadius: '15px', padding: '40px 30px', border: '1px solid #000' }}>
              <Text size="5" id="levels">Select a Level to Play</Text>
              <br />
              <br />
              <hr />
              <Flex direction="column" gap="4" mt="5" style={{ textAlign: 'center' }}>
                <Link size="4" href="/0x5a2170a24ca5da66/IntroLevel">
                  <b>IntroLevel</b> by 0x5a2170a24ca5da66
                </Link>
                <Link size="4" href="/0x5a2170a24ca5da66/WallsLevel">
                  <b>WallsLevel</b> by 0x5a2170a24ca5da66
                </Link>
                <Link size="4" href="/0x5a2170a24ca5da66/FogLevel">
                  <b>FogLevel</b> by 0x5a2170a24ca5da66
                </Link>
                <Link size="4" href="/0x5a2170a24ca5da66/CatchTheFlagLevel">
                  <b>CatchTheFlagLevel</b> by 0x5a2170a24ca5da66
                </Link>
              </Flex>
            </Box>
            <br />
          </Container>
          <Container size="3" gap="2" style={{ padding: '0px 0px', textAlign: 'left' }}>
            <Text size="7" id="levels" weight={"bold"}>How It Works</Text>
            <br />
            <br />
            <Text size="3" style={{ marginTop: '30px' }}>
              All Blind Ninja level are composed from smart contracts deployed on the Flow Blockchain. This includes the execution of the game and the items on the 2D game board.
              Any developer (or player) can deploy their smart contracts on-chain and play their resulting game directly on this website.
              <br/>
              <br />
              The different types of smart contract types that make up a level are the following:
            </Text>
            <br />
            <br />
            <Flex direction="column" gap="2" mt="5">
              <Flex direction="row">
                <Box style={{ width: '60%', paddingRight: '60px' }}>
                  <Text size="4" weight={"medium"}>
                    Game Object
                    <Link style={{ marginLeft: '6px' }} target='_blank' href="https://github.com/onflow/blindninja/blob/ef3fe14fd68ce84dc463c02d36ad03e1ec0b976a/contracts/contracts/BlindNinjaCore.cdc#L19">🔗</Link>
                  </Text>
                  <br />
                  <Text size="3" width="20px">
                    The visual representation of an object on a level&apos;s 2D gameboard.
                  </Text>
                </Box>
                <Box style={{ width: '40%' }}>
                  <Image src="/images/GameObjects.png" width={"300"} height={"100"} />
                  <Text  size="1">A <Link target='_blank' href="https://github.com/onflow/blindninja/blob/main/contracts/contracts/GameObjects/Ninja.cdc">Ninja</Link> game object and a <Link target='_blank' href="https://github.com/onflow/blindninja/blob/main/contracts/contracts/GameObjects/Flag.cdc">Flag</Link> game object</Text>
                </Box>
              </Flex>
              <br />
              <Flex direction={"row"}>
                <Box style={{ width: '60%', paddingRight: '60px' }}>
                  <Text size="4" weight={"medium"}>
                    Game Mechanic
                    <Link style={{ marginLeft: '6px' }} target='_blank' href="https://github.com/onflow/blindninja/blob/ef3fe14fd68ce84dc463c02d36ad03e1ec0b976a/contracts/contracts/BlindNinjaCore.cdc#L38">🔗</Link>
                  </Text>
                  <br />
                  <Text size="3" width="20px">
                    Game mechanics manage on-screen object interactions and user inputs, updating the 2D gameboard and GameObject positions for a responsive gameplay experience
                  </Text>
                </Box>
                <Box style={{ width: '40%' }}>
                  <Image src="/images/GameMechanics.png" width={"300"} height={"100"} />
                  <Text  size="1" >The <Link href="https://github.com/onflow/blindninja/blob/main/contracts/contracts/GameMechanics/NinjaMovementMechanic.cdc" target='_blank'>NinjaMovementMechanic</Link> allows the ninja to move from a player&apos;s keypress</Text>
                </Box>
              </Flex>
              <br />
              <Flex direction={"row"}>
                <Box style={{ width: '60%', paddingRight: '60px' }}>
                  <Text size="4" weight={"medium"}>
                    Win Condition
                    <Link style={{ marginLeft: '6px' }} target='_blank' href="https://github.com/onflow/blindninja/blob/ef3fe14fd68ce84dc463c02d36ad03e1ec0b976a/contracts/contracts/BlindNinjaCore.cdc#L45">🔗</Link>
                  </Text>
                  <br />
                  <Text size="3" width="20px">
                    Win conditions assess the game&apos;s current state to determine if a player has successfully completed a level
                  </Text>
                </Box>
                <Box style={{ width: '40%' }}>
                  <Image src="/images/WinCondition.png" width={"204"} height={"50"} />
                  <Text  size="1">The <Link target='_blank' href="https://github.com/onflow/blindninja/blob/main/contracts/contracts/WinConditions/NinjaTouchGoalWinCondition.cdc">NinjaTouchGoalWinCondition</Link> allows a player to win the game by directing the ninja to touch a flag.</Text>
                </Box>
              </Flex>
              <br />
              <Flex direction={"row"}>
                <Box style={{ width: '60%', paddingRight: '60px' }}>
                  <Text size="4" weight={"medium"}>
                    Level
                    <Link style={{ marginLeft: '6px' }} target='_blank' href="https://github.com/onflow/blindninja/blob/ef3fe14fd68ce84dc463c02d36ad03e1ec0b976a/contracts/contracts/BlindNinjaLevel.cdc#L3">🔗</Link>
                  </Text>
                  <br />
                  <Text size="3" width="20px">
                    A level is a composition of game objects, game mechanics, and win conditions. A level can also hold state and logic that determines how it is executed, not limited to the functionality within it&apos;s game&apos;s mechanics and objects.
                  </Text>
                </Box>
                <Box style={{ width: '40%' }}>
                  <Image src="/images/GameLevel.png" width={"204"} height={"50"} />
                  <Text size="1">The <Link target='_blank' href='https://github.com/onflow/blindninja/blob/main/contracts/contracts/Levels/IntroLevel.cdc'>IntroLevel</Link> is composed from 4 contracts including 2 Game Objects, 1 Game Mechanic, and 1 Win Condition</Text>
                </Box>
              </Flex>
            </Flex>
            <br />
          </Container>
        </Flex>

        <Flex style={{ justifyContent: 'center', marginTop: '100px' }}>
          <Link href="https://github.com/onflow/blindninja" target="_blank" rel="noopener noreferrer">
            <img src={"/images/github-icon-white.png"} alt="Github" style={{ borderRadius: '30px', backgroundColor: 'black', width: '30px', height: '30px', marginBottom: '20px' }} />
          </Link>
        </Flex>
      </div>
    </>
  )
}
