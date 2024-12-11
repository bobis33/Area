import { AuthRepository } from '~/domain/repositories/AuthRepository'
import type { User } from "~/domain/models/User";

export const registerUser = async (user: User): Promise<string | null> => {
    const authRepository = new AuthRepository()

    try {
        return await authRepository.register(user)
    } catch (error) {
        console.error('Error registering user:', error)
        throw new Error('registerError')
    }
}
