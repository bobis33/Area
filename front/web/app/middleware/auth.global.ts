import { defineNuxtRouteMiddleware, useCookie } from '#app'
import { CookiesEnum, RoutesEnum } from '~/config/constants'
import { VerifyToken } from '~/domain/use-cases/auth'
import { AuthRepository } from '~/infrastructure/repositories/AuthRepository'

export default defineNuxtRouteMiddleware(async (to) => {
    const publicRoutes = [RoutesEnum.LOGIN.toString(), RoutesEnum.REGISTER.toString()]
    const isPublicRoute = publicRoutes.includes(to.path)
    const token = useCookie(CookiesEnum.TOKEN.toString()).value ?? ''

    if (!token && !isPublicRoute) {
        return window.location.href = RoutesEnum.LOGIN.toString()
    }

    if (token && isPublicRoute) {
        return window.location.href = RoutesEnum.HOME.toString()
    }

    if (token) {
        try {
            const response = await new VerifyToken(new AuthRepository()).execute(token)

            if (!response) {
                useCookie(CookiesEnum.TOKEN.toString()).value = null
                return window.location.href = RoutesEnum.LOGIN.toString()
            }
        } catch (error) {
            console.error('Error verifying token:', error)
            useCookie(CookiesEnum.TOKEN.toString()).value = null
            return window.location.href = RoutesEnum.LOGIN.toString()
        }
    }
})
