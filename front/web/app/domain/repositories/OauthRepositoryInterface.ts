export interface OauthRepositoryInterface {
    linkToGoogle(jwtToken: string, oauthToken: string): Promise<boolean>
    linkToDiscord(jwtToken: string, oauthToken: string): Promise<boolean>
    linkToSpotify(jwtToken: string, oauthToken: string): Promise<boolean>
    linkToGithub(jwtToken: string, oauthToken: string): Promise<boolean>
    linkToGitlab(jwtToken: string, oauthToken: string): Promise<boolean>
}
