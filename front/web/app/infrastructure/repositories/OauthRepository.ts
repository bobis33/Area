import type { OauthRepositoryInterface } from "~/domain/repositories/OauthRepositoryInterface";

export class OauthRepository implements OauthRepositoryInterface {
    private _baseUrlAPI = useRuntimeConfig().public.baseUrlApi

    async linkToGoogle(jwtToken: string, oauthToken: string): Promise<boolean> {
        try {
            const response = await fetch(`${(this._baseUrlAPI)}/auth/link/google?google_token=${oauthToken}`, {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${jwtToken}`,
                    'Content-Type': 'application/json',
                },
            })
        } catch (error) {
            console.error('There was a problem with the fetch operation:', error)
            return false
        }
        return true
    }

    async linkToDiscord(jwtToken: string, oauthToken: string): Promise<boolean> {
        try {
            const response = await fetch(`${(this._baseUrlAPI)}/auth/link/discord?discord_token=${oauthToken}`, {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${jwtToken}`,
                    'Content-Type': 'application/json',
                },
            })
        } catch (error) {
            console.error('There was a problem with the fetch operation:', error)
            return false
        }
        return true
    }

    async linkToSpotify(jwtToken: string, oauthToken: string): Promise<boolean> {
        try {
            const response = await fetch(`${(this._baseUrlAPI)}/auth/link/spotify?spotify_token=${oauthToken}`, {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${jwtToken}`,
                    'Content-Type': 'application/json',
                },
            })
        } catch (error) {
            console.error('There was a problem with the fetch operation:', error)
            return false
        }
        return true
    }

    async linkToGithub(jwtToken: string, oauthToken: string): Promise<boolean> {
        try {
            const response = await fetch(`${(this._baseUrlAPI)}/auth/link/github?github_token=${oauthToken}`, {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${jwtToken}`,
                    'Content-Type': 'application/json',
                },
            })
        } catch (error) {
            console.error('There was a problem with the fetch operation:', error)
            return false
        }
        return true
    }

    async linkToGitlab(jwtToken: string, oauthToken: string): Promise<boolean> {
        try {
            const response = await fetch(`${(this._baseUrlAPI)}/auth/link/gitlab?gitlab_token=${oauthToken}`, {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${jwtToken}`,
                    'Content-Type': 'application/json',
                },
            })
        } catch (error) {
            console.error('There was a problem with the fetch operation:', error)
            return false
        }
        return true
    }
}