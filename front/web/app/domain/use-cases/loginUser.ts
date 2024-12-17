import type { AuthRepositoryInterface } from '~/domain/repositories/AuthRepositoryInterface'
import type { User } from '~/domain/models/User'

export class LoginUser {
    constructor(private authRepository: AuthRepositoryInterface) {}

    async execute(user: User): Promise<string | null> {
        try {
            return await this.authRepository.login(user)
        } catch (error) {
            console.error('Error logging in user:', error)
            throw new Error('loginError')
        }
    }
}
