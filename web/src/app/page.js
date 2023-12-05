import { Flex, Link } from '@radix-ui/themes'

export default function Home() {
  return (
    <Flex direction="column" gap="4">
      <Link size="4" weight="light" href="/0xafff9a8fcdf1f20f/IntroLevel">
        0xafff9a8fcdf1f20f - IntroLevel
      </Link>
      <Link size="4" weight="light" href="/0xafff9a8fcdf1f20f/WallsLevel">
        0xafff9a8fcdf1f20f - WallsLevel
      </Link>
      <Link size="4" weight="light" href="/0xafff9a8fcdf1f20f/FogLevel">
        0xafff9a8fcdf1f20f - FogLevel
      </Link>
    </Flex>
  )
}
