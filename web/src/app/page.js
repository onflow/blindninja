import { Flex, Link } from '@radix-ui/themes'

export default function Home() {
  return (
    <Flex direction="column" gap="4">
      <Link size="4" weight="light" href="/0x5a2170a24ca5da66/IntroLevel">
        0x5a2170a24ca5da66 - IntroLevel
      </Link>
      <Link size="4" weight="light" href="/0x5a2170a24ca5da66/WallsLevel">
        0x5a2170a24ca5da66 - WallsLevel
      </Link>
      <Link size="4" weight="light" href="/0x5a2170a24ca5da66/FogLevel">
        0x5a2170a24ca5da66 - FogLevel
      </Link>
      <Link size="4" weight="light" href="/0x5a2170a24ca5da66/CatchTheFlagLevel">
        0x5a2170a24ca5da66 - CatchTheFlagLevel
      </Link>
    </Flex>
  )
}
