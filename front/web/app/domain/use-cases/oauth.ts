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
