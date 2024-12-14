import type { AuthRepositoryInterface } from '~/domain/repositories/AuthRepositoryInterface'
import type { User } from '~/domain/models/User'

export class RegisterUser {
    constructor(private authRepository: AuthRepositoryInterface) {}

    async execute(user: User): Promise<string | null> {
        try {
            return await this.authRepository.register(user)
        } catch (error) {
            console.error('Error registering user:', error)
            throw new Error('registerError')
        }
    }
}
