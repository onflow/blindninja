import { Flex, Container } from '@radix-ui/themes'

import Game from '@/components/game/Game.js'
import Navbar from '@/components/ui/Navbar.js'

export default function Home() {

  return (
    <Flex direction="column" style={{ height: '100vh'}}>
      <Navbar/>
      <Container py="8" size="4">
        <Game/>
      </Container>
    </Flex>
  )
}
