import { defineNuxtRouteMiddleware, useCookie } from '#app'

import { CookiesEnum, RoutesEnum } from '~/config/constants'
import { VerifyToken } from '~/domain/use-cases/auth'
import { LinkToGoogle } from "~/domain/use-cases/oauth";
import { AuthRepository } from '~/infrastructure/repositories/AuthRepository'
import { OauthRepository } from "~/infrastructure/repositories/OauthRepository";

const handleGoogleLink = async (googleToken: string) => {
    const decodedToken = decodeURIComponent(googleToken)

    console.log('decodedToken: ', decodedToken)
    const accessTokenMatch = decodedToken.match(/'access_token':\s*\+?'([^']+)'/)
    if (accessTokenMatch) {
        const accessToken = accessTokenMatch[1]
        console.log('Access Token:', accessToken)
        try {
            await new LinkToGoogle(new OauthRepository()).execute(useCookie(CookiesEnum.TOKEN.toString()).value!, accessToken);
        } catch (error) {
            console.error('Error linking to Google:', error);
        }
        return window.location.href = RoutesEnum.AREAS.toString()
    }
}

const handleGoogleLogin = (token: string) => {
    const tokenCookie = useCookie(CookiesEnum.TOKEN.toString(), { path: '/', maxAge: 60 * 60 * 24 * 7 })
    tokenCookie.value = token
    return window.location.href = RoutesEnum.AREAS.toString()
}

export default defineNuxtRouteMiddleware(async (to) => {
    const isPublicRoute = [RoutesEnum.LOGIN.toString(), RoutesEnum.REGISTER.toString(), RoutesEnum.SETTINGS.toString()].includes(to.path)
    const token = useCookie(CookiesEnum.TOKEN.toString()).value ?? ''
    const query = to.query

    if (query.google_token) {
        await handleGoogleLink(query.google_token as string)
    }

    if (query.token) {
        handleGoogleLogin(query.token as string)
    }


    if (!token && !isPublicRoute) {
        return window.location.href = RoutesEnum.LOGIN.toString()
    }

    if (token && isPublicRoute) {
        return window.location.href = RoutesEnum.AREAS.toString()
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
