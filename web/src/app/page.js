import { Flex, Link } from '@radix-ui/themes'

export default function Home() {
  return (
    <Flex direction="column" gap="4">
      <Link size="4" weight="light" href="/0x565438380ef09966/IntroLevel">
        0x565438380ef09966 - IntroLevel
      </Link>
      <Link size="4" weight="light" href="/0x565438380ef09966/WallsLevel">
        0x565438380ef09966 - WallsLevel
      </Link>
      <Link size="4" weight="light" href="/0x565438380ef09966/FogLevel">
        0x565438380ef09966 - FogLevel
      </Link>
    </Flex>
  )
}
