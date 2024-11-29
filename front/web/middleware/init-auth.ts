import { defineNuxtRouteMiddleware, navigateTo } from '#app'

export default defineNuxtRouteMiddleware(async (to) => {
    const config = useRuntimeConfig()

    if (import.meta.client) {
        const token = localStorage.getItem('token')

        if (token) {
            try {
                const response = await fetch(`${config.public.baseUrlApi}/auth/protected`, {
                    method: 'GET',
                    headers: {
                        Authorization: `Bearer ${token}`,
                        'Content-Type': 'application/json',
                    },
                })

                if (response.ok) {
                    return navigateTo('/home')
                }

                localStorage.removeItem('token')
                return navigateTo('/login')
            } catch (error) {
                console.log('Erreur lors de la validation du token:', error)
                localStorage.removeItem('token')
                return navigateTo('/login')
            }
        }

        return navigateTo('/login')
    }
})
