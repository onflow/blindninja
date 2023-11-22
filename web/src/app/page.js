import { Flex, Link } from '@radix-ui/themes'

export default function Home() {
  return (
    <Flex direction="column" gap="4">
      <Link size="4" weight="light" href="/0x622966173915e22a/myNewLevel">
        0x622966173915e22a - myNewLevel
      </Link>
      <Link size="4" weight="light" href="/0x622966173915e22a/WallsLevel">
        0x622966173915e22a - WallsLevel
      </Link>
      <Link size="4" weight="light" href="/0x622966173915e22a/FogLevel">
        0x622966173915e22a - FogLevel
      </Link>
    </Flex>
  )
}
