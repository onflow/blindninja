import { Flex, Link } from '@radix-ui/themes'

export default function Home() {
  return (
    <Flex direction="column" gap="4">
      <Link size="4" weight="light" href="/0x3b4340bde2cfd675/myNewLevel">
        0x3b4340bde2cfd675 - myNewLevel
      </Link>
      <Link size="4" weight="light" href="/0x3b4340bde2cfd675/WallsLevel">
        0x3b4340bde2cfd675 - WallsLevel
      </Link>
      <Link size="4" weight="light" href="/0x3b4340bde2cfd675/FogLevel">
        0x3b4340bde2cfd675 - FogLevel
      </Link>
    </Flex>
  )
  redirect('/0x3b4340bde2cfd675/myNewLevel')
}
