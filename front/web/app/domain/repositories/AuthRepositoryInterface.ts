export interface AuthRepositoryInterface {
    login(user: { username: string; password: string }): Promise<string>
    register(user: { username: string; password: string }): Promise<string>
    verifyToken(token: string): Promise<boolean>
}
