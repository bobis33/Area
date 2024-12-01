import { defineNuxtRouteMiddleware, useCookie, useRouter } from '#app'

export default defineNuxtRouteMiddleware(async (to) => {
    const config = useRuntimeConfig()
    const router = useRouter()

    if (import.meta.client) {
        const token = useCookie('token').value

        if (!token) {
            if (to.path !== '/login' && to.path !== '/register') {
                return router.push('/login')
            }
            return
        }

        try {
            const response = await fetch(`${config.public.baseUrlApi}/auth/protected`, {
                method: 'GET',
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json',
                },
            })

            if (!response.ok) {
                useCookie('token').value = undefined
                if (to.path !== '/login') {
                    return router.push('/login')
                }
                return
            }

            if (to.path === '/login' || to.path === '/register') {
                return router.push('/home')
            }

            if (to.path === '/') {
                return router.push('/home')
            }

        } catch (error) {
            console.log('Error while validating token:', error)
            useCookie('token').value = undefined
            if (to.path !== '/login') {
                return router.push('/login')
            }
        }
    }
})
