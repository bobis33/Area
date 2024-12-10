import { defineNuxtRouteMiddleware } from '#app'

import { RoutesEnum } from '~/constants'
import { useAuth } from '~/composables/useAuth'

export default defineNuxtRouteMiddleware(async (to) => {
    const { isAuthenticated, checkAuth } = useAuth()
    const publicRoutes = [RoutesEnum.LOGIN.toString(), RoutesEnum.REGISTER.toString(), RoutesEnum.ABOUT.toString()]
    const privateRoutes = [RoutesEnum.HOME.toString(), RoutesEnum.AREAS.toString()]

    if (import.meta.client) {

        await checkAuth()

        if (publicRoutes.includes(to.path) && isAuthenticated.value) {
            window.location.href = RoutesEnum.HOME.toString()
        }

        if (privateRoutes.includes(to.path) && !isAuthenticated.value) {
            window.location.href = RoutesEnum.LOGIN.toString()
        }
    }
})
