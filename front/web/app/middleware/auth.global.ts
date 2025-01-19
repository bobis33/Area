import { defineNuxtRouteMiddleware, useCookie } from '#app'

import { CookiesEnum, RoutesEnum } from '~/config/constants'
import { VerifyToken } from '~/domain/use-cases/auth'
import {LinkToDiscord, LinkToGithub, LinkToGoogle, LinkToSpotify} from "~/domain/use-cases/oauth";
import { AuthRepository } from '~/infrastructure/repositories/AuthRepository'
import { OauthRepository } from "~/infrastructure/repositories/OauthRepository";

const handleGoogleLink = async (googleToken: string) => {
    const decodedToken = decodeURIComponent(googleToken)

    console.log('decodedToken: ', decodedToken)
    const accessTokenMatch = decodedToken.match(/'access_token':\s*\+?'([^']+)'/)
    if (accessTokenMatch) {
        try {
            await new LinkToGoogle(new OauthRepository()).execute(useCookie(CookiesEnum.TOKEN.toString()).value!, accessTokenMatch[1]);
        } catch (error) {
            console.error('Error linking to Google:', error);
        }
        return navigateTo(RoutesEnum.AREAS.toString())
    }
}

const handleDiscordLink = async (discordToken: string) => {
    const decodedToken = decodeURIComponent(discordToken)

    console.log('decodedToken: ', decodedToken)
    const accessTokenMatch = decodedToken.match(/'access_token':\s*\+?'([^']+)'/)
    if (accessTokenMatch) {
        try {
            await new LinkToDiscord(new OauthRepository()).execute(useCookie(CookiesEnum.TOKEN.toString()).value!, accessTokenMatch[1]);
        } catch (error) {
            console.error('Error linking to Discord:', error);
        }
        return navigateTo(RoutesEnum.AREAS.toString())
    }
}

const handleGithubLink = async (githubToken: string) => {
    const decodedToken = decodeURIComponent(githubToken)

    console.log('decodedToken: ', decodedToken)
    const accessTokenMatch = decodedToken.match(/'access_token':\s*\+?'([^']+)'/)
    if (accessTokenMatch) {
        try {
            await new LinkToGithub(new OauthRepository()).execute(useCookie(CookiesEnum.TOKEN.toString()).value!, accessTokenMatch[1]);
        } catch (error) {
            console.error('Error linking to Github:', error);
        }
        return navigateTo(RoutesEnum.AREAS.toString())
    }
}

const handleSpotifyLink = async (spotifyToken: string) => {
    const decodedToken = decodeURIComponent(spotifyToken)

    console.log('decodedToken: ', decodedToken)
    const accessTokenMatch = decodedToken.match(/'access_token':\s*\+?'([^']+)'/)
    if (accessTokenMatch) {
        try {
            await new LinkToSpotify(new OauthRepository()).execute(useCookie(CookiesEnum.TOKEN.toString()).value!, accessTokenMatch[1]);
        } catch (error) {
            console.error('Error linking to Spotify:', error);
        }
        return navigateTo(RoutesEnum.AREAS.toString())
    }
}

const handleGoogleLogin = (token: string) => {
    const tokenCookie = useCookie(CookiesEnum.TOKEN.toString(), { path: '/', maxAge: 60 * 60 * 24 * 7 })
    tokenCookie.value = token
    return navigateTo(RoutesEnum.AREAS.toString())
}

export default defineNuxtRouteMiddleware(async (to) => {
    const isPublicRoute = [RoutesEnum.LOGIN.toString(), RoutesEnum.REGISTER.toString()].includes(to.path)
    const token = useCookie(CookiesEnum.TOKEN.toString()).value ?? ''
    const query = to.query

    if (query.google_token) {
        await handleGoogleLink(query.google_token as string)
    }

    if (query.discord_token) {
        await handleDiscordLink(query.discord_token as string)
    }

    if (query.github_token) {
        await handleGithubLink(query.github_token as string)
    }

    if (query.spotify_token) {
        await handleSpotifyLink(query.spotify_token as string)
    }

    if (query.token) {
        handleGoogleLogin(query.token as string)
    }

    if (!token && !isPublicRoute  && to.path !== RoutesEnum.SETTINGS.toString()) {
        return navigateTo(RoutesEnum.LOGIN.toString())
    }

    if (token && isPublicRoute) {
        return navigateTo(RoutesEnum.AREAS.toString())
    }

    if (token) {
        try {
            const response = await new VerifyToken(new AuthRepository()).execute(token)

            if (!response) {
                useCookie(CookiesEnum.TOKEN.toString()).value = null
                return navigateTo(RoutesEnum.LOGIN.toString())
            }
        } catch (error) {
            console.error('Error verifying token:', error)
            useCookie(CookiesEnum.TOKEN.toString()).value = null
            return navigateTo(RoutesEnum.LOGIN.toString())
        }
    }
})
