'use client'

import { useState, useEffect } from 'react'

import { Button } from '@radix-ui/themes'
import { SunIcon, MoonIcon } from '@radix-ui/react-icons'

import { useTheme } from 'next-themes'

const DarkModeSwitch = () => {
    const [mounted, setMounted] = useState(false)
    const { resolvedTheme, setTheme } = useTheme()

    useEffect(() => {
        setMounted(true)
    }, [])

    if (!mounted) {
        return null
    }

    return (
        <>
            {
                resolvedTheme === 'dark' ? (
                    <Button variant="ghost" onClick={() => setTheme('light')}>
                        <SunIcon color="white" width="24" height="24"/>
                    </Button>
                ) : (
                    <Button variant="ghost" onClick={() => setTheme('dark')}>
                        <MoonIcon color="black" width="24" height="24"/>
                    </Button>
                )
            }
        </>
    )
}

export default DarkModeSwitch