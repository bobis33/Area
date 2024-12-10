import { AuthRepository } from '~/domain/repositories/AuthRepository'
import type { User } from "~/domain/models/User";

export const loginUser = async (user: User): Promise<string | null> => {
    try {
        return await new AuthRepository().login(user)
    } catch (error) {
        console.error('Error logging in user:', error)
        throw new Error('loginError')
    }
}
