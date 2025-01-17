import type { OauthRepositoryInterface } from '~/domain/repositories/OauthRepositoryInterface'

export class LinkToGoogle {
    constructor(private oauthRepository: OauthRepositoryInterface) {}

    async execute(jwtToken: string, oauthToken: string): Promise<boolean> {
        try {
            return await this.oauthRepository.linkToGoogle(jwtToken, oauthToken)
        } catch (error) {
            console.error('Error linking to Google:', error)
            throw new Error('linkToGoogleError')
        }
    }
}

export class LinkToDiscord {
    constructor(private oauthRepository: OauthRepositoryInterface) {}

    async execute(jwtToken: string, oauthToken: string): Promise<boolean> {
        try {
            return await this.oauthRepository.linkToDiscord(jwtToken, oauthToken)
        } catch (error) {
            console.error('Error linking to Discord:', error)
            throw new Error('linkToDiscordError')
        }
    }
}

export class LinkToSpotify {
    constructor(private oauthRepository: OauthRepositoryInterface) {}

    async execute(jwtToken: string, oauthToken: string): Promise<boolean> {
        try {
            return await this.oauthRepository.linkToSpotify(jwtToken, oauthToken)
        } catch (error) {
            console.error('Error linking to Spotify:', error)
            throw new Error('linkToSpotifyError')
        }
    }
}

export class LinkToGithub {
    constructor(private oauthRepository: OauthRepositoryInterface) {}

    async execute(jwtToken: string, oauthToken: string): Promise<boolean> {
        try {
            return await this.oauthRepository.linkToGithub(jwtToken, oauthToken)
        } catch (error) {
            console.error('Error linking to Github:', error)
            throw new Error('linkToGithubError')
        }
    }
}
