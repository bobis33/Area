export interface UserRepositoryInterface {
    getUser(): Promise<string>
    updateUsername(username: string): Promise<string>
    updatePassword(password: string): Promise<string>
    updateEmail(email: string): Promise<string>
}
