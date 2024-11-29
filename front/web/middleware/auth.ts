import { defineNuxtRouteMiddleware, navigateTo } from '#app'

export default defineNuxtRouteMiddleware(async (to) => {
    const config = useRuntimeConfig()

    if (import.meta.client) {
        const token = localStorage.getItem('token')

        if (!token) {
            return navigateTo('/login')
        }

        try {
            const response = await fetch(`${config.public.baseUrlApi}/auth/protected`, {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json',
                    Authorization: `Bearer ${token}`,
                },
            })

            if (!response.ok) {
                console.log('Token invalide1:', response)
                localStorage.removeItem('token')
                return navigateTo('/login')
            }

        } catch (error) {
            console.log('Erreur lors de la validation du token:', error)
            localStorage.removeItem('token')
            return navigateTo('/login')
        }
    }
})
