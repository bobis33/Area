import { defineNuxtRouteMiddleware, useCookie, useRouter } from '#app'
import { CookiesEnum, RoutesEnum } from '~/config/constants'
import { VerifyToken } from '~/domain/use-cases/VerifyToken'
import { AuthRepository } from '~/infrastructure/repositories/AuthRepository'

export default defineNuxtRouteMiddleware(async (to) => {
    const router = useRouter()
    const publicRoutes = [RoutesEnum.LOGIN.toString(), RoutesEnum.REGISTER.toString()]

    if (import.meta.client) {
        const token = useCookie(CookiesEnum.TOKEN.toString()).value

        if (!token) {
            if (!publicRoutes.includes(to.path)) {
                return router.push(RoutesEnum.LOGIN.toString())
            }
            return
        }

        try {
            const response = await new VerifyToken(new AuthRepository()).execute(token)

            if (!response) {
                useCookie(CookiesEnum.TOKEN.toString()).value = null
                if (to.path !== RoutesEnum.LOGIN.toString()) {
                    return router.push(RoutesEnum.LOGIN.toString())
                }
                return
            }

            if (publicRoutes.includes(to.path)) {
                return router.push(RoutesEnum.HOME.toString())
            }

            if (to.path === '/') {
                return window.location.href = RoutesEnum.HOME.toString()
            }

        } catch (error) {
            console.log('Error while validating token:', error)
            useCookie(CookiesEnum.TOKEN.toString()).value = null
            if (to.path !== RoutesEnum.LOGIN.toString()) {
                return router.push(RoutesEnum.LOGIN.toString())
            }
        }
    }
})
