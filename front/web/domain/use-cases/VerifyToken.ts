import { AuthRepository } from '~/domain/repositories/AuthRepository'

export const verifyToken = async (token: string): Promise<boolean> => {
    const authRepository = new AuthRepository()
    return await authRepository.verifyToken(token)
}
