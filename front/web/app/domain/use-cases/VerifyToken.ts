import type { AuthRepositoryInterface } from '~/domain/repositories/AuthRepositoryInterface'

export class VerifyToken {
    constructor(private authRepository: AuthRepositoryInterface) {}

    async execute(token: string): Promise<boolean> {
        if (!token) {
            throw new Error('Token is required');
        }
        return this.authRepository.verifyToken(token);
    }
}
