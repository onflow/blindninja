'use client'

import { Flex, Box, Text, Button, Link, Container } from '@radix-ui/themes'
import Image from "next/image"
import { useTheme } from 'next-themes';

function InfoBox({ title, subtitle, img, ctaButtonText, cta, isDarkMode }) {
  return (
    <Box width={"350px"} style={{ backgroundColor: isDarkMode ? '#333' : '#fff', borderRadius: '15px', color: isDarkMode ? '#fff' : '#000', width: '250px', height: '250px', paddingTop: '16px', paddingBottom: '12px', textAlign: 'center', border: isDarkMode ? '1px solid #fff' : '1px solid #000' }}>
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
        <Image src='/images/BlindNinja-BG.png' width="800" height="100" style={{ width: '100%', height: '500px', objectFit: 'cover', objectPosition: 'top' }} />
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
          <Container size="1" gap="5" style={{ padding: '100px 0px', textAlign: 'center' }}>
            <Text size="5" id="levels">Select a Level</Text>
            <Flex direction="column" gap="4" mt="5">
              <Link size="4" weight="light" href="/0x5a2170a24ca5da66/IntroLevel">
                <b>IntroLevel</b> by 0x5a2170a24ca5da66
              </Link>
              <Link size="4" weight="light" href="/0x5a2170a24ca5da66/WallsLevel">
                <b>WallsLevel</b> by 0x5a2170a24ca5da66
              </Link>
              <Link size="4" weight="light" href="/0x5a2170a24ca5da66/FogLevel">
                <b>FogLevel</b> by 0x5a2170a24ca5da66
              </Link>
              <Link size="4" weight="light" href="/0x5a2170a24ca5da66/CatchTheFlagLevel">
                <b>CatchTheFlagLevel</b> by 0x5a2170a24ca5da66
              </Link>
            </Flex>
            <br />
          </Container>
        </Flex>

        <Flex style={{ justifyContent: 'center' }} href="https://github.com/onflow/blindninja" target="_blank" rel="noopener noreferrer">
          <img src={resolvedTheme && resolvedTheme === 'dark' ? "/images/github-icon-white.png" : "/images/github-icon.png"} alt="Github" style={{ width: '30px', height: '30px', marginBottom: '20px' }} />
        </Flex>
      </div>
    </>
  )
}
