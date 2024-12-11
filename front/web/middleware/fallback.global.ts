import { defineNuxtRouteMiddleware } from '#app'

import { RoutesEnum } from '~/constants'
import { useAuth } from '~/composables/useAuth'

export default defineNuxtRouteMiddleware(async (to) => {
    const { isAuthenticated, checkAuth } = useAuth()
    const validPaths = Object.values(RoutesEnum).map((route) => route.toString())

    if (import.meta.client) {
        if (!validPaths.includes(to.path)) {
            await checkAuth()

            if (!isAuthenticated.value) {
                return window.location.href = RoutesEnum.LOGIN.toString()
            }
            return window.location.href = RoutesEnum.HOME.toString()
        }
    }
})
