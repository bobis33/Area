export interface AuthRepositoryInterface {
    login(user: { email: string; password: string }): Promise<string>
    register(user: { email: string; password: string }): Promise<string>
    verifyToken(token: string): Promise<boolean>
}
