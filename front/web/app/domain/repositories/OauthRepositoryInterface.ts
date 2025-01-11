export interface OauthRepositoryInterface {
    linkToGoogle(jwtToken: string, oauthToken: string): Promise<boolean>
}
